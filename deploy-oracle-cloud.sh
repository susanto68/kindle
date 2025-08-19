#!/bin/bash

# 🚀 Oracle Cloud Deployment Script for Kindle Reader
# This script deploys your GitHub container image to Oracle Cloud

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

# Install Docker
print_status "Installing Docker..."
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Start and enable Docker
print_status "Starting Docker service..."
systemctl start docker
systemctl enable docker

# Create project directory
print_status "Setting up project directory..."
mkdir -p /opt/kindle-reader
cd /opt/kindle-reader

# Create production docker-compose file
print_status "Creating production docker-compose configuration..."
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  kindle-reader:
    image: ghcr.io/susanto68/kindle:latest
    container_name: kindle-reader-prod
    ports:
      - "80:80"
    volumes:
      - ./books:/var/www/html/books
      - ./logs:/var/log/apache2
    environment:
      - APACHE_DOCUMENT_ROOT=/var/www/html
      - PRODUCTION=true
    restart: unless-stopped
    networks:
      - kindle-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  kindle-network:
    driver: bridge
EOF

# Create books directory
print_status "Creating books directory..."
mkdir -p books
chmod 755 books

# Create logs directory
print_status "Creating logs directory..."
mkdir -p logs
chmod 755 logs

# Pull the latest image from GitHub Container Registry
print_status "Pulling latest Kindle Reader image from GitHub..."
docker pull ghcr.io/susanto68/kindle:latest

# Start the application
print_status "Starting Kindle Reader application..."
docker-compose up -d

# Wait for container to start
print_status "Waiting for application to start..."
sleep 10

# Check container status
print_status "Checking container status..."
docker-compose ps

# Test the application
print_status "Testing application..."
if curl -f http://localhost > /dev/null 2>&1; then
    print_status "✅ Application is running successfully!"
else
    print_warning "⚠️  Application might still be starting up..."
fi

# Configure firewall
print_status "Configuring firewall..."
ufw allow 80
ufw allow 443
ufw allow 22
ufw --force enable

# Create deployment info
print_status "Creating deployment information..."
cat > DEPLOYMENT_INFO.txt << 'EOF'
🎉 Kindle Reader Successfully Deployed on Oracle Cloud!

📁 Project Location: /opt/kindle-reader/
🌐 Access URL: http://YOUR_PUBLIC_IP/
📊 Container Status: docker-compose ps
📝 Logs: docker-compose logs -f

🔧 Management Commands:
- View logs: docker-compose logs -f
- Restart: docker-compose restart
- Stop: docker-compose down
- Start: docker-compose up -d
- Update: docker-compose pull && docker-compose up -d

📚 Features Available:
- PHP 8.2 with all extensions
- Apache with mod_rewrite enabled
- PDF file support
- Text-to-speech functionality
- Responsive design
- Security headers configured

🚀 Next Steps:
1. Upload your PDF books to ./books/ directory
2. Configure your domain name (optional)
3. Set up SSL certificate (optional)
4. Monitor logs for any issues

📊 Monitoring:
- Container health: docker ps
- Resource usage: docker stats
- Application logs: docker-compose logs -f
EOF

print_status "✅ Deployment completed successfully!"
print_status "📁 Your project directory: /opt/kindle-reader/"
print_status "🌐 Access your site at: http://YOUR_PUBLIC_IP/"
print_warning "⚠️  Don't forget to upload your PDF books to the books/ directory!"
print_warning "⚠️  Replace YOUR_PUBLIC_IP with your actual Oracle Cloud IP address"

echo ""
echo "🎯 Next Steps:"
echo "1. Upload your PDF books to /opt/kindle-reader/books/"
echo "2. Test your application at http://YOUR_PUBLIC_IP/"
echo "3. Configure your domain name (optional)"
echo "4. Set up SSL certificate (optional)"
echo ""
echo "🚀 Your Kindle reader is now accessible from anywhere in the world!"
