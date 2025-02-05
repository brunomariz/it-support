# Create an NFS on image file

Sometimes, you might want to create an NFS, but your server's disk might not have any empty space for a new partition. 
One way to achieve this is to shrink an existing partition, which is troublesome, as it requires a backup.
Instead, it is also possible to generate a fixed size image file, on which you can create a file system, mount it, and share it with NFS. 

Here are the steps:

### 1. Create a 100 GB Disk Image

```
sudo mkdir /nfs_storage # This is where the image will be. Make sure the partition where you're creating this directory has enough space for the image.
sudo fallocate -l 100G /nfs_storage/share.img
```

Or use dd (slower but works on all systems):

```
sudo dd if=/dev/zero of=/nfs_storage/share.img bs=1G count=100
```

### 2. Format It

```
sudo mkfs.xfs /nfs_storage/share.img  # Use XFS (or ext4 if needed)
```

### 3. Create and Mount the Share Folder

```
sudo mkdir -p /share
sudo mount -o loop /nfs_storage/share.img /share
```

### 4. To make it persistent across reboots, add this to /etc/fstab:

```
/nfs_storage/share.img /share xfs loop 0 0
```

### 5. Create a data directory

```
mkdir /share/data
chmod 777 /share/data
```

### 6. Create the NFS share

Share the `/share/data` directory mounted on the image using the NFS ansible role with a playbook such as:

```
- name: Configure share NFS server
  hosts: nfsserver.gres.internal
  become: true
  gather_facts: true

  roles:
    - role: nfs
      vars:
        # Global configuration vars
        # Path exported from server
        NFS_SERVER_SHARE_PATH: /share/data
        # Define if server taks should be ran on hosts
        NFS_CONFIGURE_SERVER: true
        # Server configuration vars
        NFS_CLIENTS_IP: "*"
        NFS_CLIENTS_NETMASK: 255.255.255.0

- name: Configure NFS client
  hosts: nfsclient.gres.internal
  become: true
  gather_facts: true

  roles:
    - role: nfs
      vars:
        # Global configuration vars
        # Path exported from server
        NFS_SERVER_SHARE_PATH: /share/data
        # Define if client taks should be ran on hosts
        NFS_CONFIGURE_CLIENT: true
        # Client configuration vars
        NFS_SERVER_IP: nfsserver.ndf.internal
        NFS_MOUNTED_DIR: /share/data
```

### 7. Check the export on server and client

```
# On the client
df -h
```

```
# On the server
cat /etc/exports
exportfs -v
```
