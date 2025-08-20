# Railway Deployment Guide for PHP PDF Book Application (Fixed Apache Issues)

This guide explains how to deploy your PHP PDF book flip-page application on Railway **without Composer** and **fixes the Apache domain warning and SIGWINCH issues**.

## 🚨 **Issues Fixed**

1. **Apache Domain Warning**: `AH00558: apache2: Could not reliably determine the server's fully qualified domain name`
2. **SIGWINCH Signal**: `caught SIGWINCH, shutting down gracefully` ✅ **FIXED**
3. **Health Check Failures**: Railway container stops due to Apache issues

## 🔧 **Signal Handling Fix**

The SIGWINCH issue is now resolved with a custom startup script that:
- ✅ **Ignores SIGWINCH signals** that cause graceful shutdown
- ✅ **Prevents Apache from shutting down** on window change signals
- ✅ **Uses proper signal trapping** to maintain container stability
- ✅ **Keeps Apache running** even when Railway sends signals

## 📁 **Files Location**

Place these files in the **root directory** of your GitHub repository:

- `Dockerfile` - Docker configuration for PHP 8.2 + Apache (fixed signals)
- `railway.json` - Railway deployment configuration
- `apache.conf` - Apache configuration (fixed domain warnings)
- `startup.sh` - Custom startup script for signal handling
- `.dockerignore` - Files to exclude from Docker build

## 🏗️ **File Structure**

```
your-repo/
├── Dockerfile          # ← Place here (root)
├── railway.json        # ← Place here (root)
├── apache.conf         # ← Place here (root)
├── startup.sh          # ← Place here (root) - NEW!
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

### Dockerfile (Fixed Signal Handling)
- ✅ Uses PHP 8.2 with Apache web server
- ✅ Installs required system dependencies (libzip-dev, libpng-dev, etc.)
- ✅ Installs PHP extensions (pdo, pdo_mysql, zip)
- ✅ **NO Composer** - Pure PHP project
- ✅ Enables Apache rewrite and headers modules
- ✅ **Fixes domain warnings** with proper Apache config
- ✅ **Fixes SIGWINCH signals** with custom startup script
- ✅ Exposes port 8080 (Railway requirement)
- ✅ Uses custom startup script for proper signal handling

### startup.sh (NEW - Signal Handling)
- ✅ **Ignores SIGWINCH signals** that cause graceful shutdown
- ✅ **Prevents Apache from shutting down** on container signals
- ✅ **Maintains container stability** in Railway environment
- ✅ **Proper signal trapping** for production deployment

### apache.conf (Fixed Domain Issues)
- ✅ **ServerName localhost** - Suppresses domain warnings
- ✅ **Global ServerName** - Prevents AH00558 errors
- ✅ **GracefulShutdownTimeout 0** - Prevents graceful shutdowns
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
- ✅ `/health.php` → HTTP 200, "OK"
- ✅ `/health.html` → HTTP 200, HTML page
- ✅ `/` → HTTP 200, Your main library page
- ✅ **No SIGWINCH signals**
- ✅ **Apache stays running**

## 🐛 **Troubleshooting**

### **Common Issues**

1. **Port 8080**: Ensure Apache listens on port 8080, not 80
2. **Health Check Failures**: Check that `/health.php` returns HTTP 200
3. **File Permissions**: PDF files should be readable by web server
4. **Build Failures**: Check Docker build logs for dependency issues
5. **Signal Handling**: The startup script should prevent graceful shutdowns

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

# Check if startup script is working
ps aux | grep apache
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
6. **Signal Handling**: Custom startup script prevents unwanted shutdowns

## 🔒 **Security Notes**

- PDF files are publicly accessible (adjust if needed)
- Apache rewrite module is enabled for clean URLs
- Error logging is configured for debugging
- Server signature is disabled for cleaner logs
- Signal handling prevents unauthorized shutdowns

## 🆘 **Support**

If you encounter issues:
1. Check Railway deployment logs
2. Verify health check endpoint returns 200 OK
3. Ensure all required files are in the correct locations
4. Check that port 8080 is properly configured
5. **Test locally with Docker first**
6. Check Apache error logs for domain warnings
7. **Verify signal handling is working** - no SIGWINCH shutdowns

## ✅ **Success Indicators**

Your deployment is successful when:
- ✅ Railway shows "Running" status
- ✅ Health check passes (`/health.php` loads)
- ✅ Main page loads (`/` shows library)
- ✅ PDF reader works (`/reader.html` opens)
- ✅ **No Apache domain warnings in logs**
- ✅ **No SIGWINCH signals causing shutdowns**
- ✅ **Container stays running continuously**
