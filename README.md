Generic Development Setup for Docker on Mac

I am testing a generic docker development setup for mac

## Prerequisites
```
brew install supervisor
brew install fsevents-tools
brew install dialog
brew install unison
brew install jq
```

## Create Demo project
```
git clone https://github.com/sseidenthal/docker_development_setup.git my_project
cd my_project
```

## How to get started for the first time

steps described in this chapter are "one time only"

### 1. checkout your code
```
make install
```

### 2. create your devbox (can take a few minutes)
this command will create a virtual machine with all the stuff you need to get started
```
make vagrant.up
```

### 3. add your devbox to docker-machine
this will install the latest version of docker inside you devbox and add devbox to your local docker-machine
```
make docker.machine.create
```

## Daily use
 - this will start your containers (as defined in docker.compose files) inside your devbox
 - this will start automatic synchronization of files from your computer to you devbox. (as defined inside config.json)
```
make start
```


## Play with it
```
make
make vagrant.up #tis will start your devbox
make docker.machine.create # will add your new devbox as docker-machine
make install
make start
make docker.os
make docker.enter
make unison.log
make stop
```

This is only a demo, you could imagine a lot of useful features to the Makefile
