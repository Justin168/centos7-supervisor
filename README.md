# CentOS-7 with supervisord launcher | Docker
This is a CentOS-7 Docker based on [million12/centos-supervisor](https://registry.hub.docker.com/u/million12/centos-supervisor/) image, perfect in case when you need to launch more then one process inside a container. This image is based on official [centos:centos7](https://registry.hub.docker.com/_/centos/) and it adds only ca. 20MB on top of it.

## What's included

##### - bootstrap.sh script

The container has an **ENTRYPOINT** set to `/config/bootstrap.sh`. It iterates through all `/config/init/*.sh` scripts and runs them, then launches supervisord. See [bootstrap.sh](container-files/config/bootstrap.sh) for details.

By default, the **CMD** option in Dockerfile is empty, but the bootstrap.sh script is configured to run everything which is passed into it. Therefore you can launch it in several ways:
* detached mode, no argument(s) passed: supervisord starts in foreground mode and stays until container is stopped.
* detached mode, some argument(s) passed: arguments are executed; supervisord starts in foreground mode and stays until container is stopped.
* interactive mode with TTY (-it), no argument(s) passed: supervisord starts in background mode; interactive bash waits for user input. Exiting from bash (CMD+D) exists the container.
* interactive mode with TTY (-it), some argument(s) passed: supervisord starts in background mode, passed command is executed; container exits.

##### - supervisord

Supervisord is installed and loads services to run from `/etc/supervisor.d/` directory. Add your own files there to launch your services. For example in your `Dockerfile` you could put:  
```ADD my-supervisord-service.conf /etc/supervisord.d/my-supervisord-service.conf```

Learn more about about [supervisord inside containers on official Docker documentation](https://docs.docker.com/articles/using_supervisord/).

##### - init scripts

You can add your .sh scripts to `/config/init` directory to have them executed when container starts. The bootstrap script is configured to run them just before supervisord starts. See [million12/nginx](https://github.com/million12/docker-nginx) for example usage.

##### - error logging

Logfile for supervisord is switched off to avoid logging inside container. Instead, all logs are easily available via `docker logs [container name]`.

This is probably the best approach if you would like to source your logs from outside the container via `docker logs` (also via CoreOS `journald') and you do not want to worry about logging and log management inside your container and/or data volume.

Recommended structure:  
```
/data/run/ # pid, sockets
/data/conf/ # extra configs for your services
/data/logs/ # logs
```

## Usage

As explained above, this container is configured to run your service(s) both in interactive and non-interactive modes.
  
`docker run -it reynierpm/centos7-supervisor`: runs supervisord, then interactive bash shell and waits for user's input. Exiting from the shell kills the container.

`docker run -it reynierpm/centos7-supervisor ps aux`:  runs supervisord, then `ps aux` command inside container and exists.

`docker run -it reynierpm/centos7-supervisor top`:  runs supervisord, then `top` tool. Exiting from top exits the container.

`docker run -d reynierpm/centos7-supervisor`: detached, runs supervisord in foreground mode and its configured services

## Build

`docker build --tag=reynierpm/centos7-supervisor .`
