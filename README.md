# IT Support


### 1. Linux

##### 1.1 Users

Create user

```shell
sudo adduser USERNAME
```

View users information (/etc/passwd)

```shell
getent passwd
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
id
```
