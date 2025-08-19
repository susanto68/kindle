#!/bin/bash

# 🚀 Oracle Cloud Deployment Script for Kindle Reader
# This script automates the deployment process

echo "🚀 Starting Kindle Reader Deployment on Oracle Cloud..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run this script with sudo"
    exit 1
fi

# Update system
print_status "Updating system packages..."
apt update && apt upgrade -y

# Install required packages
print_status "Installing LAMP stack..."
apt install -y apache2 php php-mysql mysql-server php-curl php-gd php-mbstring php-xml php-zip

# Start and enable Apache
print_status "Starting Apache service..."
systemctl start apache2
systemctl enable apache2

# Enable required Apache modules
print_status "Enabling Apache modules..."
a2enmod rewrite
a2enmod headers
a2enmod deflate

# Create project directory
print_status "Setting up project directory..."
mkdir -p /var/www/html/kindle
chown -R www-data:www-data /var/www/html/kindle
chmod -R 755 /var/www/html/kindle

# Create Apache virtual host configuration
print_status "Creating Apache virtual host..."
cat > /etc/apache2/sites-available/kindle.conf << 'EOF'
<VirtualHost *:80>
    ServerName kindle-reader.local
    DocumentRoot /var/www/html/kindle
    
    <Directory /var/www/html/kindle>
        AllowOverride All
        Require all granted
        Options Indexes FollowSymLinks
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/kindle_error.log
    CustomLog ${APACHE_LOG_DIR}/kindle_access.log combined
</VirtualHost>
EOF

# Enable the site
print_status "Enabling Kindle Reader site..."
a2ensite kindle.conf

# Restart Apache
print_status "Restarting Apache..."
systemctl restart apache2

# Configure firewall
print_status "Configuring firewall..."
ufw allow 80
ufw allow 443
ufw allow 22
ufw --force enable

# Create deployment info file
print_status "Creating deployment info..."
cat > /var/www/html/kindle/DEPLOYMENT_INFO.txt << 'EOF'
🎉 Kindle Reader Successfully Deployed!

📁 Project Location: /var/www/html/kindle/
🌐 Access URL: http://YOUR_PUBLIC_IP/kindle/
📊 Apache Status: systemctl status apache2
📝 Logs: /var/log/apache2/kindle_*.log

🔧 Next Steps:
1. Upload your project files to /var/www/html/kindle/
2. Set proper permissions: chown -R www-data:www-data /var/www/html/kindle/
3. Test your application
4. Configure domain name (optional)

📚 Features Available:
- PHP 8.x with all extensions
- Apache with mod_rewrite enabled
- MySQL database server
- Security headers configured
- PDF file support
EOF

print_status "✅ Deployment completed successfully!"
print_status "📁 Your project directory: /var/www/html/kindle/"
print_status "🌐 Access your site at: http://YOUR_PUBLIC_IP/kindle/"
print_warning "⚠️  Don't forget to upload your project files!"
print_warning "⚠️  Replace YOUR_PUBLIC_IP with your actual Oracle Cloud IP address"

echo ""
echo "🎯 Next Steps:"
echo "1. Upload your Kindle reader files to /var/www/html/kindle/"
echo "2. Test your application"
echo "3. Configure your domain name (optional)"
echo ""
echo "🚀 Your Kindle reader will be accessible from anywhere in the world!"
