#!/bin/bash

PWD=$(pwd)
PATH=.helpers/conf/supervisor.conf

/usr/bin/touch $PATH;
echo "[supervisord]" > $PATH;
echo "nodaemon=false" >> $PATH;
echo "" >> $PATH;
echo "[supervisorctl]" >> $PATH;
echo "" >> $PATH;
echo "[inet_http_server]" >> $PATH;
echo "port = 127.0.0.1:9001" >> $PATH;
echo "" >> $PATH;
echo "[rpcinterface:supervisor]" >> $PATH;
echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> $PATH;
echo "" >> $PATH;

SERVICES=$(/usr/bin/find services -mindepth 1 -maxdepth 1 -type d)

for SERVICE in $SERVICES;
do
	KEY=$(echo $SERVICE | /usr/bin/sed -e "s/^services\///");
	echo "[program:${KEY}]" >> $PATH;
	echo "command=/usr/local/bin/notifyloop ${PWD}/services/${KEY} .helpers/unison.sh ${KEY} ${PWD}/services" >> $PATH;
	echo "" >> $PATH;
done;	