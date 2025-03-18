## How to add space to `/` and remove space from `/home`

### Downsize `/home`

- Create a backup of the `/home` directory

This will delete all the files in the /home directory, so make sure to create a backup first. Also make sure the backup is not in the `/home` directory.

```
tar -czvf /backup/home.tgz -C /home .
```

- View free space with `vgdisplay`

- Remove the `/home` partition

```
umount /dev/mapper/rl-home
lvremove /dev/mapper/rl-home
```

-  Create new partition

```
lvcreate -L <new-size>GB -n home rl
```

-  Format it with XFS

```
mkfs.xfs /dev/rl/home
```

- Mount the file system

```
mount /dev/mapper/rl-home
```

- Restore the backup

```
tar -xzvf /backup/home.tgz -C /home
```

### Increase `/`

- Extend logical volume

```
lvextend -L <new-size>G /dev/mapper/rl-root
```

If you want to use all the free space, it is possible to use `-l +100%FREE` instead of `-L <new-size>G`.

- Extend the file system

```
xfs_growfs /
```
