@echo off
REM HavenApp Launch Script for Windows
REM This script starts both the backend and mobile app

setlocal enabledelayedexpansion

echo.
echo ════════════════════════════════════════════════════════
echo              LAUNCHING HAVENAPP
echo ════════════════════════════════════════════════════════
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    echo.
    echo How to fix:
    echo 1. Download Python: https://python.org
    echo 2. Run installer and CHECK "Add Python to PATH"
    echo 3. Click Start, type "cmd", run: python --version
    echo 4. If it works, try launching again
    echo.
    pause
    exit /b 1
)
echo [OK] Python found

REM Check Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter not found!
    echo.
    echo How to fix:
    echo 1. Download Flutter: https://flutter.dev
    echo 2. Follow installation instructions
    echo 3. Restart your computer
    echo 4. Try launching again
    echo.
    pause
    exit /b 1
)
echo [OK] Flutter found
echo.

echo ════════════════════════════════════════════════════════
echo                STARTING SERVICES
echo ════════════════════════════════════════════════════════
echo.

echo Starting Flask Backend...
start "HavenApp-Backend" cmd /k "cd backend && python app.py"

timeout /t 3 /nobreak

echo Starting Flutter Web...
start "HavenApp-Frontend" cmd /k "cd mobile && flutter run -d web --web-port=8080"

echo.
echo ════════════════════════════════════════════════════════
echo.
echo [*] Two terminal windows should appear
echo [*] DON'T CLOSE THEM - they're showing the app running
echo.
echo [*] Open your browser and go to:
echo
echo     http://localhost:8080
echo.
echo [*] Wait 15-20 seconds for everything to load
echo [*] You should see the login page
echo.
echo [*] Login with:
echo     Email: test@example.com
echo     Password: password123
echo.
echo ════════════════════════════════════════════════════════
echo.

pause
