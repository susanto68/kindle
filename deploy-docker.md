# 🐳 Docker Deployment Guide for Kindle Reader

## 📋 Prerequisites
- ✅ Docker installed on your system
- ✅ Docker Compose installed
- ✅ Your Kindle reader project files ready

## 🚀 Quick Start with Docker

### **Step 1: Install Docker (if not already installed)**

#### **Windows:**
1. **Download Docker Desktop** from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. **Install and restart** your computer
3. **Start Docker Desktop**

#### **macOS:**
1. **Download Docker Desktop** from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. **Install and start** Docker Desktop

#### **Linux (Ubuntu):**
```bash
# Update package index
sudo apt update

# Install prerequisites
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in for group changes to take effect
```

### **Step 2: Verify Docker Installation**
```bash
docker --version
docker-compose --version
```

## 🐳 Deploy Your Kindle Reader

### **Step 1: Navigate to Project Directory**
```bash
cd C:\Users\susan\kindle
```

### **Step 2: Build and Start with Docker Compose**
```bash
# Build and start the container
docker-compose up --build -d

# Check container status
docker-compose ps

# View logs
docker-compose logs -f kindle-reader
```

### **Step 3: Access Your Application**
- **Open browser** to: `http://localhost:8080`
- **Should see**: Your Kindle library with 5 PDF books
- **Test all features**: PDF reading, TTS, navigation

## 🔧 Docker Commands Reference

### **Basic Operations:**
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### **Container Management:**
```bash
# Enter container shell
docker exec -it kindle-reader bash

# View container details
docker inspect kindle-reader

# View resource usage
docker stats kindle-reader
```

### **Image Management:**
```bash
# Rebuild image
docker-compose build --no-cache

# Remove old images
docker image prune

# View all images
docker images
```

## 🌐 Deploy to Different Environments

### **Local Development:**
```bash
# Use port 8080
docker-compose up -d
# Access at: http://localhost:8080
```

### **Production (Different Port):**
```bash
# Edit docker-compose.yml, change ports to:
ports:
  - "80:80"  # Use standard HTTP port
```

### **Custom Domain:**
```bash
# Edit docker-compose.yml, add:
environment:
  - VIRTUAL_HOST=yourdomain.com
  - VIRTUAL_PORT=80
```

## 📁 Project Structure with Docker

```
kindle/
├── Dockerfile              # Container configuration
├── docker-compose.yml      # Multi-container setup
├── .dockerignore          # Files to exclude
├── index.php              # Main library page
├── reader.html            # PDF reader interface
├── reader.js              # Reader functionality
├── style.css              # Application styling
├── books/                 # PDF books (mounted as volume)
│   ├── CLASS 10 CH-1.pdf
│   ├── CLASS 10 CH-2.pdf
│   ├── CLASS 10 CH-3.pdf
│   ├── CLASS 10 CH-4.pdf
│   └── CLASS 10 CH-5.pdf
└── logs/                  # Apache logs (mounted as volume)
```

## 🔒 Security Features

### **Container Security:**
- ✅ **Non-root user** (www-data)
- ✅ **Read-only root filesystem** (except volumes)
- ✅ **Limited capabilities**
- ✅ **Network isolation**

### **Application Security:**
- ✅ **Security headers** in .htaccess
- ✅ **Input validation** in PHP
- ✅ **File type restrictions**
- ✅ **Directory traversal protection**

## 📊 Monitoring and Logs

### **View Application Logs:**
```bash
# Real-time logs
docker-compose logs -f kindle-reader

# Specific log file
docker exec kindle-reader tail -f /var/log/apache2/kindle_access.log
```

### **Container Health:**
```bash
# Check container status
docker-compose ps

# View resource usage
docker stats kindle-reader

# Check container health
docker inspect kindle-reader | grep Health
```

## 🚀 Scaling and Performance

### **Scale Your Application:**
```bash
# Scale to multiple instances
docker-compose up --scale kindle-reader=3 -d

# Load balancer configuration (optional)
# Add nginx or traefik for load balancing
```

### **Performance Optimization:**
- ✅ **Gzip compression** enabled
- ✅ **Browser caching** configured
- ✅ **Optimized PHP settings**
- ✅ **Efficient image layers**

## 🆘 Troubleshooting

### **Common Issues:**

#### **Port Already in Use:**
```bash
# Check what's using port 8080
netstat -ano | findstr :8080

# Change port in docker-compose.yml
ports:
  - "8081:80"  # Use port 8081 instead
```

#### **Permission Issues:**
```bash
# Fix file permissions
docker exec kindle-reader chown -R www-data:www-data /var/www/html
docker exec kindle-reader chmod -R 755 /var/www/html
```

#### **Container Won't Start:**
```bash
# Check logs
docker-compose logs kindle-reader

# Rebuild container
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 🎯 Benefits of Docker Deployment

- ✅ **Consistent environment** across all deployments
- ✅ **Easy scaling** and management
- ✅ **Isolated dependencies** (no conflicts)
- ✅ **Quick deployment** to any environment
- ✅ **Version control** for your entire stack
- ✅ **Easy rollback** if issues arise

## 🚀 Ready to Deploy?

Your Docker setup is ready! This approach gives you:

1. **Local development** with `docker-compose up`
2. **Easy deployment** to any server
3. **Consistent environment** everywhere
4. **Professional deployment** standards

**Next steps:**
1. **Test locally** with Docker
2. **Deploy to your preferred cloud** (Oracle Cloud, AWS, etc.)
3. **Scale as needed** with Docker Compose

**Would you like me to help you with the next steps or explain any part of the Docker setup?**
