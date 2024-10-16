#!/usr/bin bash

# containers sub-network
docker network create subnet=172.18.0.0/24 db-conn

# wordpress php server
docker build -t  php-apache ./server
docker run -d -p 8080:80 \
	--network db-conn --ip 172.18.0.2 \
	--name wordpress-apache-container php-apache

# mysql server
docker build -t  php-db ./server/db
docker run --name php-db-container -d -p 3306:3306 \
		--network db-conn --ip 172.18.0.3 \
		-e MYSQL_ROOT_PASSWORD=root123 --user 1000:50 php-db

# to use mysql in cli
# docker exec -it <db-container> mysql -u root -p

# docker logs <db-container>
