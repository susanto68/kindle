# Railway Deployment Guide for PHP PDF Book Application (Fixed Apache Issues)

This guide explains how to deploy your PHP PDF book flip-page application on Railway **without Composer** and **fixes the Apache domain warning and SIGWINCH issues**.

## 🚨 **Issues Fixed**

1. **Apache Domain Warning**: `AH00558: apache2: Could not reliably determine the server's fully qualified domain name`
2. **SIGWINCH Signal**: `caught SIGWINCH, shutting down gracefully`
3. **Health Check Failures**: Railway container stops due to Apache issues

## 📁 **Files Location**

Place these files in the **root directory** of your GitHub repository:

- `Dockerfile` - Docker configuration for PHP 8.2 + Apache (fixed)
- `railway.json` - Railway deployment configuration
- `apache.conf` - Apache configuration (fixed domain warnings)
- `.dockerignore` - Files to exclude from Docker build

## 🏗️ **File Structure**

```
your-repo/
├── Dockerfile          # ← Place here (root)
├── railway.json        # ← Place here (root)
├── apache.conf         # ← Place here (root)
├── .dockerignore       # ← Place here (root)
├── index.php           # ← Your main PHP file (in root)
├── health.php          # ← Simple health check endpoint
├── books/              # ← PDF files directory
│   ├── book1.pdf
│   └── book2.pdf
├── reader.html         # ← PDF reader interface
├── reader.js           # ← PDF reader JavaScript
└── style.css           # ← Styling
```

## 🔧 **What Each File Does**

### Dockerfile (Fixed for Railway)
- ✅ Uses PHP 8.2 with Apache web server
- ✅ Installs required system dependencies (libzip-dev, libpng-dev, etc.)
- ✅ Installs PHP extensions (pdo, pdo_mysql, zip)
- ✅ **NO Composer** - Pure PHP project
- ✅ Enables Apache rewrite and headers modules
- ✅ **Fixes domain warnings** with proper Apache config
- ✅ Exposes port 8080 (Railway requirement)
- ✅ Uses `apache2-foreground` for proper signal handling

### apache.conf (Fixed Domain Issues)
- ✅ **ServerName localhost** - Suppresses domain warnings
- ✅ **Global ServerName** - Prevents AH00558 errors
- ✅ Configures Apache to listen on port 8080
- ✅ Sets DocumentRoot to `/var/www/html`
- ✅ Enables PHP processing
- ✅ Configures health check endpoints
- ✅ Allows access to PDF files
- ✅ **ServerSignature Off** - Cleaner logs

### railway.json
- ✅ Forces Railway to use Dockerfile instead of auto-detection
- ✅ Sets health check path to `/health.php`
- ✅ Configures restart policy for reliability
- ✅ **No start command** - Uses Dockerfile CMD

### .dockerignore
- ✅ Excludes unnecessary files from Docker build context
- ✅ Improves build performance
- ✅ Reduces image size

## 🚀 **Deployment Steps**

1. **Push to GitHub**: Commit and push all files to your repository
2. **Connect to Railway**: Link your GitHub repository in Railway
3. **Deploy**: Railway will automatically build using the Dockerfile
4. **Monitor**: Check the deployment logs for any issues

## 🔍 **Health Check**

The application provides reliable health check endpoints:

- `/health.php` - Simple text response "OK" with HTTP 200
- `/health.html` - Simple HTML response
- `/` - Root route that serves your main application

**Railway will use `/health.php` for health checks** - this endpoint is now simple and reliable.

## 📁 **If Your App Uses a `public/` Folder**

If your PHP application has a `public/` folder structure like:

```
your-repo/
├── public/
│   ├── index.php
│   ├── assets/
│   └── ...
├── src/
└── ...
```

**Modify the Dockerfile** by changing these lines:

```dockerfile
# Change this line:
COPY . /var/www/html/

# To this:
COPY . /var/www/html/
RUN mv /var/www/html/public/* /var/www/html/ && \
    rm -rf /var/www/html/public

# And update apache.conf to use the correct DocumentRoot
```

## 🧪 **Local Testing with Docker**

Before deploying to Railway, test your Docker setup locally:

### **Windows (Your Environment):**
```bash
# Run the test script
test-docker.bat

# Or manually:
docker build -t kindle-app .
docker run -p 8080:8080 kindle-app
```

### **Test Health Checks:**
```bash
# Test health endpoints
curl http://localhost:8080/health.php
curl http://localhost:8080/health.html
curl http://localhost:8080/
```

### **Expected Results:**
- `/health.php` → HTTP 200, "OK"
- `/health.html` → HTTP 200, HTML page
- `/` → HTTP 200, Your main library page

## 🐛 **Troubleshooting**

### **Common Issues**

1. **Port 8080**: Ensure Apache listens on port 8080, not 80
2. **Health Check Failures**: Check that `/health.php` returns HTTP 200
3. **File Permissions**: PDF files should be readable by web server
4. **Build Failures**: Check Docker build logs for dependency issues

### **Debug Commands**

If you need to debug inside the container:

```bash
# Access container shell
railway shell

# Check Apache status
service apache2 status

# Check PHP modules
php -m

# Check file permissions
ls -la /var/www/html/

# Check Apache error logs
tail -f /var/log/apache2/error.log
```

## 🌍 **Environment Variables**

Railway automatically provides:
- `$PORT` - Mapped to port 8080 in container
- `RAILWAY_STATIC_URL` - Set to "0" to disable static file serving

## ⚡ **Performance Tips**

1. **Layer Caching**: Dependencies are installed before copying app code
2. **File Exclusions**: `.dockerignore` reduces build context size
3. **PDF Access**: Direct file serving for PDFs without PHP processing
4. **No Composer**: Faster builds without dependency resolution
5. **Optimized Apache**: Minimal configuration for Railway environment

## 🔒 **Security Notes**

- PDF files are publicly accessible (adjust if needed)
- Apache rewrite module is enabled for clean URLs
- Error logging is configured for debugging
- Server signature is disabled for cleaner logs

## 🆘 **Support**

If you encounter issues:
1. Check Railway deployment logs
2. Verify health check endpoint returns 200 OK
3. Ensure all required files are in the correct locations
4. Check that port 8080 is properly configured
5. **Test locally with Docker first**
6. Check Apache error logs for domain warnings

## ✅ **Success Indicators**

Your deployment is successful when:
- ✅ Railway shows "Running" status
- ✅ Health check passes (`/health.php` loads)
- ✅ Main page loads (`/` shows library)
- ✅ PDF reader works (`/reader.html` opens)
- ✅ **No Apache domain warnings in logs**
- ✅ **No SIGWINCH signals causing shutdowns**
