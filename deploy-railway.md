# 🚂 Deploy Kindle Reader to Railway

## 📋 What is Railway?

Railway is a modern cloud platform that offers:
- **Free tier** for development and testing
- **Automatic deployments** from GitHub
- **Built-in Docker support**
- **Easy scaling** and management
- **Professional hosting** standards
- **Global CDN** for fast loading

## 🎯 Why Railway for Your Kindle Reader?

✅ **Free hosting** for development and testing  
✅ **Automatic deployments** when you push to GitHub  
✅ **Professional URLs** (your-app.railway.app)  
✅ **Built-in SSL certificates**  
✅ **Global CDN** for fast PDF loading worldwide  
✅ **Easy scaling** as you add more books  
✅ **Docker support** out of the box  

## 🚀 Quick Deployment Steps

### **Step 1: Prepare Your Repository**

Make sure your GitHub repository has:
- ✅ `railway.json` file (already created)
- ✅ `Dockerfile` (already simplified)
- ✅ All your application files
- ✅ `books/` directory with your PDFs

### **Step 2: Connect to Railway**

1. **Go to [railway.app](https://railway.app)**
2. **Sign up/Login** with your GitHub account
3. **Click "Start a New Project"**
4. **Select "Deploy from GitHub repo"**
5. **Choose the `susanto68/kindle` repository**

### **Step 3: Configure Your Project**

**Project Settings:**
- **Name**: `kindle-reader` (or your preferred name)
- **Environment**: `Production`
- **Region**: Choose closest to your users

**Deployment Settings:**
- **Build Command**: Automatically detected from `railway.json`
- **Start Command**: Automatically detected from `railway.json`
- **Port**: Automatically set by Railway

### **Step 4: Deploy**

1. **Click "Deploy Now"**
2. **Wait for build** (3-5 minutes)
3. **Your app will be live** at `https://your-app-name.railway.app`

## 🔧 Configuration Details

### **Railway Configuration (`railway.json`):**

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "Dockerfile"
  },
  "deploy": {
    "startCommand": "docker run -p $PORT:80 kindle-reader",
    "healthcheckPath": "/",
    "healthcheckTimeout": 300,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### **Environment Variables:**

Railway automatically sets:
- `PORT` - The port your app should listen on
- `RAILWAY_STATIC_URL` - Your app's public URL
- `RAILWAY_ENVIRONMENT` - Current environment

### **Custom Environment Variables:**

Add these in Railway dashboard if needed:
```bash
NODE_ENV=production
APACHE_DOCUMENT_ROOT=/var/www/html
```

## 📁 File Structure for Railway

```
kindle/
├── 📱 index.php              # Main library page
├── 📖 reader.html            # PDF reader interface
├── ⚙️ reader.js              # Reader functionality
├── 🎨 style.css              # Application styling
├── 📚 books/                 # PDF books (upload via Railway)
├── 🐳 Dockerfile             # Simplified Dockerfile
├── 🚂 railway.json           # Railway configuration
├── 📋 .htaccess              # Apache configuration
└── 📖 README.md              # Documentation
```

## 🌐 Access Your Application

### **After Deployment:**

- **URL**: `https://your-app-name.railway.app`
- **Library**: Automatically lists all PDFs in `books/` directory
- **Reader**: Click any book to open the PDF reader
- **TTS**: Text-to-speech works in all modern browsers

### **Upload PDF Books:**

1. **Go to Railway dashboard**
2. **Navigate to your project**
3. **Go to "Settings" → "Files"**
4. **Upload PDFs** to `books/` directory
5. **Redeploy** if needed

## 🔄 Continuous Deployment

### **Automatic Deployments:**

- ✅ **Push to GitHub** → **Automatic build** → **Live deployment**
- ✅ **No manual steps** required
- ✅ **Rollback** to previous versions easily
- ✅ **Build logs** for debugging

### **Manual Deployments:**

- **Manual deploy** button in Railway dashboard
- **Force rebuild** if needed
- **Clear cache** for troubleshooting

## 📊 Monitoring & Logs

### **View Logs:**

1. **Go to your project** in Railway dashboard
2. **Click "Deployments" tab**
3. **Click on any deployment** to view logs
4. **Real-time logs** for debugging

### **Health Checks:**

- **Automatic health checks** every 30 seconds
- **Service restarts** if unhealthy
- **Email notifications** for downtime

## 🆘 Troubleshooting

### **Common Issues:**

#### **Build Fails:**
```bash
# Check Dockerfile syntax
# Verify all files are committed to GitHub
# Check Railway build logs for errors
```

#### **App Won't Start:**
```bash
# Check start command in railway.json
# Verify PORT environment variable
# Check application logs
```

#### **PDFs Not Loading:**
```bash
# Verify books/ directory exists
# Check file permissions
# Upload PDFs via Railway dashboard
```

### **Debug Commands:**

```bash
# Check container status
docker ps

# View container logs
docker logs <container_id>

# Enter container shell
docker exec -it <container_id> bash
```

## 💰 Pricing

### **Free Tier:**
- ✅ **Unlimited projects**
- ✅ **500 hours/month** of runtime
- ✅ **1GB storage**
- ✅ **SSL certificates**
- ✅ **Global CDN**

### **Paid Plans:**
- **Hobby**: $5/month
- **Pro**: $20/month
- **Business**: Custom pricing

## 🎉 Benefits of Railway Deployment

✅ **Professional hosting** with SSL  
✅ **Global CDN** for fast loading  
✅ **Automatic deployments** from GitHub  
✅ **Easy scaling** as you grow  
✅ **Built-in monitoring** and logs  
✅ **Free tier** for development  
✅ **Docker support** out of the box  

## 🚀 Ready to Deploy?

Your Kindle reader is now ready for Railway deployment!

**Next steps:**
1. **Push all files** to GitHub
2. **Connect to Railway** dashboard
3. **Deploy automatically** from GitHub
4. **Share your Kindle reader** with the world!

---

**Questions?** Check Railway's documentation or reach out for help! 🎯
