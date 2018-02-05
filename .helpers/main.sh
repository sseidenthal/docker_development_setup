#!/bin/bash

echo "HELLO $1"

file=$(/bin/cat config.json)

UNISON_TARGET=$(echo "${file}" | /usr/local/bin/jq -r '.unison.target')

workspaces=$(echo "${file}" | /usr/local/bin/jq -r '.workspaces | @base64')

for WORKSPACE in $(echo "${workspaces}" | /usr/bin/base64 --decode | /usr/local/bin/jq -r '.[] | @base64');
do
	_jq() {
		echo ${WORKSPACE} | /usr/bin/base64 --decode | /usr/local/bin/jq -r ${1}
	}
	
	WORKSPACE_FOLDER=$(_jq '.path');
	WORKSPACE_REPOSITORIES=$(_jq '.repositories' | /usr/bin/base64);
	WORKSPACE_PATH=${PWD}/workspace/$WORKSPACE_FOLDER;

	if [ "$1" = "compose_up" ]; then
		docker-compose --file=${WORKSPACE_PATH}/docker-compose.yml up -d
	fi;

	for WORKSPACE_REPOSITORY in $(echo "${WORKSPACE_REPOSITORIES}" | /usr/bin/base64 --decode | /usr/local/bin/jq -r '.[] | @base64');
	do
		_jq() {
			echo ${WORKSPACE_REPOSITORY} | /usr/bin/base64 --decode | /usr/local/bin/jq -r ${1}
		}
		
		PROJECT_KEY=$(_jq '.path');
		PROJECT_PATH=services/${PROJECT_KEY};
		PROJECT_GIT=$(_jq '.url');
		PROJECT_BRANCH=$(_jq '.branch');
		PROJECT_UNSION=$(_jq '.enable_unison_sync');
		FULL_PATH=/workspace/$WORKSPACE_PATH/$PROJECT_PATH;
		

		# create folder and checkout code
		if [ "$1" = "checkout" ]; then
			mkdir -p ${PWD}${FULL_PATH};
			git clone $PROJECT_GIT ${PWD}${FULL_PATH} --branch $PROJECT_BRANCH;
		fi;

		# add program to supervisor
		if [ "$1" = "supervisor" ]; then
			if ${PROJECT_UNSION}; then
				echo "[program:${PROJECT_KEY}]" >> $2;
				echo "command=/usr/local/bin/notifyloop ${PWD}${FULL_PATH} .helpers/unison.sh ${PROJECT_KEY} ${WORKSPACE_PATH}/services ${UNISON_TARGET}" >> $2;
				echo "" >> $2;
			fi;
		fi;

	done

done
