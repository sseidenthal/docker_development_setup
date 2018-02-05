# Demonstriert dialog --menu
# Name : dialog6

while :
do
	echo "Press [CTRL+C] to stop.."

	CONTAINERS=$(docker ps --format '{{.Names}} "<"')

	CONTAINER=`dialog --menu "CHOOSE A CONTAINER - Press [CTRL+C] to stop.." 0 0 0 \
	 $CONTAINERS 3>&1 1>&2 2>&3`
	dialog --clear

	if [[ $CONTAINER = "" ]]
	then
		echo "goodbye developer"
	else
		clear
	  	docker logs -f $CONTAINER
	fi

done