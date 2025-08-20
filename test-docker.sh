#!/bin/bash

echo "🐳 Testing Docker Setup for Kindle App"
echo "======================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✅ Docker is running"

# Build the image
echo "🔨 Building Docker image..."
docker build -t kindle-app .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed. Check the error messages above."
    exit 1
fi

echo "✅ Docker image built successfully"

# Run the container
echo "🚀 Starting container..."
CONTAINER_ID=$(docker run -d -p 8080:8080 kindle-app)

if [ $? -ne 0 ]; then
    echo "❌ Failed to start container."
    exit 1
fi

echo "✅ Container started with ID: $CONTAINER_ID"
echo "⏳ Waiting for Apache to start..."

# Wait for Apache to start
sleep 10

# Test health endpoints
echo "🔍 Testing health endpoints..."

echo "Testing /health.php..."
HEALTH_PHP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/health.php)
if [ "$HEALTH_PHP" = "200" ]; then
    echo "✅ /health.php returns HTTP 200"
else
    echo "❌ /health.php returns HTTP $HEALTH_PHP"
fi

echo "Testing /health.html..."
HEALTH_HTML=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/health.html)
if [ "$HEALTH_HTML" = "200" ]; then
    echo "✅ /health.html returns HTTP 200"
else
    echo "❌ /health.html returns HTTP $HEALTH_HTML"
fi

echo "Testing root /..."
ROOT=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/)
if [ "$ROOT" = "200" ]; then
    echo "✅ Root / returns HTTP 200"
else
    echo "❌ Root / returns HTTP $ROOT"
fi

echo ""
echo "🌐 Your app should be accessible at: http://localhost:8080"
echo "📚 PDF books should be listed on the main page"
echo "🔍 Health check endpoint: http://localhost:8080/health.php"
echo ""
echo "Press Ctrl+C to stop the container, or run: docker stop $CONTAINER_ID"

# Keep container running and show logs
docker logs -f $CONTAINER_ID
