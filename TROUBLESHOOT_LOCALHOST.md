# 🔧 TROUBLESHOOTING: "localhost refused to connect"

You're seeing: **"Hmmm... can't reach this page"** or **"localhost refused to connect"**

This means the app isn't running properly. Let's fix it!

---

## 🔍 Step 1: Check If Services Are Running

When you ran `launch-app.bat`, you should have seen **TWO black terminal windows appear**.

### Check This:
1. Look at your taskbar (bottom of screen)
2. Do you see 2 terminal windows open?
   - One labeled something like "HavenApp-Backend"
   - One labeled something like "HavenApp-Frontend"

**If YES** → Go to Step 2
**If NO** → Go to "Problem: Services didn't start"

---

## Step 2: Check What's IN Those Terminal Windows

Look at each terminal and find one of these patterns:

### Backend Terminal Should Show (Eventually):
```
 * Running on http://127.0.0.1:5000
 * Debug mode: on
```

### Frontend Terminal Should Show (Eventually):
```
✓ Build successful
running on http://localhost:8080
```

### If You See RED ERROR Messages:

Copy the error text and check below for your issue.

---

## 🚨 Common Problems & Solutions

### Problem: "Flask not found" or "No module named 'flask'"

**Fix:**
```bash
cd backend
pip install -r requirements.txt
```
Then try launching again.

---

### Problem: "Flutter command not found"

**How to fix:**
1. Download Flutter: https://flutter.dev
2. Install it following their guide
3. Restart your computer
4. Try again

**Quick check:**
```bash
flutter --version
```
If it says "not found", Flutter isn't installed.

---

### Problem: "Python not found"

**How to fix:**
1. Download Python: https://python.org (version 3.9+)
2. **IMPORTANT:** Check "Add Python to PATH" during install
3. Restart your computer
4. Try again

**Quick check:**
```bash
python --version
```
If it says "not found" or shows, Python isn't in PATH.

---

### Problem: Can't see the terminal windows at all

The script might be trying to start them but failing silently.

**Try this instead:**
1. Open 2 Command Prompt windows
2. In the first one:
   ```bash
   cd backend
   python app.py
   ```
3. Leave that running
4. In the second one:
   ```bash
   cd mobile
   flutter run -d web --web-port=8080
   ```
5. Leave both running
6. Open browser: http://localhost:8080

---

### Problem: "Port 5000 already in use"

Something else is using port 5000.

**Quick fix:**
1. Restart your computer
2. Try again

**Or check what's using the port:**
```bash
netstat -ano | findstr :5000
```

Then kill it with:
```bash
taskkill /PID <numberfromabove> /F
```

---

### Problem: Both services say "Running" but browser still shows error

The services might be starting but not fully ready.

**Try this:**
1. Wait 30 seconds (don't close terminals)
2. **Refresh browser** - Press F5 (or Ctrl+Shift+R for hard refresh)
3. Try again in 10 seconds

---

### Problem: "CORS error" or API connection errors

The backend is running but frontend can't reach it.

**Check:**
1. Is backend terminal still showing "Running"?
2. Open new browser tab and go to: http://localhost:5000/api/health
3. If you see JSON response, backend is working
4. Go back to http://localhost:8080 and refresh (F5)

---

## ⚡ Quick Diagnostic

Run this script to check everything:

**On Windows:**
Double-click `DIAGNOSE.bat`

This will tell you exactly what's wrong!

---

## 🆘 Still Stuck?

Try this **Nuclear Option** (starts services manually):

**Terminal 1:**
```bash
cd backend
python app.py
```

Wait for it to show "Running on..."

**Terminal 2 (new window):**
```bash
cd mobile
flutter run -d web --web-port=8080
```

Wait for "running on http://localhost:8080"

Then open browser: **http://localhost:8080**

---

## ✅ How to Know It's Working

You should see:
- 2 terminal windows with "Running" messages
- Browser shows HavenApp login screen
- No error messages
- Login works with: test@example.com / password123

---

## 📝 What to Tell Me If You're Still Stuck

Copy and send me:
1. **What error message you're seeing** (exact text)
2. **What's in each terminal window** (copy the text)
3. **Did you see error messages about "Python not found" or "Flutter not found"?**

This will help me help you faster!

---

## 🚀 You've Got This!

99% of the time it's one of:
- Python not installed → Download it
- Flutter not installed → Download it
- Just need to wait longer → Refresh browser
- Just need to restart → Restart computer

Pick one and try! 💪
