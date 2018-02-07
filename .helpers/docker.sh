#!/bin/bash

export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.100.100:2376"
export DOCKER_CERT_PATH="~/.docker/machine/machines/devbox"
export DOCKER_MACHINE_NAME="devbox"

