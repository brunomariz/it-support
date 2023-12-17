<h1 align="center">IT Support</h1>

### 1. Linux

##### 1.1 Users

Print user name

```shell
whoami
```

Create user

```shell
sudo adduser USERNAME
```

View users information (/etc/passwd)

```shell
getent passwd [{START_ID..END_ID}]
```

Show account aging information

```shell
chage -l USER
```

Switch user (-: go to users home directory on login)

```shell
su [-] USER
```

Add group to user (-a: append; -G: change user supplementary groups) 

```shell
sudo usermod -aG GROUP1,GROUP2,GROUP3 USER
```

##### 1.2 Groups

Create group

```shell
sudo groupadd GROUP
```

View user groups

```shell
groups [USERNAME]
```

```shell
id [USERNAME]
```

##### 1.3 OS

Print OS info

```shell
uname -a
```

```shell
cat /etc/os-release
```

Create global aliases

https://askubuntu.com/questions/610052/how-can-i-preset-aliases-for-all-users

```shell
# /etc/profile.d/00-aliases.sh

alias ll='ls -alH'
```

##### 1.4 Permissions

Change permissions (replace 000 (ugo) for the desired permission (r,w,x -> 4,2,1) for user, group and others)

```shell
sudo chmod 000 FILE
```

```shell
sudo chmod [ugoa][+-=][rwx] FILE
```


Change ownership of files or directories

```shell
sudo chown USER:GROUP FILE
```

```shell
sudo chrgrp GROUP FILE # can be used by non root users on files they own
```

##### 1.5 Network

Show network interfaces with status

```shell
ip link
```

Show ip address configuration

```shell
ip addr
```

Print ip address

```shell
hostname -I
```

Bring up/down a linux network interface

```shell
sudo ifup [INTERFACE]
```

```shell
sudo ifdown [INTERFACE]
```




