# SSH to containers with fixed ip

## Prerequisites

- Docker

### Setup

```shell
docker network create --subnet=172.18.0.0/16 my-net
```

```shell
docker run -it --rm --name admin --net my-net --ip 172.18.0.100 ubuntu bash
```
```shell
docker run -it --rm --name pc1 --net my-net --ip 172.18.0.101 ubuntu bash
```
```shell
docker run -it --rm --name pc2 --net my-net --ip 172.18.0.102 ubuntu bash
```

[Create sudo users for pc1 and pc2](create_sudo_user.md)

Install ssh server on pc1 and pc2 and ssh client on admin

Client:

```shell
apt install openssh-server
```

```shell
service ssh start
```

Admin:

```shell
apt install openssh-client
```

Edit admins /etc/hosts by adding the lines

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

Connect from admin container

```shell
ssh user1@pc1
```

```shell
ssh user2@pc2
```


