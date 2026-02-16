@echo off
REM HavenApp Diagnostic Script - Checks if everything is set up correctly

echo.
echo ============================================
echo       HAVENAPP DIAGNOSTIC CHECKER
echo ============================================
echo.

echo [1/5] Checking Python...
python --version
if errorlevel 1 (
    echo ❌ PROBLEM: Python not found!
    echo    Solution: Download from https://python.org
    echo    IMPORTANT: Check "Add Python to PATH" during install
    pause
    exit /b
) else (
    echo ✅ Python found!
)

echo.
echo [2/5] Checking Flutter...
flutter --version
if errorlevel 1 (
    echo ❌ PROBLEM: Flutter not found!
    echo    Solution: Download from https://flutter.dev
    pause
    exit /b
) else (
    echo ✅ Flutter found!
)

echo.
echo [3/5] Checking backend dependencies...
cd backend
pip list | findstr Flask
if errorlevel 1 (
    echo ⚠️  Installing Python dependencies...
    pip install -q -r requirements.txt
    if errorlevel 1 (
        echo ❌ PROBLEM: Could not install dependencies
        echo    Make sure you have internet connection
        pause
        exit /b
    ) else (
        echo ✅ Dependencies installed!
    )
) else (
    echo ✅ Dependencies found!
)
cd ..

echo.
echo [4/5] Checking backend can start...
cd backend
timeout /t 2 /nobreak
echo Attempting to start Flask...
start "" python -c "from app import app; print('✅ Flask app loads successfully')"
timeout /t 2 /nobreak
cd ..

echo.
echo [5/5] Checking Flutter web support...
flutter config --enable-web | findstr enabled
if errorlevel 1 (
    echo ⚠️  Enabling Flutter web...
    flutter config --enable-web
)
echo ✅ Flutter web is enabled!

echo.
echo ============================================
echo        DIAGNOSTIC COMPLETE
echo ============================================
echo.
echo If you see ✅ for all checks above:
echo   1. Close this window
echo   2. Run: launch-app.bat
echo   3. Wait 20 seconds
echo   4. Go to: http://localhost:8080
echo.
echo If you see ❌ for any check:
echo   1. Read the solution above
echo   2. Follow the instructions
echo   3. Run this diagnostic again
echo.
pause
