# 🚀 VS Code - One-Click Launch Guide

Launch your entire HavenApp (Backend + Mobile Web) with a single click!

## ⚡ Super Quick Start (30 seconds)

**On Windows:** Double-click `launch-app.bat` in the root folder
**On Mac/Linux:** Run `bash launch-app.sh` in the root folder

Done! Both apps will open in new terminal windows. Go to http://localhost:8080

---

## ✅ VS Code Debug Method (Alternative)

### 1. First Time Setup

When you open the workspace, VS Code will suggest extensions. Install these:
- **Dart** (Dart-Code.dart-code)
- **Flutter** (Dart-Code.flutter)
- **Python** (ms-python.python)
- **Pylance** (ms-python.vscode-pylance)

⚠️ **IMPORTANT:** Verify you have:
- `flutter --version` (should show version)
- `python --version` (should show 3.9+)
- `dart --version` (should show version)

---

## 🎯 Launch via VS Code Debug (Alternative)

### 2. Start the App

1. **Press `Ctrl+Shift+D`** (opens Debug panel)
2. **Select dropdown at top:** `🎯 Go Live - Full Stack (Backend + Web)`
3. **Click the blue ▶️ "Start Debugging" button**

Wait 10-30 seconds for both to start.

### 3. Access Your App

- 🌐 **Web App:** http://localhost:8080
- 🔌 **API:** http://localhost:5000/api

---

## 🆘 Troubleshooting

### "I see a directory listing instead of the Flask app"
**Problem:** Live Server extension took over instead of Flask starting.
**Solution:** 
1. Stop the debugger (click red ⊟ button)
2. Click the Flask logo icon in the left sidebar to disable Live Server
3. Or use the simple `launch-app.bat/sh` script instead (recommended)

---

## � Pro Tips

---

## 🐛 Troubleshooting

### "Python not found"
```bash
# Make sure Python is in PATH
python --version

# Or use full path
/usr/bin/python3 --version
```

### "Flutter not found"
```bash
flutter --version
# If not found, add Flutter SDK to PATH
```

### "Flutter not found"
```bash
flutter --version
# If error, add Flutter SDK to PATH or use full path
# Or just use launch-app.bat/sh instead
```

### "Python not found"
```bash
python --version
# If error, add Python to PATH
# Or use python3 if available
```

### "Port 5000 already in use"
```bash
# Find and kill process using port 5000
# Windows:
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux:
lsof -i :5000
kill -9 <PID>
```

### "Port 8080 already in use"
Same as above but for port 8080

### "Backend starts but API returns 404"
1. Check database is initialized: `heroku run python -c "from app import app, db; app.app_context().push(); db.create_all()"`
2. Test API: Open http://localhost:5000/api/health in browser
3. Check terminal for errors

### "Recommended: Just use the startup script"
The easiest, most reliable method:

**Windows:** Double-click `launch-app.bat`
**Mac/Linux:** Run `bash launch-app.sh` in terminal

This avoids all VS Code complexity and just starts your apps!

---

## 🎮 Run Individual Components (If Needed)

**Want just the backend?** (test in Postman/REST Client)
```bash
cd backend
python app.py
# Runs on http://localhost:5000/api
```

**Want just the Flutter web?**
```bash
cd mobile
flutter run -d web --web-port=8080
# Opens http://localhost:8080
```

---

## 🔄 Hot Reload During Development

**While Flutter is running:**
- Press `r` in terminal for **hot reload** (fast, code changes only)
- Press `R` for **hot restart** (slower, full app restart)

**While Python backend is running:**
- Changes auto-reload if `FLASK_ENV=development` is set
- Restart terminal if changes don't appear

