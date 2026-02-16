# Running Haven: Mobile App + Backend

This guide covers running both the Flutter mobile app and the Flask backend API for the complete Haven safety application.

## Prerequisites

### Mobile App

- **Flutter SDK** (3.0+): https://flutter.dev/docs/get-started/install
- **iOS**: Xcode with iOS deployment target 12.0+
- **Android**: Android SDK API 21+

### Backend API

- **Python** 3.8+
- **pip** (Python package manager)

## Quick Start (Recommended)

Run both in separate terminals:

**Terminal 1 - Backend API:**

```bash
cd backend
pip install -r requirements.txt
python app.py
```

**Terminal 2 - Mobile App:**

```bash
cd mobile
flutter pub get
flutter run
```

---

# Backend API Setup

## Installation

### 1. Navigate to backend directory

```bash
cd backend
```

### 2. Create virtual environment (optional but recommended)

```bash
# macOS/Linux
python -m venv venv
source venv/bin/activate

# Windows
python -m venv venv
venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Load environment variables

The `.env` file is already configured for development with SQLite. No additional setup needed.

### 5. Run the server

```bash
python app.py
```

Server will start on `http://localhost:5000`

## API Endpoints

### Authentication

- `POST /api/auth/register` — Register new user

  ```bash
  curl -X POST http://localhost:5000/api/auth/register \
    -H "Content-Type: application/json" \
    -d '{
      "email": "user@example.com",
      "password": "Password123",
      "name": "User Name"
    }'
  ```

- `POST /api/auth/login` — Login user
  ```bash
  curl -X POST http://localhost:5000/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{
      "email": "user@example.com",
      "password": "Password123"
    }'
  ```

### Alerts

- `GET /api/alerts` — Get all user alerts (requires JWT token)
- `POST /api/alerts` — Create alert (panic button, manual)
- `GET /api/alerts/<id>` — Get specific alert
- `PUT /api/alerts/<id>/acknowledge` — Mark as acknowledged

### Signals

- `GET /api/signals` — Get detected signals
- `POST /api/signals` — Record new signal

### User

- `GET /api/user` — Get current user profile
- `PUT /api/user` — Update profile
- `GET /api/user/consent` — Get consent settings
- `PUT /api/user/consent` — Update consent

### Health

- `GET /api/health` — Health check

## Database

**Development**: SQLite (`havenapp.db`)
**Testing**: In-memory `:memory:`
**Production**: PostgreSQL (configure `DATABASE_URL`)

Database is automatically initialized on first run.

## Configuration

Edit `backend/.env` to change settings:

```
FLASK_ENV=development          # development, testing, production
DATABASE_URL=sqlite:///havenapp.db
SECRET_KEY=dev-secret-key-change-in-prod
JWT_SECRET_KEY=dev-jwt-secret-change-in-prod
```

For PostgreSQL in production:

```
DATABASE_URL=postgresql://user:password@host:5432/havenapp
```

---

# Mobile App Setup

## Installation

### 1. Navigate to mobile directory

```bash
cd mobile
```

### 2. Get Flutter dependencies

```bash
flutter pub get
```

### 3. Run on iOS (macOS only)

```bash
# List available devices
flutter devices

# Run on iPhone simulator
flutter run -d iPhone

# Or run on specific device
flutter run -d <device_id>
```

### 4. Run on Android

```bash
# Start Android emulator first, then:
flutter run

# Or specify emulator
flutter run -d emulator-5554
```

### 5. Run on web (experimental)

```bash
flutter run -d chrome
```

## Configuration

The mobile app is pre-configured to connect to the backend at `http://localhost:5000/api`.

To change the backend URL, edit `mobile/lib/services/api_service.dart`:

```dart
static const String _baseUrl = 'http://localhost:5000/api';
```

## App Features

### Authentication

- Register new account
- Login with email/password
- Secure token storage (OS keychain)
- Automatic session restoration

### Safety Dashboard

- Real-time risk meter (0-100%)
- Panic button (red EMERGENCY button)
- Recent alerts list
- Risk color coding (green/yellow/orange/red)

### Safety Journal

- Create safety entries
- Timestamp tracking
- Local storage

### Support Resources

- National DV Hotline: 1-800-799-7233
- Crisis Text Line: Text HOME to 741741
- Legal aid and shelter information
- Safety planning guides

### Settings

- Privacy consent toggles
  - Passive signal detection
  - Location tracking
  - Journal backup
  - Emergency sharing
- Account management
- Profile editing
- Logout / Delete account

## Troubleshooting

### Backend Port Already in Use

```bash
# Find process using port 5000
lsof -i :5000

# Kill it
kill -9 <PID>
```

### Flutter "No Devices Found"

- **iOS**: Open Xcode > Devices & Simulators, start a simulator
- **Android**: Start Android emulator or connect device with `adb devices`

### "Connection refused" when mobile app tries to reach backend

Ensure:

1. Backend is running on port 5000
2. Mobile app points to correct URL
3. No firewall blocking localhost:5000
4. For Android emulator: use `10.0.2.2` instead of `localhost`

### JWT Token Expired

Mobile app automatically logs user out and redirects to login screen.

### Database Lock (SQLite)

SQLite has limited concurrency. Switch to PostgreSQL for production:

```bash
export DATABASE_URL=postgresql://user:pass@localhost:5432/havenapp
python app.py
```

---

# Full Stack Testing

## Test Workflow

1. **Register User**

   ```bash
   curl -X POST http://localhost:5000/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "email": "testuser@example.com",
       "password": "TestPassword123",
       "name": "Test User"
     }'
   ```

   Save the `access_token` from response.

2. **Login on Mobile App**
   - Launch app
   - Email: `testuser@example.com`
   - Password: `TestPassword123`
   - Should navigate to Dashboard

3. **Create Alert via API**

   ```bash
   curl -X POST http://localhost:5000/api/alerts \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer <access_token>" \
     -d '{
       "type": "panic",
       "riskLevel": 0.95,
       "signals": ["manual_activation"]
     }'
   ```

4. **View Alert in Mobile App**
   - Navigate to Dashboard
   - Risk meter should turn red
   - Alert should appear in "Recent Alerts" list

5. **Test Panic Button**
   - Tap red EMERGENCY button
   - Confirm dialog
   - Check backend for new alert: `GET /api/alerts`

---

# Deployment

## Backend Deployment

### Using Gunicorn (Production)

```bash
gunicorn -w 4 -b 0.0.0.0:5000 'app:create_app()'
```

### Docker

```bash
docker build -t haven-backend -f backend/Dockerfile .
docker run -p 5000:5000 haven-backend
```

### Cloud (AWS, GCP, Azure)

See cloud provider documentation for Flask apps.

## Mobile App Deployment

### iOS App Store

```bash
flutter build ios --release
# Follow Xcode steps to upload to App Store
```

### Google Play Store

```bash
flutter build appbundle
# Upload to Google Play Console
```

---

# Environment Variables Reference

## Backend (.env file)

```bash
FLASK_ENV=development
FLASK_DEBUG=True
DATABASE_URL=sqlite:///havenapp.db
SECRET_KEY=your-secret-key
JWT_SECRET_KEY=your-jwt-secret
LOG_LEVEL=INFO
```

See `backend/.env.example` for all options.

## Mobile App

Configuration in `mobile/lib/services/api_service.dart`:

- `_baseUrl` — Backend API URL

---

# Support & Documentation

- **Mobile App**: See `mobile/README.md`
- **Backend API**: See `backend/README.md`
- **Full Documentation**: See `docs/` folder
  - ETHICS_PRIVACY.md — Privacy & consent framework
  - DETECTION_APPROACH.md — Signal detection algorithm
  - BACKEND_ARCHITECTURE.md — API design & database
  - MOBILE_ARCHITECTURE.md — App structure

---

**Have questions?** Check the main README.md or open an issue on GitHub.

### File Organization

```
mobile/lib/
├── main.dart                          # App entry point
├── config/
│   └── theme.dart                    # Material Design 3 theme
├── models/
│   ├── user.dart                     # User & ConsentScope
│   └── alert.dart                    # Alert & risk colors
├── providers/
│   ├── auth_provider.dart            # Login/Register logic
│   └── alert_provider.dart           # Alert & panic button
├── services/
│   ├── auth_service.dart             # Secure token storage
│   └── api_service.dart              # HTTP client with JWT
└── screens/
    ├── auth/
    │   ├── login_screen.dart         # Email/password login
    │   └── register_screen.dart       # New account creation
    └── dashboard/
        └── dashboard_screen.dart      # Safety dashboard + panic button
```

## Features Implemented

### ✅ Core Infrastructure

- **Theme System** (Material Design 3, light/dark mode)
- **Models** (User with consent toggles, Alert with risk scores)
- **Authentication Service** (flutter_secure_storage for JWT)
- **API Service** (Dio HTTP client with token injection)

### ✅ State Management

- **AuthProvider** (Login, register, logout, session restore)
- **AlertProvider** (Fetch alerts, create panic alerts)

### ✅ Screens

- **SplashScreen** (Auto-checks auth on startup)
- **LoginScreen** (Email/password form)
- **RegisterScreen** (Full validation)
- **DashboardScreen** with:
  - Risk meter (color-coded safety level: green/yellow/orange/red)
  - Large red EMERGENCY/panic button with confirmation dialog
  - Recent alerts list
  - Bottom navigation (Dashboard, Journal, Resources, Settings)
  - Logout button

## Testing the App

### Demo Flow

1. **Launch** → Sees splash screen for 1 second
2. **Login** → Route to LoginScreen (no backend running? Will error, but UI works)
3. **Register** → Full form with validation (8+ char password, match confirmation)
4. **Dashboard** → Shows:
   - Green "Safe" meter initially (risk score 0.0)
   - Red EMERGENCY button (large, obvious)
   - Empty alerts list ("No alerts yet")
   - Bottom nav bar with 4 tabs

### Panic Button

- Tap red EMERGENCY button
- Confirmation dialog appears
- Press "Send Alert" → shows snackbar "Emergency alert sent to your contacts"
- Alert gets added to list (if backend running, will POST to `/alerts`)

### Navigation

- Bottom nav tabs work (Dashboard, Journal, Resources, Settings)
- Journal/Resources/Settings show placeholders (Coming soon)
- Logout button in top-right logs out and returns to LoginScreen

## Backend Requirement (NOT YET IMPLEMENTED)

**The Flutter app is ready to communicate with a Python Flask backend.**

Required endpoints (not yet built):

- `POST /api/auth/login` — Expects `{access_token, user}`
- `POST /api/auth/register` — Expects `{access_token, user}`
- `POST /api/auth/logout` — No auth required
- `GET /api/alerts` — Returns list of Alert objects
- `POST /api/alerts` — Creates new alert, returns Alert object

Base URL is hardcoded to `http://localhost:5000/api` in `mobile/lib/services/api_service.dart`.

### To build backend:

```bash
cd backend
pip install -r requirements.txt
# Then implement Flask app (NOT YET DONE)
python app.py  # Will fail - app.py doesn't exist yet
```

## Troubleshooting

### "flutter: command not found"

Install Flutter: https://flutter.dev/docs/get-started/install

### "No connected devices"

- For iOS: Open Simulator before running
- For Android: Start emulator or connect device via USB with USB debugging enabled

### "API errors when testing"

Expected behavior - backend not yet implemented. The UI still renders correctly.

### "Widget test failures"

Run `flutter analyze` to check for lint issues, or `flutter test` to run unit tests (not yet implemented).

## Next Steps

1. **Backend Implementation** (Python Flask)
   - Build `/api/auth/login`
   - Build `/api/auth/register`
   - Build signal collection & alert scoring
   - Build panic button workflow

2. **Additional Screens** (Journal, Resources, Settings)
   - Full implementations coming

3. **On-Device Signal Detection**
   - Heuristic scoring (already designed, not yet implemented)
   - Location tracking, communication patterns, device usage

4. **Deployment**
   - Build APK for Android
   - Build IPA for iOS
   - Submit to app stores

---

For questions, see the full documentation in `docs/` folder.
