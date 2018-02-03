#description     :This Makefile will help you run complex docker development setups
#author		 	 :Steve Seidenthal
#date            :2012-02-03
#version         :0.1    
#usage		 	 :make, then follow the instructions

#launchctl load ./$${i%?}/sync.plist;

CURRENT_RELEASE := $(shell uname -s)
PWD := $(shell pwd)

hello:
	@echo "Hello Developer, how can i help you ;)"
	@echo "  - make start, starts the project" 
	@echo "  - make stop, stops the project" 
	@echo "  - log_unison, take a lock a your unison log file" 
	@echo "  - ps, get a list of my running containers" 

check-os:
ifneq ($(CURRENT_RELEASE), Darwin)
	$(error "this script currently only supports macOs, feel free to extend it.")
endif

restart: check-os stop start

start: check-os

	clear; \
	echo "[supervisord]" > .helpers/conf/supervisor.conf; \
	echo "nodaemon=false" >> .helpers/conf/supervisor.conf; \
	echo "" >> .helpers/conf/supervisor.conf; \
	echo "[supervisorctl]" .helpers/conf/supervisor.conf; \
	echo "" >> .helpers/conf/supervisor.conf; \
	echo "[inet_http_server]" >> .helpers/conf/supervisor.conf; \
	echo "port = 127.0.0.1:9001" >> .helpers/conf/supervisor.conf; \
	echo "" >> .helpers/conf/supervisor.conf; \
	echo "[rpcinterface:supervisor]" >> .helpers/conf/supervisor.conf; \
	echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> .helpers/conf/supervisor.conf; \
	echo "" >> .helpers/conf/supervisor.conf; \
	clear; \
	for i in `echo */`; \
	do \
		echo "[program:$${i%?}]" >> .helpers/conf/supervisor.conf; \
		echo "command=/usr/local/bin/notifyloop ${PWD}/$${i} .helpers/unison.sh $${i%?} ${PWD}" >> .helpers/conf/supervisor.conf; \
		echo "" >> .helpers/conf/supervisor.conf; \
	done; \
	clear; \
	supervisord -c .helpers/conf/supervisor.conf; \
	clear; \
	docker-compose up -d

stop: check-os
	
	supervisorctl shutdown

	docker-compose down

ps:
	clear;docker ps --format '{{.Names}}'

enter:
	clear;docker exec -it $${image} bash

log.unison:
	clear;tail -f ~/unison.log
