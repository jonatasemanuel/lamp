#!/usr/bin/env bash

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
	docker build -t  php-db ./server/db
}

create_containers () {
	docker run -d -p 8080:80 \
		--network db-conn --ip 172.18.0.2 \
		--name wordpress-apache-container php-apache

	docker run --name php-db-container -d -p 3306:3306 \
			--network db-conn --ip 172.18.0.3 \
			-e MYSQL_ROOT_PASSWORD=root123 --user 1000:50 php-db
}

start_containers () {
	docker start wordpress-apache-container
	docker start php-db-ip
}

case $1 in
	"stop_containers") stop_containers ;;
	"create_net") create_net ;;
	"create_images") create_images ;;
	"create_containers") create_containers ;;
	"start_containers") start_containers ;;
	*) echo "options[ stop_containers | create_net | create_images | create_containers | start_containers]"
esac

# docker exec -it <db-container> mysql -u root -p
# docker logs <db-container>
