@echo off
echo 🚀 Kindle Reader Render Deployment
echo ===================================

echo.
echo 📋 Prerequisites Check:
echo 1. GitHub repository connected to Render
echo 2. All files committed and pushed to GitHub
echo 3. Render account created at render.com
echo.

echo 🔗 Render Dashboard:
echo Visit: https://render.com/dashboard
echo.

echo 📚 Your Kindle Reader will be available at:
echo https://your-app-name.onrender.com
echo.

echo 🚀 Deployment Steps:
echo 1. Go to render.com and sign up/login
echo 2. Click "New +" → "Web Service"
echo 3. Connect your GitHub repository: susanto68/kindle
echo 4. Configure service:
echo    - Name: kindle-reader
echo    - Environment: Docker
echo    - Build Command: docker build -f Dockerfile.render -t kindle-reader .
echo    - Start Command: docker run -p $PORT:80 kindle-reader
echo 5. Click "Create Web Service"
echo 6. Wait for build (5-10 minutes)
echo.

echo 📁 Files Created for Render:
echo ✅ render.yaml - Render configuration
echo ✅ Dockerfile.render - Render-optimized Dockerfile
echo ✅ deploy-render.md - Detailed deployment guide
echo ✅ Updated GitHub Actions for Render
echo.

echo 🌟 Benefits of Render:
echo ✅ Free hosting tier
echo ✅ Automatic deployments from GitHub
echo ✅ SSL certificates included
echo ✅ Global CDN for fast loading
echo ✅ Easy scaling options
echo.

echo 🎯 Next Steps:
echo 1. Push all files to GitHub
echo 2. Connect to Render dashboard
echo 3. Deploy automatically
echo 4. Share your Kindle reader worldwide!
echo.

echo 🎉 Ready to deploy to Render!
echo Press any key to continue...
pause >nul
