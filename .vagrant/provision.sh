#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

# yes, the first thing we do is updates
sudo apt-get update
sudo apt-get upgrade -y

# install the very basic tools
sudo apt-get install -y mc htop curl wget unison software-properties-common

######################################################################################################
################################# install mongodb ####################################################
######################################################################################################

#OK working, 07.02.2018
#sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
#echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
#sudo apt-get update
#sudo apt-get install -y mongodb-org
#sudo service mongod start
#mongo 127.0.0.1/admin --eval='db.createUser({user: "admin",pwd: "b1gmac4fr33",roles: [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "readWriteAnyDatabase", db: "admin" }, { role: "clusterAdmin", db: "admin" } ]})'
#mongo 127.0.0.1/post --eval='db.createUser({user: "admin",pwd: "b1gmac4fr33",roles: [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "readWriteAnyDatabase", db: "admin" }, { role: "clusterAdmin", db: "admin" } ]})'
#sudo sed -i 's/--config/--auth --config/g' /lib/systemd/system/mongod.service
#sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
#sudo systemctl daemon-reload
#sudo service mongod restart

######################################################################################################
################################# install mariadb ####################################################
######################################################################################################

sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.2/ubuntu xenial main'
sudo apt update
sudo apt upgrade -y
sudo debconf-set-selections <<< 'maria-db-10.2 mysql-server/root_password password b1gmac4fr33'
sudo debconf-set-selections <<< "maria-db-10.2 mysql-server/root_password_again password b1gmac4fr33"
sudo apt install -y  mariadb-server
sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
Q1="GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'b1gmac4fr33' WITH GRANT OPTION;"
Q2="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}"
mysql -uroot -pb1gmac4fr33 -e "$SQL"
sudo service mysql restart

######################################################################################################