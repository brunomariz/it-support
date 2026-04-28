# SSH to containers with fixed ip

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/ubuntu/)

### Setup

Run each of these commands on a separate terminal to create a docker network and the containers that will be used.

1. Create a docker network with a user defined subnet

```shell
docker network create --subnet=172.18.0.0/16 my-net
```

2. Create ubuntu containers connected to that network, and define their ip addresses

```shell
docker run -it --rm --name admin --net my-net --ip 172.18.0.100 ubuntu bash
```
```shell
docker run -it --rm --name pc1 --net my-net --ip 172.18.0.101 ubuntu bash
```
```shell
docker run -it --rm --name pc2 --net my-net --ip 172.18.0.102 ubuntu bash
```

3. [Create sudo users for pc1 and pc2](create_sudo_user.md)

4. Install ssh server on pc1 and pc2 and ssh client on admin

- PC1 and PC2 containers:

```shell
apt install openssh-server
```

```shell
service ssh start
```

- Admin container:

> Obs: you might need to run `apt update` before

```shell
apt install openssh-client
```

5. Edit admins /etc/hosts by adding the lines

```
172.18.0.100	admin
172.18.0.101     pc1
172.18.0.102     pc2
```

/etc/hosts should look something like this:

```
  127.0.0.1	localhost
  ::1	localhost ip6-localhost ip6-loopback
  fe00::0	ip6-localnet
  ff00::0	ip6-mcastprefix
  ff02::1	ip6-allnodes
  ff02::2	ip6-allrouters
+ 172.18.0.100	admin
+ 172.18.0.10     pc1
+ 172.18.0.11     pc2
```

### Creating connection

6. Connect from admin container

```shell
ssh user1@pc1
```

```shell
ssh user2@pc2
```


