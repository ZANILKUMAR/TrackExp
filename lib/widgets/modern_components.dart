/// Common Reusable Components with Modern Design
/// Place these in appropriate widget files for DRY principles

import 'package:flutter/material.dart';
import '../constants/design_system.dart';

// ============================================================================
// CARD COMPONENTS
// ============================================================================

/// Modern Card with smooth animations and premium feel
class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;
  final Gradient? gradient;
  final Border? border;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation = 0,
    this.borderRadius,
    this.onTap,
    this.enableHover = true,
    this.gradient,
    this.border,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: FinvixAnimations.durationSm,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: FinvixAnimations.smooth,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(_) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = widget.backgroundColor ?? 
      (isDarkMode ? FinvixColors.darkSurfaceDim : FinvixColors.surfaceBright);
    
    final shadows = widget.elevation > 0
      ? (isDarkMode ? FinvixShadows.elevationSmDark : FinvixShadows.elevationSm)
      : <BoxShadow>[];
    
    final borderColor = isDarkMode 
      ? Colors.white.withOpacity(0.08)
      : FinvixColors.outline.withOpacity(0.5);

    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: FinvixAnimations.durationSm,
                curve: FinvixAnimations.smooth,
                decoration: BoxDecoration(
                  color: widget.gradient == null ? bgColor : null,
                  gradient: widget.gradient,
                  borderRadius: widget.borderRadius ?? FinvixRadius.radiusLg,
                  border: widget.border ?? Border.all(
                    color: _isHovered && widget.onTap != null 
                      ? FinvixColors.primary.withOpacity(0.3)
                      : borderColor,
                    width: 1,
                  ),
                  boxShadow: [
                    ...shadows,
                    if (_isHovered && widget.onTap != null)
                      BoxShadow(
                        color: FinvixColors.primary.withOpacity(0.08),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? FinvixRadius.radiusLg,
            child: Padding(
              padding: widget.padding ?? FinvixSpacing.cardPadding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BUTTON COMPONENTS
// ============================================================================

/// Primary Button with modern styling and loading state
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final EdgeInsets? padding;
  final double? width;
  final bool compact;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.padding,
    this.width,
    this.compact = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: FinvixAnimations.durationXs,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: FinvixAnimations.smooth),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _controller.forward(),
      onTapUp: isDisabled ? null : (_) => _controller.reverse(),
      onTapCancel: isDisabled ? null : () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.width,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              padding: widget.padding ?? EdgeInsets.symmetric(
                horizontal: widget.compact ? FinvixSpacing.lg : FinvixSpacing.xxl,
                vertical: widget.compact ? FinvixSpacing.md : FinvixSpacing.lg,
              ),
            ),
            child: AnimatedSwitcher(
              duration: FinvixAnimations.durationSm,
              child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20),
                        const SizedBox(width: FinvixSpacing.sm),
                      ],
                      Text(widget.label),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary Button with outline styling
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final EdgeInsets? padding;
  final bool compact;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.padding,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: padding ?? EdgeInsets.symmetric(
          horizontal: compact ? FinvixSpacing.lg : FinvixSpacing.xl,
          vertical: compact ? FinvixSpacing.sm : FinvixSpacing.md,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: FinvixSpacing.sm),
          ],
          Text(label),
        ],
      ),
    );
  }
}

// ============================================================================
// FORM COMPONENTS
// ============================================================================

/// Modern Text Input Field with label and validation
class ModernTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscure;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool autofocus;
  final void Function(String)? onChanged;

  const ModernTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscure = false,
    this.suffixIcon,
    this.prefixIcon,
    this.autofocus = false,
    this.onChanged,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: FinvixAnimations.durationSm,
      vsync: this,
    );
    _focusNode.addListener(_onFocusChange);
    
    if (widget.controller.text.isNotEmpty) {
      _controller.value = 1;
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_focusNode.hasFocus || widget.controller.text.isNotEmpty) {
        _controller.forward();
      } else if (widget.controller.text.isEmpty) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: FinvixAnimations.durationSm,
          style: FinvixTypography.labelLarge.copyWith(
            color: _isFocused 
              ? FinvixColors.primary 
              : (isDark ? FinvixColors.darkTextSecondary : FinvixColors.textSecondary),
            fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(widget.label),
        ),
        const SizedBox(height: FinvixSpacing.sm),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          obscureText: widget.obscure,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          style: FinvixTypography.bodyLarge.copyWith(
            color: isDark ? FinvixColors.darkTextPrimary : FinvixColors.textPrimary,
          ),
          cursorColor: FinvixColors.primary,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SECTION COMPONENTS
// ============================================================================

/// Section with title and content - with smooth animations
class ModernSection extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onMoreAction;
  final String? moreLabel;
  final IconData? moreIcon;

  const ModernSection({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.onMoreAction,
    this.moreLabel,
    this.moreIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: FinvixSpacing.lg,
        vertical: FinvixSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: FinvixTypography.headlineSmall.copyWith(
                  color: isDark ? FinvixColors.darkTextPrimary : FinvixColors.textPrimary,
                ),
              ),
              if (onMoreAction != null)
                TextButton(
                  onPressed: onMoreAction,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FinvixSpacing.md,
                      vertical: FinvixSpacing.xs,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        moreLabel ?? 'View all',
                        style: FinvixTypography.labelMedium.copyWith(
                          color: FinvixColors.primary,
                        ),
                      ),
                      const SizedBox(width: FinvixSpacing.xs),
                      Icon(
                        moreIcon ?? Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: FinvixColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: FinvixSpacing.lg),
          child,
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE COMPONENTS
// ============================================================================

/// Modern Empty State with icon, title, and action
class ModernEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final double iconSize;

  const ModernEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark 
      ? FinvixColors.primaryLight.withOpacity(0.1)
      : FinvixColors.primarySoft;
    final defaultIconColor = isDark 
      ? FinvixColors.primaryLight 
      : FinvixColors.primary;
    
    return Center(
      child: Padding(
        padding: FinvixSpacing.paddingXxl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(FinvixSpacing.xxl),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: FinvixRadius.radiusXxl,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor ?? defaultIconColor,
              ),
            ),
            const SizedBox(height: FinvixSpacing.xxl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: FinvixTypography.headlineMedium.copyWith(
                color: isDark ? FinvixColors.darkTextPrimary : FinvixColors.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: FinvixSpacing.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: FinvixTypography.bodyMedium.copyWith(
                  color: isDark ? FinvixColors.darkTextSecondary : FinvixColors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: FinvixSpacing.xxl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CHIP COMPONENTS
// ============================================================================

/// Modern Chip with selection support and smooth animation
class ModernChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? selectedColor;

  const ModernChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.icon,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = selectedColor ?? FinvixColors.primary;
    
    return AnimatedContainer(
      duration: FinvixAnimations.durationSm,
      curve: FinvixAnimations.smooth,
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onPressed(),
        avatar: icon != null 
          ? Icon(
              icon, 
              size: 18,
              color: isSelected 
                ? activeColor 
                : (isDark ? FinvixColors.darkTextSecondary : FinvixColors.textSecondary),
            ) 
          : null,
        backgroundColor: isDark 
          ? FinvixColors.darkSurfaceBright 
          : FinvixColors.surfaceDim,
        selectedColor: activeColor.withOpacity(isDark ? 0.2 : 0.12),
        checkmarkColor: activeColor,
        labelStyle: FinvixTypography.labelMedium.copyWith(
          color: isSelected
            ? activeColor
            : (isDark ? FinvixColors.darkTextSecondary : FinvixColors.textSecondary),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusSm,
          side: BorderSide(
            color: isSelected 
              ? activeColor.withOpacity(0.5) 
              : Colors.transparent,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.sm,
          vertical: FinvixSpacing.xs,
        ),
      ),
    );
  }
}

// ============================================================================
// DIVIDER COMPONENTS
// ============================================================================

/// Modern section divider with optional label
class ModernDivider extends StatelessWidget {
  final EdgeInsets? padding;
  final String? label;

  const ModernDivider({super.key, this.padding, this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark 
      ? Colors.white.withOpacity(0.08) 
      : FinvixColors.outline.withOpacity(0.5);
    
    if (label != null) {
      return Padding(
        padding: padding ?? const EdgeInsets.symmetric(
          vertical: FinvixSpacing.lg,
        ),
        child: Row(
          children: [
            Expanded(child: Divider(color: dividerColor, thickness: 1, height: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.lg),
              child: Text(
                label!,
                style: FinvixTypography.labelSmall.copyWith(
                  color: isDark ? FinvixColors.darkTextTertiary : FinvixColors.textTertiary,
                ),
              ),
            ),
            Expanded(child: Divider(color: dividerColor, thickness: 1, height: 1)),
          ],
        ),
      );
    }
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(
        vertical: FinvixSpacing.lg,
      ),
      child: Divider(
        color: dividerColor,
        thickness: 1,
        height: 1,
      ),
    );
  }
}

// ============================================================================
// LIST TILE COMPONENTS
// ============================================================================

/// Modern List Tile with better spacing and animations
class ModernListTile extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;

  const ModernListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.contentPadding,
  });

  @override
  State<ModernListTile> createState() => _ModernListTileState();
}

class _ModernListTileState extends State<ModernListTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: FinvixAnimations.durationXs,
        curve: FinvixAnimations.smooth,
        margin: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.xs,
        ),
        padding: widget.contentPadding ?? const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.md,
        ),
        decoration: BoxDecoration(
          color: _isPressed 
            ? (isDark ? Colors.white.withOpacity(0.05) : FinvixColors.surfaceDim)
            : (widget.backgroundColor ?? Colors.transparent),
          borderRadius: FinvixRadius.radiusMd,
        ),
        child: Row(
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: FinvixSpacing.lg),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: FinvixTypography.titleMedium.copyWith(
                      color: isDark ? FinvixColors.darkTextPrimary : FinvixColors.textPrimary,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: FinvixSpacing.xxs),
                    Text(
                      widget.subtitle!,
                      style: FinvixTypography.bodySmall.copyWith(
                        color: isDark ? FinvixColors.darkTextSecondary : FinvixColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.trailing != null) ...[
              const SizedBox(width: FinvixSpacing.md),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ANIMATION WRAPPERS
// ============================================================================

/// Simple fade-in animation wrapper
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = FinvixAnimations.durationLg,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

/// Slide and fade-in animation wrapper
class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset beginOffset;
  final Curve curve;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.duration = FinvixAnimations.durationLg,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.1),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _slideAnimation = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}

/// Scale and fade-in animation wrapper
class ScaleFadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double initialScale;
  final Curve curve;

  const ScaleFadeAnimation({
    super.key,
    required this.child,
    this.duration = FinvixAnimations.durationLg,
    this.delay = Duration.zero,
    this.initialScale = 0.95,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScaleFadeAnimation> createState() => _ScaleFadeAnimationState();
}

class _ScaleFadeAnimationState extends State<ScaleFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(begin: widget.initialScale, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _fadeAnimation = Tween<double>(begin: 0, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}

/// Staggered list animation helper
class StaggeredListAnimation extends StatelessWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;
  final Axis direction;

  const StaggeredListAnimation({
    super.key,
    required this.children,
    this.staggerDelay = FinvixAnimations.staggerDelay,
    this.itemDuration = FinvixAnimations.durationLg,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildAnimatedChildren(),
        )
      : Row(
          children: _buildAnimatedChildren(),
        );
  }

  List<Widget> _buildAnimatedChildren() {
    return children.asMap().entries.map((entry) {
      return SlideInAnimation(
        delay: staggerDelay * entry.key,
        duration: itemDuration,
        child: entry.value,
      );
    }).toList();
  }
}

// ============================================================================
// LOADING COMPONENTS
// ============================================================================

/// Modern shimmer loading placeholder
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? FinvixRadius.radiusSm,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: isDark
                ? [
                    FinvixColors.darkSurfaceBright,
                    FinvixColors.darkSurfaceBright.withOpacity(0.5),
                    FinvixColors.darkSurfaceBright,
                  ]
                : [
                    FinvixColors.surfaceDim,
                    FinvixColors.surfaceDim.withOpacity(0.5),
                    FinvixColors.surfaceDim,
                  ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// STATUS BADGE
// ============================================================================

/// Modern status badge for showing categories, tags, etc.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool small;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? FinvixSpacing.sm : FinvixSpacing.md,
        vertical: small ? FinvixSpacing.xxs : FinvixSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: FinvixRadius.radiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: small ? 12 : 14,
              color: color,
            ),
            SizedBox(width: small ? 4 : 6),
          ],
          Text(
            label,
            style: (small ? FinvixTypography.caption : FinvixTypography.labelSmall).copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
