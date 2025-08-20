# Railway Deployment Guide for PHP PDF Book Application

This guide explains how to deploy your PHP PDF book flip-page application on Railway.

## Files Location

Place these files in the **root directory** of your GitHub repository:

- `Dockerfile` - Docker configuration for PHP 8.2 + Apache
- `railway.json` - Railway deployment configuration
- `apache.conf` - Apache web server configuration
- `.dockerignore` - Files to exclude from Docker build

## File Structure

```
your-repo/
├── Dockerfile          # ← Place here (root)
├── railway.json        # ← Place here (root)
├── apache.conf         # ← Place here (root)
├── .dockerignore       # ← Place here (root)
├── index.php           # ← Your main PHP file
├── health.php          # ← Health check endpoint
├── books/              # ← PDF files directory
│   ├── book1.pdf
│   └── book2.pdf
├── reader.html         # ← PDF reader interface
├── reader.js           # ← PDF reader JavaScript
└── style.css           # ← Styling
```

## What Each File Does

### Dockerfile
- Uses PHP 8.2 with Apache web server
- Installs required system dependencies (git, unzip, curl, libzip-dev)
- Installs PHP extensions (pdo, pdo_mysql, zip)
- Installs Composer for dependency management
- Enables Apache rewrite module for clean URLs
- Exposes port 8080 (Railway requirement)
- Uses `apache2-foreground` as start command

### railway.json
- Forces Railway to use Dockerfile instead of auto-detection
- Sets health check path to `/health.php`
- Configures restart policy for reliability

### apache.conf
- Configures Apache to listen on port 8080
- Sets DocumentRoot to `/var/www/html`
- Enables PHP processing
- Configures health check endpoints
- Allows access to PDF files

### .dockerignore
- Excludes unnecessary files from Docker build context
- Improves build performance
- Reduces image size

## Deployment Steps

1. **Push to GitHub**: Commit and push all files to your repository
2. **Connect to Railway**: Link your GitHub repository in Railway
3. **Deploy**: Railway will automatically build using the Dockerfile
4. **Monitor**: Check the deployment logs for any issues

## Health Check

The application provides multiple health check endpoints:

- `/health.php` - JSON response with detailed system status
- `/health.html` - Simple HTML response
- `/` - Root route that serves your main application

Railway will use `/health.php` for health checks.

## If Your App Uses a `public/` Folder

If your PHP application has a `public/` folder structure like:

```
your-repo/
├── public/
│   ├── index.php
│   ├── assets/
│   └── ...
├── src/
├── vendor/
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

## Troubleshooting

### Common Issues

1. **Port 8080**: Ensure Apache listens on port 8080, not 80
2. **Health Check Failures**: Check that `/health.php` returns HTTP 200
3. **File Permissions**: PDF files should be readable by web server
4. **Build Failures**: Check Docker build logs for dependency issues

### Debug Commands

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
```

## Environment Variables

Railway automatically provides:
- `$PORT` - Mapped to port 8080 in container
- `RAILWAY_STATIC_URL` - Set to "0" to disable static file serving

## Performance Tips

1. **Layer Caching**: Composer dependencies are installed before copying app code
2. **File Exclusions**: `.dockerignore` reduces build context size
3. **Optimized Autoloader**: Composer installs with `--optimize-autoloader`
4. **PDF Access**: Direct file serving for PDFs without PHP processing

## Security Notes

- PDF files are publicly accessible (adjust if needed)
- Apache rewrite module is enabled for clean URLs
- Error logging is configured for debugging
- Server status endpoint is available for monitoring

## Support

If you encounter issues:
1. Check Railway deployment logs
2. Verify health check endpoint returns 200 OK
3. Ensure all required files are in the correct locations
4. Check that port 8080 is properly configured
