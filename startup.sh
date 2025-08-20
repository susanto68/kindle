#!/bin/bash

# Startup script for Apache in Railway container
# This script handles signals properly to prevent graceful shutdown

echo "Starting Apache server..."

# Ignore signals that cause graceful shutdown
trap "" SIGWINCH SIGTERM SIGINT

# Function to start Apache
start_apache() {
    echo "Starting Apache with exec..."
    exec apache2 -D FOREGROUND
}

# Function to handle graceful shutdown (if needed)
graceful_shutdown() {
    echo "Received shutdown signal, but continuing to run..."
    # Do nothing - just continue running
}

# Set up signal handlers
trap graceful_shutdown SIGTERM SIGINT

# Start Apache
start_apache
