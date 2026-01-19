import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/database_service.dart';
import 'services/theme_service.dart';
import 'services/app_lock_service.dart';
import 'providers/theme_provider.dart';
import 'providers/app_lock_provider.dart';
import 'constants/design_system.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/transactions_list_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await DatabaseService.init();
  
  // Initialize theme service
  await ThemeService.init();
  
  // Initialize app lock service
  await AppLockService.instance.init();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Finvix',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainScreen(),
    );
  }
  
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme - calm, premium indigo
      colorScheme: ColorScheme.light(
        primary: FinvixColors.primary,
        onPrimary: Colors.white,
        primaryContainer: FinvixColors.primarySoft,
        onPrimaryContainer: FinvixColors.primaryDark,
        secondary: FinvixColors.accent,
        onSecondary: Colors.white,
        secondaryContainer: FinvixColors.accentSoft,
        onSecondaryContainer: FinvixColors.accent,
        tertiary: FinvixColors.success,
        surface: FinvixColors.surface,
        onSurface: FinvixColors.textPrimary,
        onSurfaceVariant: FinvixColors.textSecondary,
        outline: FinvixColors.outline,
        outlineVariant: FinvixColors.outlineLight,
        error: FinvixColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: FinvixColors.surface,
      
      // Page transitions - smooth
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // AppBar theme - clean, minimal
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: FinvixColors.surface,
        foregroundColor: FinvixColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: FinvixColors.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      
      // Card theme - soft shadows, rounded
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        color: FinvixColors.surfaceBright,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
          side: BorderSide(
            color: FinvixColors.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Input decoration theme - modern, clean
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FinvixColors.surfaceDim,
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
            color: FinvixColors.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusMd,
          borderSide: const BorderSide(
            color: FinvixColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusMd,
          borderSide: const BorderSide(
            color: FinvixColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusMd,
          borderSide: const BorderSide(
            color: FinvixColors.error,
            width: 2,
          ),
        ),
        labelStyle: FinvixTypography.bodyMedium.copyWith(
          color: FinvixColors.textSecondary,
        ),
        hintStyle: FinvixTypography.bodyMedium.copyWith(
          color: FinvixColors.textTertiary,
        ),
      ),
      
      // Button themes - modern, premium feel
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: FinvixColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: FinvixColors.outline,
          disabledForegroundColor: FinvixColors.textTertiary,
          padding: const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.xxl,
            vertical: FinvixSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusMd,
          ),
          textStyle: FinvixTypography.labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FinvixColors.primary,
          side: const BorderSide(
            color: FinvixColors.primary,
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
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FinvixColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.lg,
            vertical: FinvixSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusSm,
          ),
          textStyle: FinvixTypography.labelLarge,
        ),
      ),
      
      // FloatingActionButton theme - modern, subtle shadow
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        highlightElevation: 4,
        backgroundColor: FinvixColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
        ),
        extendedTextStyle: FinvixTypography.labelLarge.copyWith(
          color: Colors.white,
        ),
      ),
      
      // Navigation bar - clean, modern
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: FinvixColors.surfaceBright,
        surfaceTintColor: Colors.transparent,
        indicatorColor: FinvixColors.primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FinvixTypography.labelSmall.copyWith(
              color: FinvixColors.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return FinvixTypography.labelSmall.copyWith(
            color: FinvixColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: FinvixColors.primary,
              size: 24,
            );
          }
          return const IconThemeData(
            color: FinvixColors.textSecondary,
            size: 24,
          );
        }),
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: FinvixColors.surfaceDim,
        selectedColor: FinvixColors.primarySoft,
        disabledColor: FinvixColors.surfaceDim,
        labelStyle: FinvixTypography.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.md,
          vertical: FinvixSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusSm,
        ),
        side: BorderSide.none,
      ),
      
      // Typography
      textTheme: _buildTextTheme(FinvixColors.textPrimary),
      
      // Dialog theme - modern, rounded
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: FinvixColors.surfaceBright,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusXl,
        ),
        titleTextStyle: FinvixTypography.headlineMedium.copyWith(
          color: FinvixColors.textPrimary,
        ),
        contentTextStyle: FinvixTypography.bodyMedium.copyWith(
          color: FinvixColors.textSecondary,
        ),
      ),
      
      // Bottom sheet theme - smooth, rounded
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        backgroundColor: FinvixColors.surfaceBright,
        surfaceTintColor: Colors.transparent,
        modalElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusTopXxl,
        ),
        showDragHandle: true,
        dragHandleColor: FinvixColors.outline,
        dragHandleSize: Size(40, 4),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FinvixColors.textPrimary,
        contentTextStyle: FinvixTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusMd,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: FinvixColors.outline.withOpacity(0.5),
        thickness: 1,
        space: FinvixSpacing.lg,
      ),
      
      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusMd,
        ),
        titleTextStyle: FinvixTypography.titleMedium.copyWith(
          color: FinvixColors.textPrimary,
        ),
        subtitleTextStyle: FinvixTypography.bodySmall.copyWith(
          color: FinvixColors.textSecondary,
        ),
      ),
      
      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return FinvixColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FinvixColors.primary;
          }
          return FinvixColors.outline;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FinvixColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(
          color: FinvixColors.outline,
          width: 1.5,
        ),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: FinvixColors.textSecondary,
        size: 24,
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: FinvixColors.primary,
        linearTrackColor: FinvixColors.primarySoft,
        circularTrackColor: FinvixColors.primarySoft,
      ),
    );
  }
  
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme - rich, deep dark mode
      colorScheme: ColorScheme.dark(
        primary: FinvixColors.primaryLight,
        onPrimary: FinvixColors.darkSurface,
        primaryContainer: FinvixColors.primaryDark.withOpacity(0.3),
        onPrimaryContainer: FinvixColors.primaryLight,
        secondary: FinvixColors.accent,
        onSecondary: FinvixColors.darkSurface,
        tertiary: FinvixColors.success,
        surface: FinvixColors.darkSurface,
        onSurface: FinvixColors.darkTextPrimary,
        onSurfaceVariant: FinvixColors.darkTextSecondary,
        outline: Colors.white.withOpacity(0.12),
        outlineVariant: Colors.white.withOpacity(0.06),
        error: FinvixColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: FinvixColors.darkSurface,
      
      // Page transitions - smooth
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // AppBar theme - clean dark
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: FinvixColors.darkSurface,
        foregroundColor: FinvixColors.darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: FinvixColors.darkTextPrimary,
          letterSpacing: -0.3,
        ),
      ),
      
      // Card theme - subtle border, no shadow
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        color: FinvixColors.darkSurfaceDim,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
          side: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Input decoration theme - dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FinvixColors.darkSurfaceBright.withOpacity(0.5),
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
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusMd,
          borderSide: const BorderSide(
            color: FinvixColors.primaryLight,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusMd,
          borderSide: const BorderSide(
            color: FinvixColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusMd,
          borderSide: const BorderSide(
            color: FinvixColors.error,
            width: 2,
          ),
        ),
        labelStyle: FinvixTypography.bodyMedium.copyWith(
          color: FinvixColors.darkTextSecondary,
        ),
        hintStyle: FinvixTypography.bodyMedium.copyWith(
          color: FinvixColors.darkTextTertiary,
        ),
      ),
      
      // Button themes - dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: FinvixColors.primaryLight,
          foregroundColor: FinvixColors.darkSurface,
          disabledBackgroundColor: Colors.white.withOpacity(0.12),
          disabledForegroundColor: FinvixColors.darkTextTertiary,
          padding: const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.xxl,
            vertical: FinvixSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusMd,
          ),
          textStyle: FinvixTypography.labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FinvixColors.primaryLight,
          side: const BorderSide(
            color: FinvixColors.primaryLight,
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
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FinvixColors.primaryLight,
          padding: const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.lg,
            vertical: FinvixSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusSm,
          ),
          textStyle: FinvixTypography.labelLarge,
        ),
      ),
      
      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 2,
        backgroundColor: FinvixColors.primaryLight,
        foregroundColor: FinvixColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
        ),
        extendedTextStyle: FinvixTypography.labelLarge.copyWith(
          color: FinvixColors.darkSurface,
        ),
      ),
      
      // Navigation bar - dark mode
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: FinvixColors.darkSurfaceDim,
        surfaceTintColor: Colors.transparent,
        indicatorColor: FinvixColors.primaryLight.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FinvixTypography.labelSmall.copyWith(
              color: FinvixColors.primaryLight,
              fontWeight: FontWeight.w600,
            );
          }
          return FinvixTypography.labelSmall.copyWith(
            color: FinvixColors.darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: FinvixColors.primaryLight,
              size: 24,
            );
          }
          return const IconThemeData(
            color: FinvixColors.darkTextSecondary,
            size: 24,
          );
        }),
      ),
      
      // Chip theme - dark mode
      chipTheme: ChipThemeData(
        backgroundColor: FinvixColors.darkSurfaceBright,
        selectedColor: FinvixColors.primaryLight.withOpacity(0.2),
        disabledColor: FinvixColors.darkSurfaceBright,
        labelStyle: FinvixTypography.labelMedium.copyWith(
          color: FinvixColors.darkTextPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.md,
          vertical: FinvixSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusSm,
        ),
        side: BorderSide.none,
      ),
      
      // Typography
      textTheme: _buildTextTheme(FinvixColors.darkTextPrimary),
      
      // Dialog theme - dark mode
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: FinvixColors.darkSurfaceDim,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusXl,
        ),
        titleTextStyle: FinvixTypography.headlineMedium.copyWith(
          color: FinvixColors.darkTextPrimary,
        ),
        contentTextStyle: FinvixTypography.bodyMedium.copyWith(
          color: FinvixColors.darkTextSecondary,
        ),
      ),
      
      // Bottom sheet theme - dark mode
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: FinvixColors.darkSurfaceDim,
        surfaceTintColor: Colors.transparent,
        modalElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusTopXxl,
        ),
        showDragHandle: true,
        dragHandleColor: Colors.white.withOpacity(0.2),
        dragHandleSize: const Size(40, 4),
      ),
      
      // Snackbar theme - dark mode
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FinvixColors.darkSurfaceBright,
        contentTextStyle: FinvixTypography.bodyMedium.copyWith(
          color: FinvixColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusMd,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      
      // Divider theme - dark mode
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.08),
        thickness: 1,
        space: FinvixSpacing.lg,
      ),
      
      // List tile theme - dark mode
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusMd,
        ),
        titleTextStyle: FinvixTypography.titleMedium.copyWith(
          color: FinvixColors.darkTextPrimary,
        ),
        subtitleTextStyle: FinvixTypography.bodySmall.copyWith(
          color: FinvixColors.darkTextSecondary,
        ),
      ),
      
      // Switch theme - dark mode
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FinvixColors.darkSurface;
          }
          return FinvixColors.darkTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FinvixColors.primaryLight;
          }
          return Colors.white.withOpacity(0.2);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      
      // Checkbox theme - dark mode
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FinvixColors.primaryLight;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(FinvixColors.darkSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      
      // Icon theme - dark mode
      iconTheme: const IconThemeData(
        color: FinvixColors.darkTextSecondary,
        size: 24,
      ),
      
      // Progress indicator theme - dark mode
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: FinvixColors.primaryLight,
        linearTrackColor: FinvixColors.primaryLight.withOpacity(0.2),
        circularTrackColor: FinvixColors.primaryLight.withOpacity(0.2),
      ),
    );
  }
  
  TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: FinvixTypography.displayLarge.copyWith(color: textColor),
      displayMedium: FinvixTypography.displayMedium.copyWith(color: textColor),
      displaySmall: FinvixTypography.displaySmall.copyWith(color: textColor),
      headlineLarge: FinvixTypography.headlineLarge.copyWith(color: textColor),
      headlineMedium: FinvixTypography.headlineMedium.copyWith(color: textColor),
      headlineSmall: FinvixTypography.headlineSmall.copyWith(color: textColor),
      titleLarge: FinvixTypography.titleLarge.copyWith(color: textColor),
      titleMedium: FinvixTypography.titleMedium.copyWith(color: textColor),
      titleSmall: FinvixTypography.titleSmall.copyWith(color: textColor),
      bodyLarge: FinvixTypography.bodyLarge.copyWith(color: textColor),
      bodyMedium: FinvixTypography.bodyMedium.copyWith(color: textColor),
      bodySmall: FinvixTypography.bodySmall.copyWith(color: textColor),
      labelLarge: FinvixTypography.labelLarge.copyWith(color: textColor),
      labelMedium: FinvixTypography.labelMedium.copyWith(color: textColor),
      labelSmall: FinvixTypography.labelSmall.copyWith(color: textColor),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsListScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize lock provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appLockProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lockNotifier = ref.read(appLockProvider.notifier);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background
        lockNotifier.onAppPaused();
        break;
      case AppLifecycleState.resumed:
        // App coming to foreground
        lockNotifier.onAppResumed();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onUnlock() {
    // State is managed by appLockProvider, just trigger rebuild
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(appLockProvider);
    
    // Show lock screen if app is locked
    if (lockState.isInitialized && lockState.isLocked && lockState.isEnabled) {
      return LockScreen(
        onUnlock: _onUnlock,
      );
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
                
                // If transaction was added from dashboard, switch to transactions tab
                if (result == true && _selectedIndex == 0) {
                  setState(() {
                    _selectedIndex = 1;
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
