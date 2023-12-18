# How to create a sudo user from scratch

## Prerequisites

- Docker

### Setup

Create a new ubuntu docker container

```shell
docker run -it --rm ubuntu bash
```

### Creating user

Create a new user

```shell
adduser user
```

### Adding sudo group

Install the sudo package

```shell
apt update && apt install sudo
```

Add user to sudo group

```shell
usermod -aG sudo user
```

## Testing

```shell
cat /etc/group | grep sudo
```

Log into user to test

```shell
su - user
```

Create a file

```shell
sudo touch file
```

List file details

```shell
ls -l
```

File is owned by root

```console
-rw-r--r-- 1 root root 0 Dec 18 21:02 file
```
