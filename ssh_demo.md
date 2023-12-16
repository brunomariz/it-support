# SSH Demo

This file is a guide for creating an SSH client and server on separate containers for demonstration purposes.

### Prerequisites

- [Docker](https://docs.docker.com/engine/install/ubuntu/)

### Create containers

1. Open two terminal windows
2. Run ubuntu containers on both terminals

```shell
docker run --rm -it ubuntu /bin/bash
```

To check this step, you can open a new third terminal window on your host machine, 
and run `docker ps` to see the new containers running. The output should look something
like this:

```console
~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
4317b6ea601c   ubuntu    "/bin/bash"   34 seconds ago   Up 34 seconds             heuristic_meninsky
b9eaf4228eec   ubuntu    "/bin/bash"   38 seconds ago   Up 38 seconds             lucid_williamson
```

3. Run `apt update` on both containers

```shell
apt update
```

### Setup server container 

4. Choose arbitrarily which container is the client and the server. On the terminal window running the 
container you chose as the server, run the command:

```shell
apt install openssh-server
```

5. Start the ssh server

```shell
service ssh start
```

6. Create a new user on the server container, on which the client will log in

```shell
adduser brini
```

Fill in the information and make sure to remember the password, as it will be used when we connect from the client

```console
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for brini
Enter the new value, or press ENTER for the default
	Full Name []: 
	Room Number []: 
	Work Phone []: 
	Home Phone []: 
	Other []: 
Is the information correct? [Y/n] Y
```

7. You can now switch to the new user with the command `su - USER` and make modifications on the files if you
want to see them on the client

```shell
su - brini
```

```console
brini@4317b6ea601c:~$ mkdir test
brini@4317b6ea601c:~$ ls 
test
```

8. Finally, get the server container's IP address. Keep this address in mind, as it will be used when we connect from the client

```shell
hostname -I
```

```
172.17.0.3 
```

### Setup client container

9. On the terminal window running the container you chose as client, 
run the command:

```shell
apt install openssh-client
```

10. Create the ssh connection with the command `ssh USER@IP_ADDRESS`

```shell
ssh brini@172.17.0.3
```

11. After inserting the password, use the server remotely from the client container

```console
brini@4317b6ea601c:~$ echo "hello!" >> test/file.txt
```

### See changes on server

12. Back on the server container, check if remote changer appear

```console
brini@4317b6ea601c:~$ cd test/
brini@4317b6ea601c:~/test$ ls
file.txt
brini@4317b6ea601c:~/test$ cat file.txt 
hello!
```


