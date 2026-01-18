import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/database_service.dart';
import 'services/theme_service.dart';
import 'providers/theme_provider.dart';
import 'constants/design_system.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/transactions_list_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await DatabaseService.init();
  
  // Initialize theme service
  await ThemeService.init();
  
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
      colorScheme: ColorScheme.fromSeed(
        seedColor: FinvixColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: FinvixColors.surface,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: FinvixColors.surfaceBright,
        foregroundColor: FinvixColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(FinvixRadius.lg),
            bottomRight: Radius.circular(FinvixRadius.lg),
          ),
        ),
      ),
      
      // Card theme with smooth shadows
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FinvixColors.surfaceDim,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusLg,
          borderSide: const BorderSide(color: FinvixColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusLg,
          borderSide: const BorderSide(color: FinvixColors.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusLg,
          borderSide: const BorderSide(
            color: FinvixColors.primary,
            width: 2,
          ),
        ),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.xl,
            vertical: FinvixSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusLg,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.lg,
            vertical: FinvixSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusLg,
          ),
        ),
      ),
      
      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusXl,
        ),
      ),
      
      // Typography
      textTheme: _buildTextTheme(FinvixColors.textPrimary),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusXl,
        ),
        backgroundColor: FinvixColors.surfaceBright,
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(FinvixRadius.xl),
            topRight: Radius.circular(FinvixRadius.xl),
          ),
        ),
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: FinvixColors.outline,
        thickness: 0.5,
        space: FinvixSpacing.lg,
      ),
    );
  }
  
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: FinvixColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: FinvixColors.darkSurface,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: FinvixColors.darkSurfaceDim,
        foregroundColor: FinvixColors.darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(FinvixRadius.lg),
            bottomRight: Radius.circular(FinvixRadius.lg),
          ),
        ),
      ),
      
      // Card theme with smooth shadows
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusLg,
        ),
        color: FinvixColors.darkSurfaceDim,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FinvixColors.darkSurfaceBright,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FinvixSpacing.lg,
          vertical: FinvixSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusLg,
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusLg,
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: FinvixRadius.radiusLg,
          borderSide: const BorderSide(
            color: FinvixColors.primary,
            width: 2,
          ),
        ),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: FinvixSpacing.xl,
            vertical: FinvixSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: FinvixRadius.radiusLg,
          ),
        ),
      ),
      
      // Typography
      textTheme: _buildTextTheme(FinvixColors.darkTextPrimary),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: FinvixRadius.radiusXl,
        ),
        backgroundColor: FinvixColors.darkSurfaceDim,
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 8,
        backgroundColor: FinvixColors.darkSurfaceDim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(FinvixRadius.xl),
            topRight: Radius.circular(FinvixRadius.xl),
          ),
        ),
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.1),
        thickness: 0.5,
        space: FinvixSpacing.lg,
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
