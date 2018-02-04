#!/bin/bash

PWD=$(pwd)
PATH=.helpers/conf/supervisor.conf

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

for i in `echo */`;
do
	echo "[program:${i%?}]" >> $PATH;
	echo "command=/usr/local/bin/notifyloop ${PWD}/${i} .helpers/unison.sh ${i%?} ${PWD}" >> $PATH;
	echo "" >> $PATH;
done;
