# Networking tools

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
