# iOS Build Configuration

## Minimum Requirements
- iOS 12.0 or higher
- Xcode 13.0 or higher

## Build Commands

### Debug Build
```bash
flutter build ios
```

### Release Build
```bash
flutter build ios --release
```

### For Archive and Signing
```bash
flutter build ios --release --no-pub
open ios/Runner.xcworkspace
```

In Xcode:
1. Select Product → Scheme → Edit Scheme
2. Set Build Configuration to Release
3. Product → Archive

## App Store Connect Setup

1. Create app in App Store Connect
2. Configure app capabilities and permissions
3. Build and archive app
4. Upload via Transporter or Xcode

## Signing Configuration

Add to `ios/Podfile` if needed:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

## Required Info.plist Keys

The app requires these permissions in `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>HavenApp needs your location to detect and prevent unsafe situations</string>

<key>NSMotionUsageDescription</key>
<string>HavenApp uses motion data for safety detection</string>

<key>NSContactsUsageDescription</key>
<string>HavenApp accesses contacts for emergency contact features</string>

<key>NSCalendarsUsageDescription</key>
<string>HavenApp accesses calendar for safety patterns</string>

<key>NSMicrophoneUsageDescription</key>
<string>HavenApp uses microphone for emergency detection</string>
```

## TestFlight Distribution

1. Create signing certificate in Apple Developer
2. Build and archive the app
3. Upload via Transporter
4. Create TestFlight release
5. Add internal testers (your email)
6. Send external invite links to beta testers

