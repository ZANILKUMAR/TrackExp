import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../services/app_lock_service.dart';

/// State for app lock
class AppLockState {
  final bool isInitialized;
  final bool isLocked;
  final bool isEnabled;
  final LockType lockType;
  final int autoLockMinutes;
  final bool biometricEnabled;
  final bool biometricAvailable;
  final List<BiometricType> availableBiometrics;

  const AppLockState({
    this.isInitialized = false,
    this.isLocked = true,
    this.isEnabled = false,
    this.lockType = LockType.none,
    this.autoLockMinutes = 0,
    this.biometricEnabled = false,
    this.biometricAvailable = false,
    this.availableBiometrics = const [],
  });

  AppLockState copyWith({
    bool? isInitialized,
    bool? isLocked,
    bool? isEnabled,
    LockType? lockType,
    int? autoLockMinutes,
    bool? biometricEnabled,
    bool? biometricAvailable,
    List<BiometricType>? availableBiometrics,
  }) {
    return AppLockState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLocked: isLocked ?? this.isLocked,
      isEnabled: isEnabled ?? this.isEnabled,
      lockType: lockType ?? this.lockType,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
    );
  }

  /// Get display name for biometric type
  String get biometricDisplayName {
    if (availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'Iris';
    }
    return 'Biometric';
  }
}

/// Provider for app lock state
class AppLockNotifier extends StateNotifier<AppLockState> {
  final AppLockService _service;

  AppLockNotifier(this._service) : super(const AppLockState());

  /// Initialize the lock system
  Future<void> init() async {
    await _service.init();
    
    final biometricAvailable = await _service.isBiometricAvailable();
    final availableBiometrics = await _service.getAvailableBiometrics();
    final config = _service.config;

    state = state.copyWith(
      isInitialized: true,
      isLocked: _service.isLocked,
      isEnabled: config.isEnabled,
      lockType: config.lockType,
      autoLockMinutes: config.autoLockMinutes,
      biometricEnabled: config.biometricEnabled,
      biometricAvailable: biometricAvailable,
      availableBiometrics: availableBiometrics,
    );
  }

  /// Set up PIN lock
  Future<bool> setupPinLock(String pin) async {
    final success = await _service.setupPinLock(pin);
    if (success) {
      state = state.copyWith(
        isLocked: false,
        isEnabled: true,
        lockType: LockType.pin,
      );
    }
    return success;
  }

  /// Verify PIN
  Future<bool> verifyPin(String pin) async {
    final success = await _service.verifyPin(pin);
    if (success) {
      state = state.copyWith(isLocked: false);
    }
    return success;
  }

  /// Set up pattern lock
  Future<bool> setupPatternLock(List<int> pattern) async {
    final success = await _service.setupPatternLock(pattern);
    if (success) {
      state = state.copyWith(
        isLocked: false,
        isEnabled: true,
        lockType: LockType.pattern,
      );
    }
    return success;
  }

  /// Verify pattern
  Future<bool> verifyPattern(List<int> pattern) async {
    final success = await _service.verifyPattern(pattern);
    if (success) {
      state = state.copyWith(isLocked: false);
    }
    return success;
  }

  /// Set up biometric lock
  Future<bool> setupBiometricLock() async {
    final success = await _service.setupBiometricLock();
    if (success) {
      state = state.copyWith(
        isLocked: false,
        isEnabled: true,
        lockType: LockType.biometric,
        biometricEnabled: true,
      );
    }
    return success;
  }

  /// Verify biometric
  Future<bool> verifyBiometric() async {
    final success = await _service.verifyBiometric();
    if (success) {
      state = state.copyWith(isLocked: false);
    }
    return success;
  }

  /// Enable biometric as secondary auth
  Future<bool> enableBiometricSecondary() async {
    final success = await _service.enableBiometricSecondary();
    if (success) {
      state = state.copyWith(biometricEnabled: true);
    }
    return success;
  }

  /// Disable biometric
  Future<void> disableBiometric() async {
    await _service.disableBiometric();
    state = state.copyWith(biometricEnabled: false);
  }

  /// Set auto-lock timeout
  Future<void> setAutoLockMinutes(int minutes) async {
    await _service.setAutoLockMinutes(minutes);
    state = state.copyWith(autoLockMinutes: minutes);
  }

  /// Disable lock
  Future<void> disableLock() async {
    await _service.disableLock();
    state = state.copyWith(
      isLocked: false,
      isEnabled: false,
      lockType: LockType.none,
      biometricEnabled: false,
    );
  }

  /// Lock the app
  void lockApp() {
    _service.lockApp();
    state = state.copyWith(isLocked: _service.isLocked);
  }

  /// Called when app pauses
  Future<void> onAppPaused() async {
    await _service.onAppPaused();
  }

  /// Called when app resumes
  Future<void> onAppResumed() async {
    await _service.onAppResumed();
    state = state.copyWith(isLocked: _service.isLocked);
  }

  /// Change PIN
  Future<bool> changePin(String currentPin, String newPin) async {
    return await _service.changePin(currentPin, newPin);
  }

  /// Change pattern
  Future<bool> changePattern(List<int> currentPattern, List<int> newPattern) async {
    return await _service.changePattern(currentPattern, newPattern);
  }
}

/// Provider for app lock
final appLockProvider = StateNotifierProvider<AppLockNotifier, AppLockState>((ref) {
  return AppLockNotifier(AppLockService.instance);
});

/// Simple provider to check if app is locked
final isAppLockedProvider = Provider<bool>((ref) {
  final lockState = ref.watch(appLockProvider);
  return lockState.isLocked && lockState.isEnabled;
});
