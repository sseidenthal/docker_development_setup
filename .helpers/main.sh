#!/bin/bash

file=$(/bin/cat config.json)

UNISON_TARGET=$(echo "${file}" | /usr/local/bin/jq -r '.unison.target')

projects=$(echo "${file}" | /usr/local/bin/jq -r '.projects | @base64')

for PROJECT in $(echo "${projects}" | /usr/bin/base64 --decode | /usr/local/bin/jq -r '.[] | @base64');
do
	_jq() {
		echo ${PROJECT} | /usr/bin/base64 --decode | /usr/local/bin/jq -r ${1}
	}
	
	WORKSPACE_FOLDER=$(_jq '.path');
	WORKSPACE_REPOSITORIES=$(_jq '.repositories' | /usr/bin/base64);
	WORKSPACE_PATH=${PWD}/workspace/$WORKSPACE_FOLDER;

	if [ "$1" = "compose_up" ]; then
		docker-compose --file=${WORKSPACE_PATH}/docker-compose.yml up -d
	fi;

	if [ "$1" = "compose_down" ]; then
		docker-compose --file=${WORKSPACE_PATH}/docker-compose.yml down
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
		FULL_PATH=$WORKSPACE_PATH/$PROJECT_PATH;
		FULL_PATH_A=$WORKSPACE_PATH/$PROJECT_PATH;
		
		# create folder and checkout code
		if [ "$1" = "checkout" ]; then
			mkdir -p ${FULL_PATH_A};
			git clone $PROJECT_GIT ${FULL_PATH_A} --branch $PROJECT_BRANCH;
		fi;

		# add program to supervisor
		if [ "$1" = "supervisor" ]; then
			if ${PROJECT_UNSION}; then
				echo "[program:${PROJECT_KEY}]" >> $2;
				echo "command=/usr/local/bin/notifyloop ${FULL_PATH} .helpers/unison.sh ${WORKSPACE_FOLDER} ${PROJECT_KEY} ${WORKSPACE_PATH}/services ${UNISON_TARGET}" >> $2;
				echo "" >> $2;
			fi;
		fi;

	done

done
