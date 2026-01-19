import 'package:flutter/material.dart';

/// Finvix Design System
/// A comprehensive design system for a calm, premium, modern finance app
/// Style: Modern minimal with soft shadows, rounded corners, premium feel

class FinvixColors {
  // ============================================================================
  // PRIMARY PALETTE - Calm, Premium Blues
  // ============================================================================
  static const Color primary = Color(0xFF4F46E5);        // Indigo - calmer, more premium
  static const Color primaryLight = Color(0xFF818CF8);   // Soft violet
  static const Color primaryDark = Color(0xFF3730A3);    // Deep indigo
  static const Color primarySoft = Color(0xFFEEF2FF);    // Very soft indigo tint
  
  // Accent for highlights
  static const Color accent = Color(0xFF06B6D4);         // Cyan for accents
  static const Color accentSoft = Color(0xFFECFEFF);     // Soft cyan tint
  
  // ============================================================================
  // SEMANTIC COLORS - Softer, More Refined
  // ============================================================================
  static const Color success = Color(0xFF10B981);        // Emerald green
  static const Color successLight = Color(0xFFD1FAE5);   // Soft emerald
  static const Color successDark = Color(0xFF059669);    // Deep emerald
  
  static const Color warning = Color(0xFFF59E0B);        // Amber
  static const Color warningLight = Color(0xFFFEF3C7);   // Soft amber
  static const Color warningDark = Color(0xFFD97706);    // Deep amber
  
  static const Color error = Color(0xFFEF4444);          // Red
  static const Color errorLight = Color(0xFFFEE2E2);     // Soft red
  static const Color errorDark = Color(0xFFDC2626);      // Deep red
  
  static const Color info = Color(0xFF3B82F6);           // Blue
  static const Color infoLight = Color(0xFFDBEAFE);      // Soft blue
  
  // ============================================================================
  // LIGHT MODE SURFACES - Clean, Airy Feel
  // ============================================================================
  static const Color surface = Color(0xFFF8FAFC);        // Slightly cool white
  static const Color surfaceDim = Color(0xFFF1F5F9);     // Soft gray
  static const Color surfaceBright = Color(0xFFFFFFFF);  // Pure white
  static const Color surfaceElevated = Color(0xFFFFFFFF); // Cards, elevated content
  
  // ============================================================================
  // BORDERS & OUTLINES - Subtle, Refined
  // ============================================================================
  static const Color outline = Color(0xFFE2E8F0);        // Soft slate border
  static const Color outlineLight = Color(0xFFF1F5F9);   // Very subtle border
  static const Color outlineFocus = Color(0xFF818CF8);   // Focus ring color
  
  // ============================================================================
  // DARK MODE SURFACES - Rich, Deep Feel
  // ============================================================================
  static const Color darkSurface = Color(0xFF0F172A);    // Deep slate
  static const Color darkSurfaceDim = Color(0xFF1E293B); // Elevated dark
  static const Color darkSurfaceBright = Color(0xFF334155); // Cards in dark mode
  static const Color darkSurfaceElevated = Color(0xFF1E293B);
  
  // ============================================================================
  // TEXT COLORS - Optimal Readability
  // ============================================================================
  static const Color textPrimary = Color(0xFF0F172A);    // Deep slate for headings
  static const Color textSecondary = Color(0xFF475569);  // Medium slate
  static const Color textTertiary = Color(0xFF94A3B8);   // Muted slate
  static const Color textDisabled = Color(0xFFCBD5E1);   // Disabled text
  
  // Dark Mode Text
  static const Color darkTextPrimary = Color(0xFFF8FAFC);    // Almost white
  static const Color darkTextSecondary = Color(0xFF94A3B8);  // Muted
  static const Color darkTextTertiary = Color(0xFF64748B);   // More muted
  
  // ============================================================================
  // FINANCE-SPECIFIC COLORS
  // ============================================================================
  static const Color income = Color(0xFF10B981);         // Emerald for income
  static const Color incomeLight = Color(0xFFD1FAE5);    // Soft emerald
  static const Color expense = Color(0xFFF43F5E);        // Rose for expense
  static const Color expenseLight = Color(0xFFFFE4E6);   // Soft rose
  static const Color savings = Color(0xFF3B82F6);        // Blue for savings
  static const Color savingsLight = Color(0xFFDBEAFE);   // Soft blue
  
  // ============================================================================
  // GRADIENT PRESETS
  // ============================================================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient savingsGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Dark mode gradients
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class FinvixSpacing {
  // ============================================================================
  // SPACING SCALE - 4px Base Unit (More Refined)
  // ============================================================================
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
  static const double massive = 64.0;
  
  // ============================================================================
  // PADDING PRESETS
  // ============================================================================
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);
  
  // Horizontal padding
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);
  
  // Vertical padding
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);
  
  // Screen padding - for page content
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: lg, vertical: xl);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: lg);
  
  // Card internal padding
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);
  
  // ============================================================================
  // GAP SIZES (for Row/Column spacing)
  // ============================================================================
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxl);
}

class FinvixRadius {
  // ============================================================================
  // BORDER RADIUS - Softer, More Modern
  // ============================================================================
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double full = 9999.0;  // Pill shape
  
  // ============================================================================
  // BORDER RADIUS PRESETS
  // ============================================================================
  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusXxxl = BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));
  
  // Top-only radius (for bottom sheets, modals)
  static const BorderRadius radiusTopLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );
  static const BorderRadius radiusTopXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
  static const BorderRadius radiusTopXxl = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );
  
  // Bottom-only radius (for app bars)
  static const BorderRadius radiusBottomLg = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );
}

class FinvixShadows {
  // ============================================================================
  // SOFT SHADOWS - Premium, Subtle Feel
  // ============================================================================
  
  // Extra small - for subtle elevation
  static const BoxShadow shadowXs = BoxShadow(
    color: Color(0x08000000),
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 1),
  );
  
  // Small - for cards, buttons
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 8,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );
  
  // Medium - for elevated cards
  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 16,
    spreadRadius: -2,
    offset: Offset(0, 4),
  );
  
  // Large - for modals, dropdowns
  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 24,
    spreadRadius: -4,
    offset: Offset(0, 8),
  );
  
  // Extra large - for popovers, dialogs
  static const BoxShadow shadowXl = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 32,
    spreadRadius: -4,
    offset: Offset(0, 12),
  );
  
  // ============================================================================
  // COLORED SHADOWS (for cards with color)
  // ============================================================================
  static BoxShadow coloredShadow(Color color, {double opacity = 0.25}) => BoxShadow(
    color: color.withOpacity(opacity),
    blurRadius: 20,
    spreadRadius: -4,
    offset: const Offset(0, 8),
  );
  
  // ============================================================================
  // SHADOW LISTS (for easy application)
  // ============================================================================
  static const List<BoxShadow> elevationNone = [];
  
  static const List<BoxShadow> elevationXs = [shadowXs];
  
  static const List<BoxShadow> elevationSm = [
    shadowXs,
    shadowSm,
  ];
  
  static const List<BoxShadow> elevationMd = [
    shadowSm,
    shadowMd,
  ];
  
  static const List<BoxShadow> elevationLg = [
    shadowMd,
    shadowLg,
  ];
  
  static const List<BoxShadow> elevationXl = [
    shadowLg,
    shadowXl,
  ];
  
  // ============================================================================
  // DARK MODE SHADOWS - Softer for dark backgrounds
  // ============================================================================
  static const BoxShadow shadowSmDark = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 8,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow shadowMdDark = BoxShadow(
    color: Color(0x50000000),
    blurRadius: 16,
    spreadRadius: -2,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow shadowLgDark = BoxShadow(
    color: Color(0x60000000),
    blurRadius: 24,
    spreadRadius: -4,
    offset: Offset(0, 8),
  );
  
  static const List<BoxShadow> elevationSmDark = [shadowSmDark];
  static const List<BoxShadow> elevationMdDark = [shadowMdDark];
  static const List<BoxShadow> elevationLgDark = [shadowLgDark];
  
  // ============================================================================
  // INNER SHADOWS (for pressed states)
  // ============================================================================
  static const BoxShadow innerShadow = BoxShadow(
    color: Color(0x10000000),
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );
}

class FinvixTypography {
  // ============================================================================
  // FONT FAMILY
  // ============================================================================
  static const String fontFamily = 'Inter';  // Modern, clean sans-serif
  
  // ============================================================================
  // DISPLAY STYLES - Large, Bold Headlines
  // ============================================================================
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  // ============================================================================
  // HEADLINE STYLES - Section Headers
  // ============================================================================
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.35,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.45,
  );
  
  // ============================================================================
  // TITLE STYLES - Card Titles, List Items
  // ============================================================================
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.45,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  // ============================================================================
  // BODY STYLES - Main Content Text
  // ============================================================================
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.55,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.6,
  );
  
  // ============================================================================
  // LABEL STYLES - Buttons, Chips, Tags
  // ============================================================================
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.5,
  );
  
  // ============================================================================
  // SPECIAL STYLES - Numbers, Currency
  // ============================================================================
  static const TextStyle currencyLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  static const TextStyle currencyMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  static const TextStyle currencySmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.4,
  );
}

class FinvixAnimations {
  // ============================================================================
  // DURATION CONSTANTS - Smooth, Natural Feel
  // ============================================================================
  static const Duration instant = Duration(milliseconds: 50);
  static const Duration durationXs = Duration(milliseconds: 100);
  static const Duration durationSm = Duration(milliseconds: 150);
  static const Duration durationMd = Duration(milliseconds: 200);
  static const Duration durationLg = Duration(milliseconds: 300);
  static const Duration durationXl = Duration(milliseconds: 400);
  static const Duration durationXxl = Duration(milliseconds: 500);
  static const Duration durationSlow = Duration(milliseconds: 700);
  
  // ============================================================================
  // CURVES - Premium, Smooth Motion
  // ============================================================================
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  
  // Smooth, natural feeling curves
  static const Curve smooth = Curves.easeOutCubic;
  static const Curve smoothIn = Curves.easeInCubic;
  static const Curve smoothInOut = Curves.easeInOutCubic;
  
  // Premium, polished curves
  static const Curve premium = Curves.easeOutQuart;
  static const Curve premiumIn = Curves.easeInQuart;
  static const Curve premiumInOut = Curves.easeInOutQuart;
  
  // Bouncy, playful curves
  static const Curve bouncy = Curves.elasticOut;
  static const Curve bouncySubtle = Curves.easeOutBack;
  
  // Deceleration (for entering elements)
  static const Curve decelerate = Curves.decelerate;
  
  // ============================================================================
  // SPRING ANIMATIONS (for physics-based motion)
  // ============================================================================
  static const SpringDescription gentleSpring = SpringDescription(
    mass: 1,
    stiffness: 100,
    damping: 15,
  );
  
  static const SpringDescription bouncySpring = SpringDescription(
    mass: 1,
    stiffness: 180,
    damping: 12,
  );
  
  // ============================================================================
  // STAGGERED ANIMATION INTERVALS
  // ============================================================================
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const Duration staggerDelayLong = Duration(milliseconds: 80);
  
  // Page transition curves
  static const Curve pageTransition = Curves.easeInOutCubic;
  
  // ============================================================================
  // COMMON ANIMATION CONFIGS
  // ============================================================================
  static const Interval fadeIn = Interval(0.0, 0.6, curve: Curves.easeOut);
  static const Interval slideIn = Interval(0.2, 1.0, curve: Curves.easeOutCubic);
  static const Interval scaleIn = Interval(0.0, 0.8, curve: Curves.easeOutBack);
}

// ============================================================================
// CHART STYLING
// ============================================================================
class FinvixChartStyles {
  // Pie chart colors - vibrant but harmonious
  static const List<Color> pieChartPalette = [
    Color(0xFF6366F1),  // Indigo
    Color(0xFF8B5CF6),  // Violet
    Color(0xFFEC4899),  // Pink
    Color(0xFFF43F5E),  // Rose
    Color(0xFFF97316),  // Orange
    Color(0xFFFBBF24),  // Amber
    Color(0xFF84CC16),  // Lime
    Color(0xFF22C55E),  // Green
    Color(0xFF14B8A6),  // Teal
    Color(0xFF06B6D4),  // Cyan
    Color(0xFF3B82F6),  // Blue
    Color(0xFFA855F7),  // Purple
  ];
  
  // Bar chart colors
  static const Color barIncome = Color(0xFF10B981);
  static const Color barExpense = Color(0xFFF43F5E);
  static const Color barSavings = Color(0xFF3B82F6);
  
  // Chart grid colors
  static const Color gridLine = Color(0xFFE2E8F0);
  static const Color gridLineDark = Color(0xFF334155);
  
  // Chart tooltip styling
  static const BorderRadius tooltipRadius = BorderRadius.all(Radius.circular(8));
  static const Color tooltipBackground = Color(0xFF1E293B);
  static const Color tooltipBackgroundLight = Color(0xFFFFFFFF);
}

/// Responsive helper for managing layout across different screen sizes
class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;
  
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint && 
      MediaQuery.of(context).size.width < tabletBreakpoint;
  
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;
  
  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;
  
  static double getMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return width;
    if (width < tabletBreakpoint) return 560;
    if (width < desktopBreakpoint) return 720;
    return 840;
  }
  
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: FinvixSpacing.lg);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: FinvixSpacing.xxl);
    }
    return const EdgeInsets.symmetric(horizontal: FinvixSpacing.xxxl);
  }
  
  static double getCardElevation(BuildContext context) {
    return isMobile(context) ? 0 : 1;
  }
  
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }
  
  static double getFontScale(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet(context)) return 1.05;
    return 1.1;
  }
}

// ============================================================================
// COMPONENT STYLES - Reusable Widget Configurations
// ============================================================================
class FinvixComponentStyles {
  // ============================================================================
  // BUTTON STYLES
  // ============================================================================
  static ButtonStyle primaryButton(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: FinvixColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: FinvixSpacing.xxl,
        vertical: FinvixSpacing.lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: FinvixRadius.radiusMd,
      ),
      textStyle: FinvixTypography.labelLarge,
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withOpacity(0.05);
        }
        return null;
      }),
    );
  }
  
  static ButtonStyle secondaryButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton.styleFrom(
      foregroundColor: FinvixColors.primary,
      side: BorderSide(
        color: isDark ? FinvixColors.primaryLight : FinvixColors.primary,
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: FinvixSpacing.xl,
        vertical: FinvixSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: FinvixRadius.radiusMd,
      ),
      textStyle: FinvixTypography.labelLarge,
    );
  }
  
  static ButtonStyle textButton(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: FinvixColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: FinvixSpacing.lg,
        vertical: FinvixSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: FinvixRadius.radiusSm,
      ),
      textStyle: FinvixTypography.labelLarge,
    );
  }
  
  // ============================================================================
  // CARD DECORATION
  // ============================================================================
  static BoxDecoration cardDecoration(BuildContext context, {bool elevated = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? FinvixColors.darkSurfaceDim : FinvixColors.surfaceBright,
      borderRadius: FinvixRadius.radiusLg,
      border: Border.all(
        color: isDark 
          ? Colors.white.withOpacity(0.06) 
          : FinvixColors.outline.withOpacity(0.5),
        width: 1,
      ),
      boxShadow: elevated
        ? (isDark ? FinvixShadows.elevationSmDark : FinvixShadows.elevationSm)
        : FinvixShadows.elevationNone,
    );
  }
  
  static BoxDecoration elevatedCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? FinvixColors.darkSurfaceDim : FinvixColors.surfaceBright,
      borderRadius: FinvixRadius.radiusLg,
      boxShadow: isDark ? FinvixShadows.elevationMdDark : FinvixShadows.elevationMd,
    );
  }
  
  // ============================================================================
  // INPUT DECORATION
  // ============================================================================
  static InputDecoration inputDecoration(BuildContext context, {
    String? label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark 
        ? FinvixColors.darkSurfaceBright.withOpacity(0.5) 
        : FinvixColors.surfaceDim,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: FinvixSpacing.lg,
        vertical: FinvixSpacing.lg,
      ),
      border: OutlineInputBorder(
        borderRadius: FinvixRadius.radiusMd,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: FinvixRadius.radiusMd,
        borderSide: BorderSide(
          color: isDark 
            ? Colors.white.withOpacity(0.08) 
            : FinvixColors.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: FinvixRadius.radiusMd,
        borderSide: BorderSide(
          color: FinvixColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: FinvixRadius.radiusMd,
        borderSide: BorderSide(
          color: FinvixColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: FinvixRadius.radiusMd,
        borderSide: BorderSide(
          color: FinvixColors.error,
          width: 2,
        ),
      ),
    );
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
