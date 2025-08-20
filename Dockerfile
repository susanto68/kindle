# Use official PHP 8.2 Apache image
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy custom Apache configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Copy all project files
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 644 /var/www/html/books/*.pdf

# Create a simple health check endpoint
RUN echo '<?php http_response_code(200); echo "OK"; ?>' > /var/www/html/health.php

# Expose port 8080 (Railway requirement)
EXPOSE 8080

# Use apache2-foreground as start command
CMD ["apache2-foreground"]
