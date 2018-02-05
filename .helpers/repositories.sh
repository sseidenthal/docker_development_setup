#!/bin/bash

file=$(cat config.json)

workspaces=$(echo "${file}" | jq -r '.workspaces | @base64')

for WORKSPACE in $(echo "${workspaces}" | base64 --decode | jq -r '.[] | @base64');
do
	_jq() {
		echo ${WORKSPACE} | base64 --decode | jq -r ${1}
	}
	
	WORKSPACE_PATH=$(_jq '.path');
	WORKSPACE_REPOSITORIES=$(_jq '.repositories' | base64);
	
	for WORKSPACE_REPOSITORY in $(echo "${WORKSPACE_REPOSITORIES}" | base64 --decode | jq -r '.[] | @base64');
	do
		_jq() {
			echo ${WORKSPACE_REPOSITORY} | base64 --decode | jq -r ${1}
		}
		
		PROJECT_PATH=services/$(_jq '.path');
		PROJECT_GIT=$(_jq '.url');
		PROJECT_BRANCH=$(_jq '.branch');

		FULL_PATH=workspace/$WORKSPACE_PATH/$PROJECT_PATH

		mkdir -p $FULL_PATH;
		git clone $PROJECT_GIT $FULL_PATH --branch $PROJECT_BRANCH;

	done

done