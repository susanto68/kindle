# InfinityFree Upload Checklist

## 📋 **Step-by-Step Upload Process**

### **Step 1: Prepare Files**
- [ ] Rename `reader.js` to `reader.txt`
- [ ] Keep `style.css` as is (CSS files upload fine)
- [ ] Have your book image folders ready

### **Step 2: Access InfinityFree File Manager**
- [ ] Login to InfinityFree control panel
- [ ] Click "File Manager"
- [ ] Navigate to `htdocs` folder

### **Step 3: Create Folder Structure**
```
htdocs/
├── css/     ← Create this folder
├── js/      ← Create this folder  
├── flipbook/ ← Create this folder
└── books/   ← Create this folder
```

### **Step 4: Upload Files**

#### **Root Files (upload to htdocs/):**
- [ ] `index.php`
- [ ] `health.php`
- [ ] `.htaccess`

#### **CSS Folder (upload to css/):**
- [ ] `style.css`

#### **JS Folder (upload to js/):**
- [ ] `reader.txt` (renamed from reader.js)

#### **Flipbook Folder (upload to flipbook/):**
- [ ] `index.html` (your flipbook reader)

#### **Books Folder (upload to books/):**
- [ ] Create subfolders: `book1/`, `book2/`, etc.
- [ ] Upload images to each book folder

### **Step 5: Fix JavaScript File**
- [ ] Go to `js/` folder in File Manager
- [ ] Right-click `reader.txt`
- [ ] Choose "Rename"
- [ ] Change to `reader.js`

### **Step 6: Set Permissions**
- [ ] All folders: `755`
- [ ] All files: `644`

### **Step 7: Test Everything**

#### **Test Health Check:**
```
https://yourname.infinityfreeapp.com/health.php
```
Should show: "OK - InfinityFree Hosted"

#### **Test Main Page:**
```
https://yourname.infinityfreeapp.com/
```
Should show your book library

#### **Test JavaScript:**
```
https://yourname.infinityfreeapp.com/js/reader.js
```
Should show JavaScript code (not 404)

#### **Test CSS:**
```
https://yourname.infinityfreeapp.com/css/style.css
```
Should show CSS code

## 🚨 **Common Upload Errors & Fixes**

### **Error: "File type not allowed"**
- **Solution:** Rename `.js` files to `.txt` before upload

### **Error: "Upload failed"**
- **Solution:** Try smaller files, or use ZIP upload method

### **Error: "Permission denied"**
- **Solution:** Set folder permissions to `755`, file permissions to `644`

### **Error: "File not found" (404)**
- **Solution:** Check file is in correct folder, check filename spelling

## ✅ **Success Indicators**

Your upload is successful when:
- [ ] All URLs load without 404 errors
- [ ] Main page shows book folders
- [ ] JavaScript file is accessible
- [ ] CSS styling is applied
- [ ] Images load in book folders

## 📞 **Need Help?**

If you're still having issues:
1. Try the ZIP upload method
2. Contact InfinityFree support
3. Post in InfinityFree community forum
