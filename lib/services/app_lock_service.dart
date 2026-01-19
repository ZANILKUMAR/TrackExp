import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Check if running on web
bool get _isWeb => kIsWeb;

/// Types of app lock
enum LockType {
  none,
  pin,
  pattern,
  biometric,
}

/// App lock configuration
class LockConfig {
  final bool isEnabled;
  final LockType lockType;
  final int autoLockMinutes; // 0 = immediate, -1 = never
  final bool biometricEnabled;

  const LockConfig({
    this.isEnabled = false,
    this.lockType = LockType.none,
    this.autoLockMinutes = 0,
    this.biometricEnabled = false,
  });

  LockConfig copyWith({
    bool? isEnabled,
    LockType? lockType,
    int? autoLockMinutes,
    bool? biometricEnabled,
  }) {
    return LockConfig(
      isEnabled: isEnabled ?? this.isEnabled,
      lockType: lockType ?? this.lockType,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'isEnabled': isEnabled,
    'lockType': lockType.index,
    'autoLockMinutes': autoLockMinutes,
    'biometricEnabled': biometricEnabled,
  };

  factory LockConfig.fromJson(Map<String, dynamic> json) {
    return LockConfig(
      isEnabled: json['isEnabled'] ?? false,
      lockType: LockType.values[json['lockType'] ?? 0],
      autoLockMinutes: json['autoLockMinutes'] ?? 0,
      biometricEnabled: json['biometricEnabled'] ?? false,
    );
  }
}

/// Secure app lock service - fully offline, encrypted storage
class AppLockService {
  static AppLockService? _instance;
  static AppLockService get instance => _instance ??= AppLockService._();
  
  AppLockService._();

  // Secure storage with encryption
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Local auth for biometrics
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Storage keys
  static const String _configKey = 'app_lock_config';
  static const String _pinHashKey = 'app_lock_pin_hash';
  static const String _patternHashKey = 'app_lock_pattern_hash';
  static const String _lastActiveKey = 'app_lock_last_active';

  // In-memory cache
  LockConfig? _cachedConfig;
  DateTime? _lastActiveTime;
  bool _isLocked = true;

  /// Initialize the service
  Future<void> init() async {
    await _loadConfig();
    _lastActiveTime = await _getLastActiveTime();
    
    // Check if app should be locked based on auto-lock settings
    if (_cachedConfig?.isEnabled == true) {
      _isLocked = await _shouldAutoLock();
    } else {
      _isLocked = false;
    }
  }

  /// Get current lock configuration
  LockConfig get config => _cachedConfig ?? const LockConfig();

  /// Check if app is currently locked
  bool get isLocked => _isLocked && config.isEnabled;

  /// Check if lock is enabled
  bool get isLockEnabled => config.isEnabled;

  /// Get current lock type
  LockType get lockType => config.lockType;

  /// Load configuration from secure storage
  Future<void> _loadConfig() async {
    try {
      final configJson = await _secureStorage.read(key: _configKey);
      if (configJson != null) {
        _cachedConfig = LockConfig.fromJson(jsonDecode(configJson));
      } else {
        _cachedConfig = const LockConfig();
      }
    } catch (e) {
      debugPrint('Error loading lock config: $e');
      _cachedConfig = const LockConfig();
    }
  }

  /// Save configuration to secure storage
  Future<void> _saveConfig(LockConfig config) async {
    try {
      await _secureStorage.write(
        key: _configKey,
        value: jsonEncode(config.toJson()),
      );
      _cachedConfig = config;
    } catch (e) {
      debugPrint('Error saving lock config: $e');
    }
  }

  /// Hash a string using SHA-256 for secure storage
  String _hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Set up PIN lock
  Future<bool> setupPinLock(String pin) async {
    if (pin.length != 4) {
      return false;
    }

    try {
      // Hash the PIN before storing
      final hashedPin = _hashString(pin);
      await _secureStorage.write(key: _pinHashKey, value: hashedPin);
      
      // Clear pattern hash if exists
      await _secureStorage.delete(key: _patternHashKey);
      
      await _saveConfig(config.copyWith(
        isEnabled: true,
        lockType: LockType.pin,
        biometricEnabled: false, // Disable biometric when switching to PIN
      ));
      
      _isLocked = false;
      await _updateLastActiveTime();
      return true;
    } catch (e) {
      debugPrint('Error setting up PIN: $e');
      return false;
    }
  }

  /// Verify PIN
  Future<bool> verifyPin(String pin) async {
    try {
      final storedHash = await _secureStorage.read(key: _pinHashKey);
      if (storedHash == null) return false;

      final inputHash = _hashString(pin);
      final isValid = storedHash == inputHash;
      
      if (isValid) {
        _isLocked = false;
        await _updateLastActiveTime();
      }
      
      return isValid;
    } catch (e) {
      debugPrint('Error verifying PIN: $e');
      return false;
    }
  }

  /// Set up pattern lock
  Future<bool> setupPatternLock(List<int> pattern) async {
    if (pattern.length < 4) {
      return false;
    }

    try {
      // Convert pattern to string and hash
      final patternString = pattern.join('-');
      final hashedPattern = _hashString(patternString);
      await _secureStorage.write(key: _patternHashKey, value: hashedPattern);
      
      // Clear PIN hash if exists
      await _secureStorage.delete(key: _pinHashKey);
      
      await _saveConfig(config.copyWith(
        isEnabled: true,
        lockType: LockType.pattern,
        biometricEnabled: false, // Disable biometric when switching to pattern
      ));
      
      _isLocked = false;
      await _updateLastActiveTime();
      return true;
    } catch (e) {
      debugPrint('Error setting up pattern: $e');
      return false;
    }
  }

  /// Verify pattern
  Future<bool> verifyPattern(List<int> pattern) async {
    try {
      final storedHash = await _secureStorage.read(key: _patternHashKey);
      if (storedHash == null) return false;

      final patternString = pattern.join('-');
      final inputHash = _hashString(patternString);
      final isValid = storedHash == inputHash;
      
      if (isValid) {
        _isLocked = false;
        await _updateLastActiveTime();
      }
      
      return isValid;
    } catch (e) {
      debugPrint('Error verifying pattern: $e');
      return false;
    }
  }

  /// Check if biometric is available
  Future<bool> isBiometricAvailable() async {
    // Biometric not supported on web
    if (_isWeb) return false;
    
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canAuthenticate && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    // Biometric not supported on web
    if (_isWeb) return [];
    
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Set up biometric lock
  Future<bool> setupBiometricLock() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;

      // Test biometric authentication
      final authenticated = await _authenticateWithBiometric();
      if (!authenticated) return false;

      // Clear PIN and pattern hashes if exist
      await _secureStorage.delete(key: _pinHashKey);
      await _secureStorage.delete(key: _patternHashKey);

      await _saveConfig(config.copyWith(
        isEnabled: true,
        lockType: LockType.biometric,
        biometricEnabled: true,
      ));
      
      _isLocked = false;
      await _updateLastActiveTime();
      return true;
    } catch (e) {
      debugPrint('Error setting up biometric: $e');
      return false;
    }
  }

  /// Verify with biometric
  Future<bool> verifyBiometric() async {
    try {
      final authenticated = await _authenticateWithBiometric();
      
      if (authenticated) {
        _isLocked = false;
        await _updateLastActiveTime();
      }
      
      return authenticated;
    } catch (e) {
      debugPrint('Error verifying biometric: $e');
      return false;
    }
  }

  /// Internal biometric authentication
  Future<bool> _authenticateWithBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Finvix',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  /// Enable biometric as secondary auth (with PIN/Pattern)
  Future<bool> enableBiometricSecondary() async {
    if (config.lockType == LockType.none) return false;
    
    try {
      final authenticated = await _authenticateWithBiometric();
      if (!authenticated) return false;

      await _saveConfig(config.copyWith(biometricEnabled: true));
      return true;
    } catch (e) {
      debugPrint('Error enabling biometric: $e');
      return false;
    }
  }

  /// Disable biometric
  Future<void> disableBiometric() async {
    await _saveConfig(config.copyWith(biometricEnabled: false));
  }

  /// Update auto-lock timeout
  Future<void> setAutoLockMinutes(int minutes) async {
    await _saveConfig(config.copyWith(autoLockMinutes: minutes));
  }

  /// Disable lock completely
  Future<void> disableLock() async {
    try {
      // Clear all lock data
      await _secureStorage.delete(key: _pinHashKey);
      await _secureStorage.delete(key: _patternHashKey);
      
      await _saveConfig(const LockConfig());
      _isLocked = false;
    } catch (e) {
      debugPrint('Error disabling lock: $e');
    }
  }

  /// Update last active time
  Future<void> _updateLastActiveTime() async {
    _lastActiveTime = DateTime.now();
    await _secureStorage.write(
      key: _lastActiveKey,
      value: _lastActiveTime!.toIso8601String(),
    );
  }

  /// Get last active time
  Future<DateTime?> _getLastActiveTime() async {
    try {
      final timeString = await _secureStorage.read(key: _lastActiveKey);
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
    } catch (e) {
      debugPrint('Error getting last active time: $e');
    }
    return null;
  }

  /// Check if app should auto-lock based on time
  Future<bool> _shouldAutoLock() async {
    if (!config.isEnabled) return false;
    if (config.autoLockMinutes == -1) return false; // Never auto-lock
    if (config.autoLockMinutes == 0) return true; // Always lock on start
    
    if (_lastActiveTime == null) return true;
    
    final timeSinceActive = DateTime.now().difference(_lastActiveTime!);
    return timeSinceActive.inMinutes >= config.autoLockMinutes;
  }

  /// Called when app goes to background
  Future<void> onAppPaused() async {
    await _updateLastActiveTime();
  }

  /// Called when app comes to foreground
  Future<void> onAppResumed() async {
    if (config.isEnabled) {
      _isLocked = await _shouldAutoLock();
    }
  }

  /// Lock the app manually
  void lockApp() {
    if (config.isEnabled) {
      _isLocked = true;
    }
  }

  /// Unlock the app (called after successful verification)
  Future<void> unlock() async {
    _isLocked = false;
    await _updateLastActiveTime();
  }

  /// Change PIN
  Future<bool> changePin(String currentPin, String newPin) async {
    final isValid = await verifyPin(currentPin);
    if (!isValid) return false;
    
    return await setupPinLock(newPin);
  }

  /// Change pattern
  Future<bool> changePattern(List<int> currentPattern, List<int> newPattern) async {
    final isValid = await verifyPattern(currentPattern);
    if (!isValid) return false;
    
    return await setupPatternLock(newPattern);
  }
}
