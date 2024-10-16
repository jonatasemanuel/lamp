# Use the official MySQL image
FROM mysql:8.0.39

# Set the root password and other environment variables
ENV MYSQL_ROOT_PASSWORD=root123
ENV MYSQL_DATABASE=wpress-db
ENV MYSQL_USER=jojo
ENV MYSQL_PASSWORD=jojo123

# Expose port 3306 for MySQL
EXPOSE 3306

VOLUME ["/var/lib/mysql"]
