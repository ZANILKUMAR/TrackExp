# TrackExp - Quick Commands Reference

## 🚀 Essential Commands

### Initial Setup
```powershell
# Navigate to project
cd f:\MyProjects\TrackExp

# Install dependencies
flutter pub get

# Generate Hive adapters (REQUIRED!)
flutter pub run build_runner build --delete-conflicting-outputs

# Check Flutter setup
flutter doctor
```

### Running the App

#### Development Mode
```powershell
# Run on connected device/emulator
flutter run

# Run with device selection
flutter devices
flutter run -d <device-id>

# Run with hot reload enabled (default)
flutter run
```

#### Build Release

**Android APK:**
```powershell
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (Google Play):**
```powershell
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```powershell
flutter build ios --release
```

### Development Commands

```powershell
# Clean build files
flutter clean

# Reinstall dependencies
flutter pub get

# Regenerate Hive adapters after model changes
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for auto-generation during development
flutter pub run build_runner watch

# Analyze code for issues
flutter analyze

# Format code
flutter format .

# Run tests (if any)
flutter test
```

### Useful Flutter Commands

```powershell
# Check Flutter and SDK version
flutter --version

# List connected devices
flutter devices

# List installed emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator-id>

# Check for dependency updates
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade
```

### Debugging

```powershell
# Run in debug mode with verbose logging
flutter run -v

# Run in profile mode (performance testing)
flutter run --profile

# Run in release mode
flutter run --release

# Clear app data during development
flutter run --clear-data
```

### Build Troubleshooting

```powershell
# Clean everything and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run

# Fix gradle issues (Android)
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Code Generation

```powershell
# Build once (delete conflicting files)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean
```

## 📝 Important Notes

1. **Always run build_runner after**:
   - Cloning the project
   - Modifying model files (category.dart, transaction.dart)
   - Pulling changes that affect models

2. **File Locations**:
   - APK: `build/app/outputs/flutter-apk/app-release.apk`
   - App Bundle: `build/app/outputs/bundle/release/app-release.aab`
   - Exported JSON: Device's Documents folder

3. **Common Issues**:
   - Missing .g.dart files → Run build_runner
   - Dependencies errors → Run `flutter pub get`
   - Build errors → Run `flutter clean` then rebuild

## 🔧 Development Workflow

1. **Make code changes**
2. **If models changed**: `flutter pub run build_runner build --delete-conflicting-outputs`
3. **Hot reload**: Press `r` in terminal or save file
4. **Hot restart**: Press `R` in terminal
5. **Test on device**
6. **Build release** when ready

## 📱 Testing on Devices

### Android
```powershell
# Enable USB debugging on device
# Connect via USB
flutter devices
flutter run
```

### iOS (Mac only)
```powershell
# Connect iPhone via USB
flutter devices
flutter run
```

### Emulators
```powershell
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator-id>

# Run app
flutter run
```

## 🎯 Quick Start (TL;DR)

```powershell
cd f:\MyProjects\TrackExp
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

That's it! Your app should now be running.

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Hive Documentation](https://docs.hivedb.dev)
- [FL Chart Documentation](https://github.com/imaNNeo/fl_chart)

## 🆘 Getting Help

If you encounter issues:
1. Check error messages carefully
2. Run `flutter doctor` to check setup
3. Clear and rebuild: `flutter clean && flutter pub get`
4. Regenerate adapters: `flutter pub run build_runner build --delete-conflicting-outputs`
5. Check Flutter version: `flutter --version` (needs 3.0+)
