import 'package:flutter/material.dart';

/// Finvix Design System
/// A comprehensive design system for consistent, modern UI/UX across the app

class FinvixColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1565C0);
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF29B6F6);
  
  // Neutral Colors
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceDim = Color(0xFFF5F5F5);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineLight = Color(0xFFF0F0F0);
  
  // Dark Mode Colors
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceDim = Color(0xFF1E1E1E);
  static const Color darkSurfaceBright = Color(0xFF2A2A2A);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFFBDBDBD);
  
  // Dark Mode Text
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
}

class FinvixSpacing {
  // Spacing Scale
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
  
  // Common combinations
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
}

class FinvixRadius {
  // Border Radius
  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 20.0;
  static const double circle = 100.0;
  
  // BorderRadius objects
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));
}

class FinvixShadows {
  // Elevation Shadows
  static const BoxShadow shadowXs = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x24000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );
  
  static const BoxShadow shadowXl = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 24,
    offset: Offset(0, 12),
  );
  
  // Shadow lists for elevation
  static const List<BoxShadow> elevationSm = [shadowSm];
  static const List<BoxShadow> elevationMd = [shadowMd];
  static const List<BoxShadow> elevationLg = [shadowLg];
  static const List<BoxShadow> elevationXl = [shadowXl];
  
  // Dark mode shadows
  static const BoxShadow shadowSmDark = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow shadowMdDark = BoxShadow(
    color: Color(0x52000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );
}

class FinvixTypography {
  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.3,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.4,
  );
  
  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.6,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.7,
  );
  
  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.6,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.7,
  );
  
  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.6,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.7,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.8,
  );
}

class FinvixAnimations {
  // Duration Constants
  static const Duration durationXs = Duration(milliseconds: 100);
  static const Duration durationSm = Duration(milliseconds: 150);
  static const Duration durationMd = Duration(milliseconds: 250);
  static const Duration durationLg = Duration(milliseconds: 350);
  static const Duration durationXl = Duration(milliseconds: 500);
  
  // Curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve smooth = Curves.fastOutSlowIn;
  static const Curve bouncy = Curves.bounceOut;
  
  // Common animations
  static const Interval fastInterval = Interval(0.0, 0.5);
  static const Interval slowInterval = Interval(0.5, 1.0);
}

/// Responsive helper for managing layout across different screen sizes
class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
  
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
  
  static double getMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return width;
    if (width < 1024) return 600;
    return 800;
  }
  
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) {
      return FinvixSpacing.paddingLg;
    }
    return FinvixSpacing.paddingXl;
  }
  
  static double getCardElevation(BuildContext context) {
    return isMobile(context) ? 1 : 2;
  }
}

/// Utility extension for easier shadow application
extension ShadowExtension on Widget {
  Widget withShadow({
    Color? color,
    double blurRadius = 8,
    Offset offset = const Offset(0, 4),
    double spreadRadius = 0,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color ?? Colors.black.withOpacity(0.15),
            blurRadius: blurRadius,
            offset: offset,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: this,
    );
  }
}

/// Utility extension for easier padding
extension PaddingExtension on Widget {
  Widget withPadding(EdgeInsets padding) => Padding(padding: padding, child: this);
  
  Widget withPaddingAll(double value) => Padding(
    padding: EdgeInsets.all(value),
    child: this,
  );
  
  Widget withPaddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );
}
