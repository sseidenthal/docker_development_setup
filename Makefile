SHELL=/bin/bash

#description     :This Makefile will help you run complex docker development setups
#author		 	 :Steve Seidenthal
#date            :2012-02-03
#version         :0.1    
#usage		 	 :make, then follow the instructions

CURRENT_RELEASE := $(shell uname -s)
PWD := $(shell pwd)
CONTAINER := $(shell $1)

IS_UNISON_INSTALLED := $(shell which unison)
IS_SUPERVISOR_INSTALLED := $(shell which supervisord)
IS_DIALOG_INSTALLED := $(shell which dialog)
IS_NOTIFYLOOP_INSTALLED := $(shell which notifyloop)

hello:
	@echo "Hello Developer, how can i help you ;)"
	@echo "  - make install, creates project folder and checks out repositories as defined in config.json" 
	@echo "  - make start, starts the project" 
	@echo "  - make stop, stops the project" 
	@echo "  - make unison, see unison helpers" 
	@echo "  - make docker, see docker helpers" 

check-dependencies:
ifeq ($(IS_UNISON_INSTALLED), )
	$(error "unison is not installed, please run `brew install unison`")
endif

ifeq ($(IS_DIALOG_INSTALLED), )
	$(error "dialog is not installed, please run `brew install dialog`")
endif

ifeq ($(IS_NOTIFYLOOP_INSTALLED), )
	$(error "notifyloop is not installed, please run `brew install fsevents-tools`")
endif

ifeq ($(IS_SUPERVISOR_INSTALLED), )
	$(error "supervisord is not installed, please run `brew install supervisor`")
endif


check-os: check-dependencies
ifneq ($(CURRENT_RELEASE), Darwin)
	$(error "this script currently only supports macOs, feel free to extend it.")
endif

restart: check-os stop start

install: check-os

	@# create project/service folder an checks out code
	@.helpers/main.sh checkout

start: check-os
	
	@# generating a config file for supervisord
	@.helpers/generate_supervisor.sh
	
	@# running supervisor in order to keep sync helper running in the background
	@supervisord -c .helpers/conf/supervisor.conf

	@# start the container
	@.helpers/main.sh compose_up

stop: check-os
	
	@# shutdown supervisor because we do not need to sync when projects are stopped
	@supervisorctl shutdown

	@# stop containers
	@.helpers/main.sh compose_down

docker:
	@echo "Docker Helpers"
	@echo "  - make docker.ps, gets you a list of running container" 
	@echo "  - make docker.enter, let's you enter in your containers" 
	@echo "  - make docker.logs, let's you see log files of containers" 

docker.ps:
	@docker ps --format '{{.Names}}'

docker.enter:
	@.helpers/docker_ps_menu.sh

docker.logs:
	@.helpers/docker_log_menu.sh
	
unison:
	@echo "Unison Helpers"
	@echo "  - make unison.log, shows ~/unison.log useful when debugging sync issues" 

unison.log:
	@tail -f ~/unison.log
