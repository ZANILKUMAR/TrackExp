/// Common Reusable Components with Modern Design
/// Place these in appropriate widget files for DRY principles

import 'package:flutter/material.dart';
import '../constants/design_system.dart';

// ============================================================================
// CARD COMPONENTS
// ============================================================================

/// Modern Card with shadow and animation support
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation = 1,
    this.borderRadius,
    this.onTap,
    this.enableHover = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor ?? 
            (isDarkMode ? FinvixColors.darkSurfaceDim : FinvixColors.surfaceBright),
          borderRadius: borderRadius ?? FinvixRadius.radiusLg,
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? Colors.black : Colors.black).withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? FinvixRadius.radiusLg,
          child: Padding(
            padding: padding ?? FinvixSpacing.paddingLg,
            child: child,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BUTTON COMPONENTS
// ============================================================================

/// Primary Button with modern styling
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final EdgeInsets? padding;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.padding,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.xl,
            vertical: FinvixSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusLg,
          ),
        ),
      ),
    );
  }
}

/// Secondary Button with outline styling
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final EdgeInsets? padding;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
        ),
      ),
    );
  }
}

// ============================================================================
// FORM COMPONENTS
// ============================================================================

/// Modern Text Input Field with label and validation
class ModernTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscure;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FinvixTypography.labelLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: FinvixSpacing.sm),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: FinvixSpacing.lg,
              vertical: FinvixSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: FinvixRadius.radiusLg,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SECTION COMPONENTS
// ============================================================================

/// Section with title and content
class ModernSection extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onMoreAction;

  const ModernSection({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.onMoreAction,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (onMoreAction != null)
                TextButton.icon(
                  onPressed: onMoreAction,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('More'),
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

  const ModernEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: FinvixSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: FinvixSpacing.paddingXl,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: FinvixRadius.radiusXl,
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: FinvixSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: FinvixTypography.headlineMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: FinvixSpacing.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: FinvixTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: FinvixSpacing.xl),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
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

/// Modern Chip with selection support
class ModernChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;

  const ModernChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      avatar: icon != null ? Icon(icon) : null,
      backgroundColor: backgroundColor ?? 
        (isSelected 
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface),
      labelStyle: FinvixTypography.labelMedium.copyWith(
        color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: FinvixRadius.radiusLg,
      ),
    );
  }
}

// ============================================================================
// DIVIDER COMPONENTS
// ============================================================================

/// Modern section divider
class ModernDivider extends StatelessWidget {
  final EdgeInsets? padding;

  const ModernDivider({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(
        vertical: FinvixSpacing.lg,
      ),
      child: Divider(
        color: Theme.of(context).dividerColor,
        thickness: 0.5,
        height: 0,
      ),
    );
  }
}

// ============================================================================
// LIST TILE COMPONENTS
// ============================================================================

/// Modern List Tile with better spacing
class ModernListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const ModernListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: FinvixSpacing.lg,
        vertical: FinvixSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: FinvixRadius.radiusLg,
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: FinvixTypography.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: FinvixTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.md,
          vertical: FinvixSpacing.sm,
        ),
      ),
    );
  }
}

// ============================================================================
// ANIMATION WRAPPER
// ============================================================================

/// Simple fade-in animation wrapper
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
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
    _controller.forward();
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

/// Scale and fade-in animation wrapper
class ScaleFadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double initialScale;

  const ScaleFadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.initialScale = 0.8,
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
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
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
