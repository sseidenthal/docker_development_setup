#!/bin/bash

file=$(cat config.json)
repositories=$(echo "${file}" | jq -r '.repositories | @base64')

for PROJECT in $(echo "${repositories}" | base64 --decode | jq -r '.[] | @base64');
do
	_jq() {
		echo ${PROJECT} | base64 --decode | jq -r ${1}
	}
	
	PROJECT_PATH=$(_jq '.path');
	PROJECT_GIT=$(_jq '.url');

	mkdir -p $PROJECT_PATH;
	git clone $PROJECT_GIT $PROJECT_PATH;

done

