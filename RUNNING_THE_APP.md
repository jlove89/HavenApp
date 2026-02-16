# Running Haven Mobile App

## Prerequisites

You must have Flutter SDK installed. If not, install from https://flutter.dev/docs/get-started/install

Verify your setup:

```bash
flutter doctor
```

## Getting Started

### 1. Navigate to mobile directory

```bash
cd mobile
```

### 2. Get dependencies

```bash
flutter pub get
```

### 3. Run on iOS (macOS only)

```bash
flutter run -d iPhone
```

Or if you have multiple devices:

```bash
flutter devices  # List available devices
flutter run -d <device_id>
```

### 4. Run on Android

```bash
flutter run -d emulator-5554
```

Or to run on the first available device:

```bash
flutter run
```

## App Structure

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
