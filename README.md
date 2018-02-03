Generic Development Setup for Docker on Mac

I am testing a generic docker development setup for mac

## Prerequisites
```
brew install supervisor
brew install fsevents-tools
```

## Create Demo project
```
git clone https://github.com/sseidenthal/docker_development_setup.git my_project
cd my_project
```

## Play with it
```
make
make start
make ps
make log.unison
```

This is only a demo, you could imagine a lot of useful features to the Makefile
