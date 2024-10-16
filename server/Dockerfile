# Use the official PHP image with Apache
FROM php:8.1-apache

# Install necessary PHP extensions for WordPress
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli zip

# Enable Apache mod_rewrite (useful for WordPress permalinks)
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Download WordPress
RUN curl -o latest.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress/* . && \
    rmdir wordpress

# Set permissions for WordPress
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache server in the foreground
CMD ["apache2-foreground"]

