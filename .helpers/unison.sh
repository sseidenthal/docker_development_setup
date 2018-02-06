#/bin/bash

WORKSPACE_KEY=$1
PROJECT_KEY=$2
LOCAL_HOME=$3
REMOTE_HOME=$4

SOURCE=${LOCAL_HOME}/${PROJECT_KEY}
TARGET=${REMOTE_HOME}${WORKSPACE_KEY}_${PROJECT_KEY}/_data

unison \
	-root=$SOURCE \
	-root=$TARGET \
	-auto=true \
	-batch=true \
	-confirmbigdel=false \
	-fastcheck=true \
	-group=false \
	-owner=false \
	-prefer=newer \
	-force=newer \
	-silent=false \
	-times=true \
	-ignore="Path .idea" \
	-ignore="Name .idea" \
	-ignore="Name *.tmp" \
	-ignore="Name .git" \
	-ignore="Path .git"


