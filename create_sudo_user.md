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

```shell
groups
```
