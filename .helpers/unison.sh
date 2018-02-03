#/bin/bash

BASE_TARGET=socket://localhost:5000/

SOURCE="$2/$1"
TARGET="$BASE_TARGET$1"

unison \
	-root=$SOURCE \
	-root=$TARGET \
	-auto=true \
	-batch=true \
	-confirmbigdel=true \
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


