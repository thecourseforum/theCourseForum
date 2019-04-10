#!/bin/bash

# check if database exists. If so, do nothing, else calibrate.

service mysql restart && RESULT=`mysqlshow -u root -pdata thecourseforum_development| grep -v Wildcard | grep -o thecourseforum_development`
if [ "$RESULT" == "thecourseforum_development" ]; then
    echo "Database already calibrated"
else
	echo "Calibrating database"
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && service mysql restart
	mysql -u root -pdata <<QUERY 
	drop database if exists thecourseforum_development;drop database if exists thecourseforum_production;
	create database thecourseforum_development;
	create database thecourseforum_production;
	use thecourseforum_development;
	source ./sql/thecourseforum_development.sql
	use thecourseforum_production;
	source ./sql/thecourseforum_production.sql;
QUERY
	echo "Finished calibrating"
	echo "Updating NPM"
	npm install npm@latest -g
	echo "Finished updating NPM"
	echo "Updating packages"
	yarn install
	echo "Finished updating packages"
	# echo "Installing react"
	# rm -rf ./config/webpack
	# rake webpacker:install
	# rake webpacker:install:react
	# echo "Finished installing react"
fi