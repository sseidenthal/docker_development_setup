SHELL=/bin/bash

#description     :This Makefile will help you run complex docker development setups
#author		 	 :Steve Seidenthal
#date            :2012-02-03
#version         :0.1    
#usage		 	 :make, then follow the instructions

#launchctl load ./$${i%?}/sync.plist;

CURRENT_RELEASE := $(shell uname -s)
PWD := $(shell pwd)
CONTAINER := $(shell $1)

hello:
	@echo "Hello Developer, how can i help you ;)"
	@echo "  - make install, creates project folder and checks out repositories as defined in config.json" 
	@echo "  - make start, starts the project" 
	@echo "  - make stop, stops the project" 
	@echo "  - make unison, see unison helpers" 
	@echo "  - make docker, see docker helpers" 

check-os:
ifneq ($(CURRENT_RELEASE), Darwin)
	$(error "this script currently only supports macOs, feel free to extend it.")
endif

restart: check-os stop start

install: check-os

	#create project/service folder an checks out code
	.helpers/repositories.sh

start: check-os
	
	#generating a config file for supervisord
	.helpers/generate_supervisor.sh
	
	#running supervisor in order to keep sync helper running in the background
	supervisord -c .helpers/conf/supervisor.conf

	#start the container
	docker-compose up -d

stop: check-os
	
	#shutdown supervisor because we do not need to sync when projects are stopped
	supervisorctl shutdown

	#stop containers
	docker-compose down

docker:
	@echo "Docker Helpers"
	@echo "  - make docker.ps, gets you a list of running container" 
	@echo "  - make docker.enter, let's you enter in your containers" 

docker.ps:
	clear;docker ps --format '{{.Names}}'

docker.enter:
	.helpers/docker_ps_menu.sh
	#clear;docker exec -it $${1} bash

unison:
	@echo "Unison Helpers"
	@echo "  - make unison.log, shows ~/unison.log useful when debugging sync issues" 

unison.log:
	clear;tail -f ~/unison.log
