#!/bin/bash

PWD=$(pwd)
PATH=$PWD/.helpers/conf/supervisor.conf

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

${PWD}/.helpers/main.sh supervisor $PATH