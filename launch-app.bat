@echo off
REM HavenApp Launch Script for Windows
REM This script starts both the backend and mobile app

setlocal enabledelayedexpansion

echo 🚀 Starting HavenApp...
echo.

echo 📡 Starting Flask Backend on http://localhost:5000...
start cmd /k "cd backend && python app.py"

timeout /t 3 /nobreak

echo 📱 Starting Flutter Web App on http://localhost:8080...
start cmd /k "cd mobile && flutter run -d web --web-port=8080"

echo.
echo ✅ Both apps are starting!
echo.
echo 🌐 Web App: http://localhost:8080
echo 🔌 API: http://localhost:5000/api
echo.
echo To stop: Close the terminal windows or press Ctrl+C
echo.

pause
