# Networking tools

## Set host IP

Check the connection name with `nmcli con show`, then 

```
nmcli con mod "Wired connection 1" ipv4.method manual ipv4.addr "192.168.1.X/24" +ipv4.dns 192.168.1.4 ipv4.gateway 192.168.1.1
```

```
nmcli con down "Wired connection 1" && nmcli con up "Wired connection 1"
```

## Image contents

- ipcalc

## Build

```shell
docker build . -t networking
```

## Run

### Using `tempc` temporary container

Download and install tempc from [this repo](https://github.com/brunomariz/user-bin) 

```shell
tempc networking
```

##### On host network

Use additional docker options to determine the container's network

```shell
tempc -- --net host networking
```

### Using Docker

```shell
docker run --rm -it networking /bin/bash 
```
