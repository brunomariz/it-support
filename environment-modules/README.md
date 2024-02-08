# Environment Modules

### Installation

Running on a VirtualBox VM

OS: Rocky Linux 9.3 minimal

- Docs: https://modules.readthedocs.io/en/latest/
    - `dnf install -y environment-modules`
necessary to reload the shell or `source PREFIX/init/bash` after installing. In this case, PREFIX is `/usr/share/Modules`. A relogin will work because it will execute the source command in the `/etc/profile.d/modules.sh` file.

### Example

#### Go

Let's download Go and create a modulefile. Normally, you would install Go by downloading a compressed tar file and adding /usr/local/go/bin to the PATH environment variable. This would be done, for example, by adding export `PATH=$PATH:/usr/local/go/bin` to $HOME/.profile or /etc/profile. However, if we want to have different Go versions availiable, we can instead create environment modules that add different go installations to the PATH variable when we load the module.

##### Downloading Go

```shell
export GOVERSION=1.20.10 OS=linux ARCH=amd64  # change this as you need
```


```shell
wget -O /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz \
  https://dl.google.com/go/go${GOVERSION}.${OS}-${ARCH}.tar.gz
```

```shell
sudo tar -C /usr/local -xzf /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz
```

This will add the Go binary executable to /usr/local/go.

##### Creating modulefile

Lets create a modulefile to add /usr/local/go to the PATH variable.

To view your modulefiles paths or add new ones use
```shell
module avail # view availiable modules and their locations
module use --append /home/aturing/Modules/modulefiles # append new location to MODULEPATH
``` 

Source: https://researchcomputing.princeton.edu/support/knowledge-base/custom-modules


Let's create our modulefile in the default modulefiles dir
```shell
cd /usr/share/Modules/modulefiles
mkdir go
cd go
vim 1.20.10 # create the modulefile name as the version of go you downloaded  
``` 

Then add the following script to append your Go install's bin directory to the PATH variable
```shell
#%Module

proc Modules { } {
    puts stderr "This module adds Go to your path"
}

module-whatis "This module adds go to your path\n"

set basedir "/usr/local/go"
prepend-path PATH "${basedir}/bin"

``` 

Now check if it works

```shell
go version
-bash: gi: command not found
module load go/1.20.10
go version
go version go1.20.10 linux/amd64
```
 
