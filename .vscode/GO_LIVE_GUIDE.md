# 🚀 VS Code - One-Click Launch Guide

Launch your entire HavenApp (Backend + Mobile Web) with a single click!

## ✅ Quick Setup (First Time Only)

### 1. Install Required Extensions
When you open the workspace, VS Code will suggest the extensions in `.vscode/extensions.json`. Click "Install All" or manually install:

- **Dart** (Dart-Code.dart-code) - Flutter support
- **Flutter** (Dart-Code.flutter) - Flutter development tools  
- **Python** (ms-python.python) - Flask backend support
- **Pylance** (ms-python.vscode-pylance) - Python intellisense

⚠️ **You MUST have Flutter SDK and Python installed locally**

### 2. Verify Prerequisites

```bash
# Check Flutter
flutter --version

# Check Python
python --version

# Check Dart
dart --version
```

If any are missing, install them before proceeding.

---

## 🎯 Launch the App (3 Options)

### **Option 1: Use "Go Live" Command (Recommended)**

1. **Press `Ctrl+Shift+D`** (or click Debug icon in left sidebar)
2. **At the top, select:** `🎯 Go Live - Full Stack (Backend + Web)`
3. **Click the blue "Start Debugging" ▶️ button**

✅ Both backend (port 5000) and Flutter web (port 8080) will launch automatically!

**URLs:**
- 🌐 Web App: http://localhost:8080
- 🔌 API: http://localhost:5000/api

---

### **Option 2: Run Individual Components**

If you want to run just one part:

**Backend Only:**
```bash
# Press Ctrl+Shift+D
# Select: "🚀 Backend Server"
# Click ▶️
```

**Flutter Web Only:**
```bash
# Press Ctrl+Shift+D
# Select: "📱 Flutter Web App"
# Click ▶️
```

---

### **Option 3: Use Command Palette**

```
Ctrl + Shift + P → "Tasks: Run Task"
```

Then select:
- `🎯 Go Live - Start Everything`
- `🔧 Run Backend Only`
- `📱 Run Flutter Web Only`

---

## 🛑 Stop the App

**Click the red ⊟ button** in the Debug toolbar, or press `Ctrl+Shift+F5`

---

## 📊 View Output

Both processes run in the integrated terminal. You'll see:

```
✓ Backend running at http://127.0.0.1:5000
✓ Flutter web running at http://localhost:8080
```

Click on the terminal tabs to switch between backend and web logs.

---

## 🔄 Restart the App

**Option 1 (Cleaner):** Stop (red ⊟) → Start (blue ▶️)

**Option 2 (Quick):** `Ctrl+Shift+F5` (restart debugging)

---

## 🐛 Debug the App

### Debug Backend (Flask)
Automatic! When you run "🚀 Backend Server":
- Set breakpoints in Python code
- Variables auto-display on left panel
- Step through code with F10 (step over), F11 (step in)

### Debug Frontend (Flutter)
Automatic! When you run "📱 Flutter Web App":
- Use Flutter DevTools that opens in browser
- Set breakpoints in Dart code
- Hot reload with `r` in terminal

---

## 💡 Pro Tips

### 1. Hot Reload (Without Restarting)
While Flutter is running, press `r` in the terminal to hot reload code changes.

### 2. Hot Restart (Full Rebuild)
Press `R` in the terminal to restart the entire app.

### 3. Open DevTools While Running
In the Flutter web terminal, press `w` to open the web app in a browser.

### 4. Install New Dependencies
If you add packages:

**Python (Backend):**
```bash
cd backend
pip install <package-name>
pip freeze > requirements.txt
```

**Flutter (Mobile):**
```bash
cd mobile
flutter pub add <package-name>
```

Then restart debugging.

### 5. Test API Endpoints
Use the built-in REST Client extension:

Create file: `test-api.http`
```http
### Register User
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123",
  "name": "Test User"
}

### Login
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}
```

Click "Send Request" above each block to test live.

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

### "Port 5000 already in use"
```bash
# Find process using port 5000
lsof -i :5000  # macOS/Linux
netstat -ano | findstr :5000  # Windows

# Kill process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### "Port 8080 already in use"
Same as above but for port 8080.

### Backend won't start
Check logs in terminal:
1. Is database initialized? Run: `heroku run python -c "from app import app, db; app.app_context().push(); db.create_all()"`
2. Are all dependencies installed? Run: `pip install -r backend/requirements.txt`

### Flutter web won't load
1. Wait for "Launching web app..." message
2. Check terminal for Dart/Flutter errors
3. Try `R` (restart) in Flutter terminal
4. Check browser console (F12) for JS errors

### API calls fail from web app
1. Verify backend is running (check http://localhost:5000/api/health)
2. Check browser console for CORS errors
3. Verify `environment_config.dart` uses `http://localhost:5000/api`

---

## 🔑 Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+D` | Open Debug tab |
| `F5` | Start debugging |
| `Ctrl+Shift+F5` | Restart debugging |
| `Shift+F5` | Stop debugging |
| `F10` | Step over (Debug) |
| `F11` | Step into (Debug) |
| `Shift+F11` | Step out (Debug) |
| `Ctrl+K+Ctrl+0` | Fold all (Editor) |
| `Ctrl+K+Ctrl+J` | Unfold all (Editor) |

---

## 📝 File Structure

```
.vscode/
├── launch.json         ← Debug configurations
├── tasks.json          ← Build and run tasks
├── settings.json       ← Workspace settings
└── extensions.json     ← Recommended extensions

backend/
├── app.py              ← Flask app entry point
├── requirements.txt    ← Python dependencies
└── ...

mobile/
├── lib/
│   └── main.dart       ← Flutter app entry point
├── pubspec.yaml        ← Flutter dependencies
└── ...
```

---

## ✨ What Happens When You Click "Go Live"

1. **Dependency Check** - Installs any missing Python/Flutter packages
2. **Backend Starts** - Flask app runs on http://localhost:5000
3. **Database Init** - SQLite database created if needed
4. **Flutter Dev Server** - Web compiler starts on http://localhost:8080
5. **Browser Opens** - (Optional) Web app loads automatically
6. **Logs Stream** - Both processes output to integrated terminal

Total startup time: **10-30 seconds**

---

## 🎉 Success!

When you see this, everything is running:

```
✓ Running on http://127.0.0.1:5000 (Press CTRL+C to quit)
✓ Launching devices for web...
✓ lib/main.dart on Chrome at http://localhost:8080
```

Now you can:
- 🌐 Open http://localhost:8080 in your browser
- 📝 Register a new account
- 🔐 Log in
- 📱 Use the full app
- 🔌 Test all API endpoints

Enjoy! 🚀

