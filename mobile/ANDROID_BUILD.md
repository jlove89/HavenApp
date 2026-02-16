# Android Build Configuration

## Minimum Requirements
- Android API 24 (Android 7.0) or higher
- Android Studio 4.2 or higher

## Generate Signing Key

```bash
keytool -genkey -v -keystore ~/havenapp-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias havenapp
```

When prompted:
- **KeyStore Password**: Create a strong password
- **Key Password**: Can be same or different
- **First and Last Name**: Your name
- **Organizational Unit**: Leave blank or your organization
- **Organization**: Your company/org
- **City**: Your city
- **State/Province**: Your state
- **Country Code**: US (or your country code)

Save the password securely - you'll need it for every build.

## Create Key Configuration

Create `android/key.properties`:

```properties
storeFile=/path/to/havenapp-release.jks
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=havenapp
```

**Important:** Add `android/key.properties` to `.gitignore` - never commit passwords!

## Configure Gradle Build

Edit `android/app/build.gradle`:

```gradle
android {
  compileSdkVersion 34

  signingConfigs {
    release {
      keyAlias keystoreProperties['keyAlias']
      keyPassword keystoreProperties['keyPassword']
      storeFile file(keystoreProperties['storeFile'])
      storePassword keystoreProperties['storePassword']
    }
  }

  buildTypes {
    release {
      signingConfig signingConfigs.release
      minifyEnabled true
      shrinkResources true
      proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
  }
}
```

## Build Commands

### Debug APK
```bash
flutter build apk --debug
```

## Release APK
```bash
flutter build apk --release
```

### Release App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

## AndroidManifest.xml Permissions

Required permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BODY_SENSORS" />
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

<!-- Foreground Service for background detection -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

## Google Play Store Setup

1. Create Google Play Developer account ($25 one-time)
2. Create app in Play Console
3. Fill in app details:
   - Title
   - Description
   - Category (Health & Fitness)
   - Content rating (complete questionnaire)
   - Screenshots (min 2 per device type)
   - Feature graphic (1024x500)

4. Upload app bundle:
   ```bash
   flutter build appbundle --release
   # Upload build/app/outputs/bundle/release/app-release.aab
   ```

5. Create release:
   - Internal Testing → Release → Add build
   - Staged rollout (1% → 5% → 25% → 100%)

6. Complete store listing and submit for review

## Size Optimization

To reduce APK size:

```bash
# Enable R8 code shrinking
flutter build apk --release -v

# Or in gradle:
minifyEnabled true
shrinkResources true
```

## Target API Level

Update in `android/app/build.gradle`:

```gradle
android {
  compileSdkVersion 34  // Latest API level
  
  defaultConfig {
    minSdkVersion 24  // Android 7.0
    targetSdkVersion 34  // Latest
  }
}
```

## Troubleshooting

### "Keystore file not found"
Check path in key.properties is correct (use absolute path)

### "Key password incorrect"
Verify password in key.properties matches what you set

### Build too large
- Enable minifyEnabled and shrinkResources
- Use app bundle instead of APK
- Check for large assets

### App crashes on old devices
- Increase minSdkVersion only if needed
- Test on Android 7.0 (API 24) minimum

