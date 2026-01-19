import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../constants/design_system.dart';
import '../providers/app_lock_provider.dart';
import '../services/app_lock_service.dart';

/// Lock screen with PIN, Pattern, and Biometric support
class LockScreen extends ConsumerStatefulWidget {
  final VoidCallback onUnlock;
  final bool isSetup; // true = setting up new lock, false = verifying
  final LockType? setupType; // lock type being set up

  const LockScreen({
    super.key,
    required this.onUnlock,
    this.isSetup = false,
    this.setupType,
  });

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  List<int> _pattern = [];
  bool _isPatternConfirming = false;
  String _errorMessage = '';
  bool _showBiometricButton = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: FinvixAnimations.durationMd,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: FinvixAnimations.smooth,
    );

    _fadeController.forward();

    // Auto-trigger biometric if available and not setup mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isSetup) {
        _checkBiometric();
      }
    });
  }

  void _checkBiometric() {
    final lockState = ref.read(appLockProvider);
    if (lockState.biometricEnabled && lockState.biometricAvailable) {
      setState(() => _showBiometricButton = true);
      _authenticateWithBiometric();
    }
  }

  Future<void> _authenticateWithBiometric() async {
    final notifier = ref.read(appLockProvider.notifier);
    final success = await notifier.verifyBiometric();
    if (success && mounted) {
      widget.onUnlock();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    _shakeController.forward(from: 0);
    HapticFeedback.heavyImpact();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _errorMessage = '');
      }
    });
  }

  void _clearError() {
    if (_errorMessage.isNotEmpty) {
      setState(() => _errorMessage = '');
    }
  }

  LockType get _currentLockType {
    if (widget.isSetup) {
      return widget.setupType ?? LockType.pin;
    }
    return ref.read(appLockProvider).lockType;
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(appLockProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? FinvixColors.darkSurface : FinvixColors.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              final shake = _shakeAnimation.value;
              final offset = shake * 10 * (shake % 2 == 0 ? 1 : -1);
              return Transform.translate(
                offset: Offset(offset * (1 - shake), 0),
                child: child,
              );
            },
            child: _buildLockContent(lockState, theme, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildLockContent(
      AppLockState lockState, ThemeData theme, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // App logo/icon
                  _buildHeader(theme, isDark),

                  const SizedBox(height: FinvixSpacing.xl),

                  // Title
                  Text(
                    widget.isSetup
                        ? (_isConfirming || _isPatternConfirming
                            ? 'Confirm your ${_getLockTypeName()}'
                            : 'Set up ${_getLockTypeName()}')
                        : 'Unlock Finvix',
                    style: FinvixTypography.headlineSmall.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: FinvixSpacing.sm),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: FinvixSpacing.lg),
                    child: Text(
                      widget.isSetup
                          ? 'Create a secure ${_getLockTypeName()} to protect your data'
                          : 'Enter your ${_getLockTypeName()} to continue',
                      style: FinvixTypography.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Error message
                  AnimatedContainer(
                    duration: FinvixAnimations.durationXs,
                    height: _errorMessage.isNotEmpty ? 40 : 0,
                    child: Center(
                      child: Text(
                        _errorMessage,
                        style: FinvixTypography.bodyMedium.copyWith(
                          color: FinvixColors.error,
                        ),
                      ),
                    ),
                  ),

                  // Lock input based on type
                  _buildLockInput(theme, isDark),

                  const SizedBox(height: FinvixSpacing.xl),

                  // Biometric button (if available and not setup)
                  if (_showBiometricButton && !widget.isSetup)
                    _buildBiometricButton(lockState, theme),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getLockTypeName() {
    switch (_currentLockType) {
      case LockType.pin:
        return 'PIN';
      case LockType.pattern:
        return 'pattern';
      case LockType.biometric:
        return 'biometric';
      case LockType.none:
        return '';
    }
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/logo.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildLockInput(ThemeData theme, bool isDark) {
    switch (_currentLockType) {
      case LockType.pin:
        return _buildPinInput(theme, isDark);
      case LockType.pattern:
        return _buildPatternInput(theme, isDark);
      case LockType.biometric:
        return _buildBiometricPrompt(theme);
      case LockType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPinInput(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // PIN dots
        _PinDots(
          length: _isConfirming ? _confirmPin.length : _pin.length,
          maxLength: 4,
          hasError: _errorMessage.isNotEmpty,
        ),

        const SizedBox(height: FinvixSpacing.xxxl),

        // Number pad
        _NumberPad(
          onNumberPressed: _onPinNumberPressed,
          onBackspace: _onPinBackspace,
          onBiometric: _showBiometricButton && !widget.isSetup
              ? _authenticateWithBiometric
              : null,
        ),
      ],
    );
  }

  void _onPinNumberPressed(int number) {
    _clearError();
    HapticFeedback.lightImpact();

    if (widget.isSetup) {
      if (_isConfirming) {
        if (_confirmPin.length < 4) {
          setState(() => _confirmPin += number.toString());

          if (_confirmPin.length == 4) {
            if (_confirmPin == _pin) {
              _setupPin();
            } else {
              _showError('PINs do not match');
              setState(() {
                _confirmPin = '';
                _isConfirming = false;
                _pin = '';
              });
            }
          }
        }
      } else {
        if (_pin.length < 4) {
          setState(() => _pin += number.toString());

          // Auto-proceed to confirm after 4 digits
          if (_pin.length == 4) {
            // Small delay before proceeding to confirmation
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && _pin.length == 4) {
                setState(() => _isConfirming = true);
              }
            });
          }
        }
      }
    } else {
      // Verification mode
      if (_pin.length < 4) {
        setState(() => _pin += number.toString());

        if (_pin.length == 4) {
          _verifyPin();
        }
      }
    }
  }

  void _onPinBackspace() {
    HapticFeedback.lightImpact();
    _clearError();

    if (widget.isSetup && _isConfirming) {
      if (_confirmPin.isNotEmpty) {
        setState(() =>
            _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1));
      } else {
        // Go back to entering first PIN
        setState(() {
          _isConfirming = false;
          _pin = '';
        });
      }
    } else {
      if (_pin.isNotEmpty) {
        setState(() => _pin = _pin.substring(0, _pin.length - 1));
      }
    }
  }

  Future<void> _setupPin() async {
    final notifier = ref.read(appLockProvider.notifier);
    final success = await notifier.setupPinLock(_pin);

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      widget.onUnlock();
    } else {
      _showError('Failed to set up PIN');
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    final notifier = ref.read(appLockProvider.notifier);
    final success = await notifier.verifyPin(_pin);

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      widget.onUnlock();
    } else {
      _showError('Incorrect PIN');
      setState(() => _pin = '');
    }
  }

  Widget _buildPatternInput(ThemeData theme, bool isDark) {
    return _PatternLock(
      key: ValueKey(_isPatternConfirming),
      onPatternComplete: _onPatternComplete,
      hasError: _errorMessage.isNotEmpty,
    );
  }

  void _onPatternComplete(List<int> pattern) {
    _clearError();
    HapticFeedback.lightImpact();

    if (pattern.length < 4) {
      _showError('Connect at least 4 dots');
      return;
    }

    if (widget.isSetup) {
      if (_isPatternConfirming) {
        // Compare new pattern with the first pattern stored in _pattern
        if (_listEquals(_pattern, pattern)) {
          _setupPattern();
        } else {
          _showError('Patterns do not match');
          setState(() {
            _pattern = [];
            _isPatternConfirming = false;
          });
        }
      } else {
        setState(() {
          _pattern = pattern;
          _isPatternConfirming = true;
        });
      }
    } else {
      _verifyPattern(pattern);
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _setupPattern() async {
    final notifier = ref.read(appLockProvider.notifier);
    final success = await notifier.setupPatternLock(_pattern);

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      widget.onUnlock();
    } else {
      _showError('Failed to set up pattern');
      setState(() {
        _pattern = [];
        _isPatternConfirming = false;
      });
    }
  }

  Future<void> _verifyPattern(List<int> pattern) async {
    final notifier = ref.read(appLockProvider.notifier);
    final success = await notifier.verifyPattern(pattern);

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      widget.onUnlock();
    } else {
      _showError('Incorrect pattern');
    }
  }

  Widget _buildBiometricPrompt(ThemeData theme) {
    return Column(
      children: [
        GestureDetector(
          onTap: _authenticateWithBiometric,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
              boxShadow: [FinvixShadows.shadowMd],
            ),
            child: Icon(
              Icons.fingerprint_rounded,
              size: 60,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: FinvixSpacing.lg),
        Text(
          'Tap to authenticate',
          style: FinvixTypography.bodyMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricButton(AppLockState lockState, ThemeData theme) {
    return TextButton.icon(
      onPressed: _authenticateWithBiometric,
      icon: Icon(
        lockState.availableBiometrics.any((b) => b == BiometricType.face)
            ? Icons.face_rounded
            : Icons.fingerprint_rounded,
        size: 24,
      ),
      label: Text('Use ${lockState.biometricDisplayName}'),
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.md,
        ),
      ),
    );
  }
}

/// PIN dots indicator
class _PinDots extends StatelessWidget {
  final int length;
  final int maxLength;
  final bool hasError;

  const _PinDots({
    required this.length,
    required this.maxLength,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final isFilled = index < length;

        return AnimatedContainer(
          duration: FinvixAnimations.durationXs,
          margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.sm),
          width: isFilled ? 16 : 14,
          height: isFilled ? 16 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? (hasError ? FinvixColors.error : theme.colorScheme.primary)
                : Colors.transparent,
            border: Border.all(
              color: hasError
                  ? FinvixColors.error
                  : (isFilled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline),
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

/// Number pad for PIN input
class _NumberPad extends StatelessWidget {
  final void Function(int) onNumberPressed;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;

  const _NumberPad({
    required this.onNumberPressed,
    required this.onBackspace,
    this.onBiometric,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.xxxl),
      child: Column(
        children: [
          for (int row = 0; row < 4; row++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildRow(context, row),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRow(BuildContext context, int row) {
    if (row < 3) {
      return [
        for (int col = 0; col < 3; col++)
          _NumberButton(
            number: row * 3 + col + 1,
            onPressed: onNumberPressed,
          ),
      ];
    } else {
      // Last row: biometric, 0, backspace
      return [
        onBiometric != null
            ? _ActionButton(
                icon: Icons.fingerprint_rounded,
                onPressed: onBiometric!,
              )
            : const SizedBox(width: 72, height: 72),
        _NumberButton(
          number: 0,
          onPressed: onNumberPressed,
        ),
        _ActionButton(
          icon: Icons.backspace_outlined,
          onPressed: onBackspace,
        ),
      ];
    }
  }
}

/// Single number button
class _NumberButton extends StatelessWidget {
  final int number;
  final void Function(int) onPressed;

  const _NumberButton({
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(FinvixSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(number),
          borderRadius: BorderRadius.circular(36),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: FinvixTypography.headlineLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Action button (biometric, backspace)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(FinvixSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(36),
          child: Container(
            width: 72,
            height: 72,
            child: Center(
              child: Icon(
                icon,
                size: 28,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pattern lock grid
class _PatternLock extends StatefulWidget {
  final void Function(List<int>) onPatternComplete;
  final bool hasError;

  const _PatternLock({
    super.key,
    required this.onPatternComplete,
    this.hasError = false,
  });

  @override
  State<_PatternLock> createState() => _PatternLockState();
}

class _PatternLockState extends State<_PatternLock> {
  final List<int> _selectedDots = [];
  Offset? _currentPosition;
  bool _isDragging = false;

  final GlobalKey _gridKey = GlobalKey();
  final List<GlobalKey> _dotKeys = List.generate(9, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size.width * 0.7;

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Container(
        key: _gridKey,
        width: size,
        height: size,
        child: CustomPaint(
          painter: _PatternPainter(
            selectedDots: _selectedDots,
            currentPosition: _currentPosition,
            dotPositions: _getDotPositions(size),
            primaryColor: widget.hasError
                ? FinvixColors.error
                : theme.colorScheme.primary,
            secondaryColor: theme.colorScheme.outline,
            isDragging: _isDragging,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final isSelected = _selectedDots.contains(index);

              return Center(
                key: _dotKeys[index],
                child: AnimatedContainer(
                  duration: FinvixAnimations.durationXs,
                  width: isSelected ? 24 : 16,
                  height: isSelected ? 24 : 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? (widget.hasError
                            ? FinvixColors.error
                            : theme.colorScheme.primary)
                        : theme.colorScheme.surfaceContainerHighest,
                    border: Border.all(
                      color: isSelected
                          ? (widget.hasError
                              ? FinvixColors.error
                              : theme.colorScheme.primary)
                          : theme.colorScheme.outline,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (widget.hasError
                                      ? FinvixColors.error
                                      : theme.colorScheme.primary)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Offset> _getDotPositions(double size) {
    final cellSize = size / 3;
    final positions = <Offset>[];

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        positions.add(Offset(
          (col + 0.5) * cellSize,
          (row + 0.5) * cellSize,
        ));
      }
    }

    return positions;
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _selectedDots.clear();
      _isDragging = true;
    });
    _checkDotHit(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPosition = details.localPosition;
    });
    _checkDotHit(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _currentPosition = null;
    });

    if (_selectedDots.isNotEmpty) {
      widget.onPatternComplete(List.from(_selectedDots));

      // Clear after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _selectedDots.clear());
        }
      });
    }
  }

  void _checkDotHit(Offset position) {
    final renderBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size.width;
    final cellSize = size / 3;
    final hitRadius = cellSize * 0.4;

    final positions = _getDotPositions(size);

    for (int i = 0; i < positions.length; i++) {
      final dotPosition = positions[i];
      final distance = (position - dotPosition).distance;

      if (distance < hitRadius && !_selectedDots.contains(i)) {
        setState(() => _selectedDots.add(i));
        HapticFeedback.selectionClick();
        break;
      }
    }
  }
}

/// Custom painter for pattern lines
class _PatternPainter extends CustomPainter {
  final List<int> selectedDots;
  final Offset? currentPosition;
  final List<Offset> dotPositions;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDragging;

  _PatternPainter({
    required this.selectedDots,
    required this.currentPosition,
    required this.dotPositions,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw lines between selected dots
    for (int i = 0; i < selectedDots.length - 1; i++) {
      final start = dotPositions[selectedDots[i]];
      final end = dotPositions[selectedDots[i + 1]];
      canvas.drawLine(start, end, paint);
    }

    // Draw line to current position while dragging
    if (isDragging && selectedDots.isNotEmpty && currentPosition != null) {
      final lastDot = dotPositions[selectedDots.last];
      canvas.drawLine(lastDot, currentPosition!,
          paint..color = primaryColor.withValues(alpha: 0.5));
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) {
    return selectedDots != oldDelegate.selectedDots ||
        currentPosition != oldDelegate.currentPosition ||
        isDragging != oldDelegate.isDragging;
  }
}
