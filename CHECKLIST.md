# 📋 HavenApp Launch Checklist

Use this checklist to make sure everything is set up correctly.

---

## ✅ Before You Start

- [ ] Python is installed (`python --version` shows a number)
- [ ] Flutter is installed (`flutter --version` shows a number)  
- [ ] You have the project folder open
- [ ] You can see these files/folders:
  - [ ] `backend` folder
  - [ ] `mobile` folder
  - [ ] `launch-app.bat` (Windows) or `launch-app.sh` (Mac/Linux)

---

## ✅ Launch Phase 1: Start the App

**Windows:**
- [ ] Double-click `launch-app.bat`
- [ ] Two terminal windows appear
- [ ] Wait 15-20 seconds

**Mac/Linux:**
- [ ] Open Terminal
- [ ] Run: `bash launch-app.sh`
- [ ] Two terminal windows appear
- [ ] Wait 15-20 seconds

---

## ✅ Launch Phase 2: Check Terminals

**Terminal 1 (Backend) should show:**
- [ ] `Running on http://127.0.0.1:5000`
- [ ] `Debug mode: on` or similar
- [ ] No red error messages

**Terminal 2 (Flutter) should show:**
- [ ] `Launching devices for web...`
- [ ] `Build successful` 
- [ ] `running on http://localhost:8080`
- [ ] No red error messages

---

## ✅ Launch Phase 3: Open Browser

- [ ] Open your web browser (Chrome, Firefox, Safari, Edge)
- [ ] Go to: **http://localhost:8080**
- [ ] Press Enter
- [ ] Wait 5 seconds for page to load

---

## ✅ You Should See

- [ ] HavenApp logo/title
- [ ] Email field
- [ ] Password field
- [ ] "Sign in" button

If you see this, skip to "✅ Login Test" below

---

## ✅ If You See a Blank Page or Error

Try these in order:

1. [ ] Refresh browser (press F5)
2. [ ] Check both terminals are still running
3. [ ] Wait 10 more seconds
4. [ ] Try `http://localhost:8080` again
5. [ ] Try `http://127.0.0.1:8080` instead
6. [ ] Close browser tab and open link again

---

## ✅ Login Test

- [ ] Click on Email field
- [ ] Type: `test@example.com`
- [ ] Click on Password field  
- [ ] Type: `password123`
- [ ] Click "Sign in" button
- [ ] Wait 3 seconds

---

## ✅ You Should See Dashboard

- [ ] Large circle with safety indicator
- [ ] "Emergency" button (red)
- [ ] Navigation tabs at bottom: Journal, Resources, Settings

---

## ✅ Test the Features

Try each one:

- [ ] Click the red Emergency button → Should show confirmation dialog
- [ ] Click "Journal" tab → Should show journal entries
- [ ] Click "Resources" tab → Should show support hotlines
- [ ] Click "Settings" tab → Should show privacy options
- [ ] Click "Logout" → Should return to login screen

---

## 🎉 SUCCESS!

If all checkboxes are checked, **you have successfully launched HavenApp!**

The app is:
- Running locally on your computer
- Connected to a working backend API
- Ready to test all features

---

## ⚠️ Troubleshooting

| Problem | Quick Fix |
|---------|-----------|
| Blank page | Refresh (F5) and wait 10 seconds |
| Login doesn't work | Make sure backend terminal shows "Running on" |
| Can't see terminal windows | They might be minimized - check taskbar |
| Red error messages | Note the error, see START_HERE.md |
| 404 errors | Check both terminals are running |
| "Can't connect to API" | Backend might not be running - check terminal 1 |

---

## 📞 Still Having Issues?

1. Check `START_HERE.md` → Common issues & solutions
2. Check `RUNNING_THE_APP.md` → Detailed guide
3. Take a screenshot of the error and save it

You're doing great! Don't give up! 💪
