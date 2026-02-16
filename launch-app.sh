#!/bin/bash
# HavenApp Launch Script
# This script starts both the backend and mobile app

cd "$(dirname "$0")"

echo "🚀 Starting HavenApp..."
echo ""

# Start backend in background
echo "📡 Starting Flask Backend on http://localhost:5000..."
cd backend
python app.py &
BACKEND_PID=$!
cd ..

# Give backend a moment to start
sleep 3

# Start Flutter web
echo "📱 Starting Flutter Web App on http://localhost:8080..."
cd mobile
flutter run -d web --web-port=8080 &
FLUTTER_PID=$!
cd ..

echo ""
echo "✅ Both apps are starting!"
echo ""
echo "🌐 Web App: http://localhost:8080"
echo "🔌 API: http://localhost:5000/api"
echo ""
echo "To stop:"
echo "  - Press Ctrl+C in this terminal"
echo "  - Or manually kill processes $BACKEND_PID and $FLUTTER_PID"
echo ""

# Wait for both processes
wait
