# Apptainer

Secure alternative to Docker on shared user machines.

### Installation

Following https://github.com/apptainer/apptainer/blob/main/INSTALL.md, but instead of adding Go to PATH by appending 'export PATH=$PATH:/usr/local/go/bin' to ~/.bashrc, added to PATH with [environment modules](../environment-modules)

### Example SIF

```shell
BootStrap: docker
From: ubuntu:22.04

%post
   apt-get -y update
   apt-get -y install cowsay lolcat

%environment
   export LC_ALL=C
   export PATH=/usr/games:$PATH

%runscript
   date | cowsay | lolcat

%labels
   Author Alice
```