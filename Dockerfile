# Use official PHP 8.2 Apache image
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy custom Apache configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Copy application files
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 644 /var/www/html/books/*.pdf

# Create a simple health check file
RUN echo "<?php echo 'OK'; ?>" > /var/www/html/health.php

# Create startup script
RUN echo '#!/bin/bash\n\
apache2-foreground &\n\
sleep 10\n\
curl -f http://localhost/health.html || exit 1\n\
wait' > /startup.sh && chmod +x /startup.sh

# Expose port 80
EXPOSE 80

# Use startup script instead of direct Apache command
CMD ["/startup.sh"]
