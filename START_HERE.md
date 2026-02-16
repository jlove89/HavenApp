# 🎯 START HERE - Launch HavenApp in 2 Minutes

**Welcome! Follow these simple steps to get the app running.**

---

## ⚡ The Easiest Way (2 clicks on Windows, 1 command on Mac)

### **On Windows:**
1. Open your project folder: `C:\Users\lovem\HavenApp\HavenApp`
2. **Double-click `launch-app.bat`**
3. Wait 10 seconds
4. Open your browser: **http://localhost:8080**

✅ **That's it!** You'll see the HavenApp login screen.

---

### **On Mac/Linux:**
1. Open Terminal
2. Drag your project folder into Terminal (or type: `cd` then paste the path)
3. Copy-paste this command:
```bash
bash launch-app.sh
```
4. Press Enter
5. Open your browser: **http://localhost:8080**

✅ **Done!** You'll see the login screen.

---

## 📱 What You'll See

When you open http://localhost:8080 in your browser:

**Login Screen:**
- Email: `test@example.com`
- Password: `password123`
- Click "Sign in"

**Dashboard:**
- Risk meter (safety indicator)
- Emergency button (red button)
- Navigation tabs at bottom (Journal, Resources, Settings)

---

## 🆘 Something Not Working?

### "I don't see anything happen when I double-click the file"
- Right-click `launch-app.bat`
- Select "Open with"
- Choose "Command Prompt" or "Windows PowerShell"

### "It says 'Python not found'"
- You need Python installed
- Download from: https://www.python.org/downloads/
- Choose version 3.9 or higher
- **IMPORTANT:** Check "Add Python to PATH" during install
- Restart and try again

### "It says 'Flutter not found'"
- You need Flutter SDK installed
- Download from: https://flutter.dev/docs/get-started/install
- Follow the installation guide for your OS
- Restart terminal and try again

### "Port 5000 is already in use"
- Something else is using that port
- **Simple fix:** Unplug your WiFi adapter or restart your computer
- Then try again

### "I get a blank page or error"
- Wait 15-20 seconds for everything to start
- Refresh the browser (press F5)
- Check if both terminal windows say "Running" or "listening"

### "It opens but localhost isn't responding"
- Check if you have 2 terminal windows open (one for backend, one for Flutter)
- If only 1 terminal, the backend didn't start
- Close and try again

---

## ✅ How to Know It's Working

You should see:

**Terminal 1 (Backend):**
```
 * Running on http://127.0.0.1:5000
 * Debug mode: on
```

**Terminal 2 (Flutter):**
```
✓ Build successful
✓ running on http://localhost:8080
```

**Browser:**
Shows HavenApp login screen with a safety icon

---

## 🧪 Test It

Once you're logged in:

1. **Click the Emergency button** (red circle) → Should create an alert
2. **Click "Journal"** → Can add safety notes
3. **Click "Resources"** → Shows support hotlines
4. **Click "Settings"** → Can see privacy options

Everything working? 🎉 **You've successfully launched HavenApp!**

---

## 🛑 Stop the App

**Windows:**
- Click the X button on both terminal windows

**Mac/Linux:**
- In each terminal, press `Ctrl+C`

---

## ❓ I'm Still Stuck

**Don't worry!** Common issues:

1. **Make sure both are installed:**
   ```bash
   python --version
   flutter --version
   ```
   Both should show a version number (not "not found")

2. **Check your project folder:**
   - Should contain: `backend`, `mobile`, `launch-app.bat`, `launch-app.sh`
   - If files are missing, re-download the project

3. **Try the alternative method:**
   Instead of the startup script, open 2 separate terminals:
   
   **Terminal 1 - Backend:**
   ```bash
   cd backend
   python app.py
   ```
   
   **Terminal 2 - App:**
   ```bash
   cd mobile
   flutter run -d web --web-port=8080
   ```

---

## 🎓 What's Actually Running?

When you launch:
- **Backend (app.py):** A Python server that stores data and handles login
- **Frontend (main.dart):** A Flutter app that displays the UI in your browser

Both need to run together for the app to work!

---

## 📚 Next Steps

Once you have it running:
- Explore all the screens
- Test the features
- Read the full guide: See `RUNNING_THE_APP.md` for advanced options

---

## 👍 You've Got This!

This is a real, working application. Be proud! 🚀

**Questions?** Check `RUNNING_THE_APP.md` for detailed troubleshooting.
