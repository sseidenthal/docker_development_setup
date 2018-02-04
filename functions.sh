function dev() {
	
	echo "Hello developer ..."

	CONFIG=$PWD/config.json
	COMPOSE=$PWD/docker-compose.yml
	
	ERROR_COUNT=0

	if [ ! -f $CONFIG ]; then
		echo "- no config.json found in this folder"
		ERROR_COUNT=1
	fi;
	
	if [ ! -f $COMPOSE ]; then
		echo "- no docker-compose.yml found in this folder"
		ERROR_COUNT=1
	fi;
	
		if [ $ERROR_COUNT -eq 1 ]; then
		echo "** The current folder does not look like a project folder. **"
	fi;

	make $1
	
}