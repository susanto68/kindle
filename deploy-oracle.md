# 🚀 Oracle Cloud Deployment Guide

## 📋 Prerequisites
- ✅ PHP working locally (COMPLETED!)
- ✅ Oracle Cloud account (free tier)
- ✅ Your Kindle reader project working

## 🔧 Step 1: Create Oracle Cloud Account

### 1.1 Sign Up
- Go to [oracle.com/cloud/free/](https://www.oracle.com/cloud/free/)
- Click "Start for free"
- Complete registration with email verification

### 1.2 Access Console
- Login to Oracle Cloud Console
- Navigate to "Compute" → "Instances"

## 🖥️ Step 2: Create VM Instance

### 2.1 Instance Configuration
- **Name**: `kindle-reader`
- **Image**: Ubuntu 22.04 LTS
- **Shape**: VM.Standard.A1.Flex
  - **OCPUs**: 1
  - **Memory**: 6 GB
- **Network**: Create new VCN with public subnet

### 2.2 Security Configuration
- **Public IP**: Yes
- **Security List**: Create new with these rules:
  - **HTTP (80)**: 0.0.0.0/0
  - **HTTPS (443)**: 0.0.0.0/0
  - **SSH (22)**: Your IP address

## 🔑 Step 3: Connect to Your VM

### 3.1 Get Connection Details
- Note your VM's **Public IP address**
- Download or create **SSH key**

### 3.2 SSH Connection
```bash
ssh ubuntu@YOUR_PUBLIC_IP
```

## 📦 Step 4: Install LAMP Stack

### 4.1 Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 4.2 Install Apache, PHP, MySQL
```bash
sudo apt install apache2 php php-mysql mysql-server -y
```

### 4.3 Start Services
```bash
sudo systemctl start apache2
sudo systemctl enable apache2
```

## 📁 Step 5: Deploy Your Project

### 5.1 Upload Files
```bash
# Navigate to web directory
cd /var/www/html

# Create project folder
sudo mkdir kindle
sudo chown ubuntu:ubuntu kindle
cd kindle
```

### 5.2 Upload Your Project
**Option A: Git Clone (if using GitHub)**
```bash
git clone YOUR_REPO_URL .
```

**Option B: Manual Upload**
- Use SFTP client (FileZilla, WinSCP)
- Upload all files to `/var/www/html/kindle/`

### 5.3 Set Permissions
```bash
sudo chown -R www-data:www-data /var/www/html/kindle/
sudo chmod -R 755 /var/www/html/kindle/
```

## ⚙️ Step 6: Configure Apache

### 6.1 Create Virtual Host
```bash
sudo nano /etc/apache2/sites-available/kindle.conf
```

### 6.2 Add Configuration
```apache
<VirtualHost *:80>
    ServerName your-domain.com
    DocumentRoot /var/www/html/kindle
    
    <Directory /var/www/html/kindle>
        AllowOverride All
        Require all granted
        Options Indexes FollowSymLinks
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/kindle_error.log
    CustomLog ${APACHE_LOG_DIR}/kindle_access.log combined
</VirtualHost>
```

### 6.3 Enable Site
```bash
sudo a2ensite kindle.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
```

## 🌐 Step 7: Test Your Deployment

### 7.1 Basic Test
- **Visit**: `http://YOUR_PUBLIC_IP/kindle/`
- **Should see**: Your Kindle library with 5 PDF books

### 7.2 Test Features
- ✅ Book listing working
- ✅ PDF reader opening
- ✅ Text-to-speech functioning
- ✅ Navigation working

## 🔒 Step 8: Security & SSL (Optional)

### 8.1 Install SSL Certificate
```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d your-domain.com
```

### 8.2 Configure Firewall
```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 22
sudo ufw enable
```

## 📊 Step 9: Monitor & Maintain

### 9.1 Check Logs
```bash
sudo tail -f /var/log/apache2/kindle_access.log
sudo tail -f /var/log/apache2/kindle_error.log
```

### 9.2 Update System
```bash
sudo apt update && sudo apt upgrade -y
```

## 🎯 Expected Results

After deployment:
- ✅ **Your Kindle reader** accessible from anywhere
- ✅ **All features working** (PHP, PDFs, TTS)
- ✅ **Professional hosting** on Oracle Cloud
- ✅ **Free tier** (always free, no hidden costs)

## 🆘 Troubleshooting

### Common Issues:
- **403 Forbidden**: Check file permissions
- **500 Internal Error**: Check Apache error logs
- **PDF not loading**: Verify file paths and permissions
- **PHP not working**: Ensure PHP module is enabled

## 🚀 Ready to Deploy?

Your local setup is perfect! Now let's get it running on Oracle Cloud so you can access your Kindle reader from anywhere in the world!

**Next step**: Create your Oracle Cloud account and I'll guide you through the VM creation process.
