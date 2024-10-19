#!/usr/bin/env bash

source ./.env
set -euo pipefail


stop_containers () {
	echo "Stopping other docker container"
	if [[ $(docker ps -q) ]]; then 
		echo "Found and stopped containers" 
		docker stop $(docker ps -q) 
	else 
		echo "No containers running..."
	fi
}

# containers sub-network
create_net () {
	docker network create subnet=172.18.0.0/24 db-conn
}

# wordpress php server
create_images () {
	docker build -t  php-apache ./server
}

create_containers () {
	docker run --name ${WP_DOCKER_CONTAINER} \
		--network db-conn --ip 172.18.0.5 \
		-d -p 8080:80 php-apache 

	docker run --name ${DB_DOCKER_CONTAINER} \
	 		--network db-conn --ip 172.18.0.6 \
			-p 3306:3306 \
			-e MYSQL_ROOT_PASSWORD=${USER} \
			-e MYSQL_PASSWORD=${PASSWORD} \
			-d mysql:8.0.39
}

start_containers () {
	docker start ${WP_DOCKER_CONTAINER}
	docker start ${DB_DOCKER_CONTAINER}
}

create_db () {
	docker exec -it  ${DB_DOCKER_CONTAINER} \
		mysql -u ${USER} -p"${PASSWORD}" \
		-e "CREATE DATABASE ${DATABASE_NAME};"
}

case $1 in
	"stop_containers") stop_containers ;;
	"create_net") create_net ;;
	"create_images") create_images ;;
	"create_containers") create_containers ;;
	"start_containers") start_containers ;;
	"create_db")
		DATABASE_NAME=$2 \
		create_db ;;
	*) echo "options[ stop_containers | create_net | create_images | create_containers | start_containers]"
esac

 
# docker exec -it <db-container> mysql -u root -p
# docker logs <db-container>
