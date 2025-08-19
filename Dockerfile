# Use official PHP 8.2 Apache image
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Enable Apache modules
RUN a2enmod rewrite

# Copy application files
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create a simple test file to verify PHP is working
RUN echo "<?php phpinfo(); ?>" > /var/www/html/test.php

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
