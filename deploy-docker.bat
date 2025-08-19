@echo off
echo 🐳 Kindle Reader Docker Deployment
echo =================================

echo.
echo Checking Docker installation...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed or not running!
    echo Please install Docker Desktop from: https://docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo ✅ Docker is installed and running!

echo.
echo Building and starting Kindle Reader...
docker-compose up --build -d

if %errorlevel% neq 0 (
    echo ❌ Failed to start containers!
    echo.
    echo Troubleshooting:
    echo 1. Make sure Docker Desktop is running
    echo 2. Check if port 8080 is available
    echo 3. Try: docker-compose down
    echo 4. Then: docker-compose up --build -d
    pause
    exit /b 1
)

echo.
echo ✅ Kindle Reader started successfully!
echo.
echo 🌐 Access your application at: http://localhost:8080
echo.
echo 📚 Your Kindle library should now be visible with all 5 PDF books!
echo.
echo 🔧 Useful commands:
echo   - View logs: docker-compose logs -f
echo   - Stop: docker-compose down
echo   - Restart: docker-compose restart
echo   - Status: docker-compose ps
echo.
echo 🎉 Deployment complete! Press any key to continue...
pause >nul
