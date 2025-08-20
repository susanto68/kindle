@echo off
echo 🐳 Testing Docker Setup for Kindle App
echo ======================================

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker first.
    pause
    exit /b 1
)

echo ✅ Docker is running

REM Build the image
echo 🔨 Building Docker image...
docker build -t kindle-app .

if %errorlevel% neq 0 (
    echo ❌ Docker build failed. Check the error messages above.
    pause
    exit /b 1
)

echo ✅ Docker image built successfully

REM Run the container
echo 🚀 Starting container...
for /f "tokens=*" %%i in ('docker run -d -p 8080:8080 kindle-app') do set CONTAINER_ID=%%i

if %errorlevel% neq 0 (
    echo ❌ Failed to start container.
    pause
    exit /b 1
)

echo ✅ Container started with ID: %CONTAINER_ID%
echo ⏳ Waiting for Apache to start...

REM Wait for Apache to start
timeout /t 10 /nobreak >nul

REM Test health endpoints
echo 🔍 Testing health endpoints...

echo Testing /health.php...
for /f "tokens=*" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/health.php') do set HEALTH_PHP=%%i
if "%HEALTH_PHP%"=="200" (
    echo ✅ /health.php returns HTTP 200
) else (
    echo ❌ /health.php returns HTTP %HEALTH_PHP%
)

echo Testing /health.html...
for /f "tokens=*" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/health.html') do set HEALTH_HTML=%%i
if "%HEALTH_HTML%"=="200" (
    echo ✅ /health.html returns HTTP 200
) else (
    echo ❌ /health.html returns HTTP %HEALTH_HTML%
)

echo Testing root /...
for /f "tokens=*" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/') do set ROOT=%%i
if "%ROOT%"=="200" (
    echo ✅ Root / returns HTTP 200
) else (
    echo ❌ Root / returns HTTP %ROOT%
)

echo.
echo 🌐 Your app should be accessible at: http://localhost:8080
echo 📚 PDF books should be listed on the main page
echo 🔍 Health check endpoint: http://localhost:8080/health.php
echo.
echo To stop the container, run: docker stop %CONTAINER_ID%
echo To view logs, run: docker logs %CONTAINER_ID%
echo.
pause
