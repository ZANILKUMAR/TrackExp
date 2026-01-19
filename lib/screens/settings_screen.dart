import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/export_import_service.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/app_lock_provider.dart';
import '../services/app_lock_service.dart';
import '../constants/design_system.dart';
import 'category_management_screen.dart';
import 'group_management_screen.dart';
import 'lock_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: FinvixTypography.headlineMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: FinvixSpacing.lg),
        children: [
          // Theme Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.lg),
            child: Text(
              'Appearance',
              style: FinvixTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: FinvixSpacing.md),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: FinvixRadius.radiusLg,
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                width: 0.5,
              ),
            ),
            child: ListTile(
              leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text(
                'Dark Mode',
                style: FinvixTypography.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).toggleTheme(value);
                },
              ),
            ),
          ),
          const SizedBox(height: FinvixSpacing.xxxl),

          // Security Section
          _buildSecuritySection(context, ref),
          const SizedBox(height: FinvixSpacing.xxxl),

          // Management Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.lg),
            child: Text(
              'Management',
              style: FinvixTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: FinvixSpacing.md),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: FinvixRadius.radiusLg,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(
                    'Manage Categories',
                    style: FinvixTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryManagementScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: FinvixSpacing.md),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: FinvixRadius.radiusLg,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(
                    'Manage Groups',
                    style: FinvixTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Organize expenses by groups',
                    style: FinvixTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GroupManagementScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: FinvixSpacing.xxxl),

          // Data Management Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.lg),
            child: Text(
              'Data Management',
              style: FinvixTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: FinvixSpacing.md),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: FinvixRadius.radiusLg,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.blue),
                  title: Text(
                    'Export Data',
                    style: FinvixTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Save as JSON, CSV, or Excel',
                    style: FinvixTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () => _exportData(context, ref),
                ),
              ),
              const SizedBox(height: FinvixSpacing.md),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: FinvixRadius.radiusLg,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.download, color: Colors.green),
                  title: Text(
                    'Import Data',
                    style: FinvixTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Restore from JSON, CSV, or Excel',
                    style: FinvixTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () => _importData(context, ref),
                ),
              ),
            ],
          ),
          const SizedBox(height: FinvixSpacing.xxxl),

          // About Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.lg),
            child: Text(
              'About',
              style: FinvixTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: FinvixSpacing.md),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: FinvixRadius.radiusLg,
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                width: 0.5,
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.info),
              title: Text(
                'Version',
                style: FinvixTypography.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                '1.1.0 (Build 6)',
                style: FinvixTypography.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: FinvixSpacing.xl),
          // App Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Finvix',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Finvix is your personal finance companion designed to help you track income and expenses effortlessly. With intuitive categorization, group organization, detailed analytics, and powerful filtering options, take control of your financial journey.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Features:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(context, '📊 Visual analytics with charts and graphs'),
                _buildFeatureItem(context, '💰 Track income and expenses by category'),
                _buildFeatureItem(context, '📁 Organize expenses with custom groups'),
                _buildFeatureItem(context, '📅 Filter transactions by date, type, category, and group'),
                _buildFeatureItem(context, '💾 Export/Import data (JSON, CSV, Excel)'),
                _buildFeatureItem(context, '🎨 Customizable categories and groups with icons and colors'),
                _buildFeatureItem(context, '🌙 Dark mode support'),
                _buildFeatureItem(context, '📱 Offline-first with local data storage'),
                _buildFeatureItem(context, '🔒 Secure app lock with PIN, Pattern & Biometrics'),
              ],
            ),
          ),
          
          const Divider(),
          
          // Contact Information
          const ListTile(
            leading: Icon(Icons.email, color: Colors.blue),
            title: Text('Contact Us'),
            subtitle: Text('contact.aktechsource@gmail.com'),
          ),
          
          ListTile(
            leading: Icon(Icons.copyright, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
            title: const Text('© 2026 Finvix'),
            subtitle: const Text('All rights reserved'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, WidgetRef ref) {
    final lockState = ref.watch(appLockProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.lg),
          child: Text(
            'Security',
            style: FinvixTypography.titleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: FinvixSpacing.md),
        
        // App Lock Toggle
        Container(
          margin: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: FinvixRadius.radiusLg,
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  lockState.isEnabled ? Icons.lock_rounded : Icons.lock_open_rounded,
                  color: lockState.isEnabled ? FinvixColors.success : null,
                ),
                title: Text(
                  'App Lock',
                  style: FinvixTypography.titleMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  lockState.isEnabled
                      ? 'Enabled (${_getLockTypeName(lockState.lockType)})'
                      : 'Protect your data',
                  style: FinvixTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Switch(
                  value: lockState.isEnabled,
                  onChanged: (value) {
                    if (value) {
                      _showLockSetupDialog(context, ref);
                    } else {
                      _confirmDisableLock(context, ref);
                    }
                  },
                ),
              ),
              
              if (lockState.isEnabled) ...[
                const Divider(height: 1),
                
                // Change Lock Type
                ListTile(
                  leading: const Icon(Icons.security_rounded),
                  title: Text(
                    'Change Lock Type',
                    style: FinvixTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Currently using ${_getLockTypeName(lockState.lockType)}',
                    style: FinvixTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLockSetupDialog(context, ref),
                ),
                
                // Biometric as secondary (if available and not primary)
                if (lockState.biometricAvailable && 
                    lockState.lockType != LockType.biometric) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      _getBiometricIcon(lockState),
                      color: lockState.biometricEnabled ? FinvixColors.success : null,
                    ),
                    title: Text(
                      'Use ${lockState.biometricDisplayName}',
                      style: FinvixTypography.titleMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      lockState.biometricEnabled
                          ? 'Enabled as quick unlock'
                          : 'Quick unlock option',
                      style: FinvixTypography.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Switch(
                      value: lockState.biometricEnabled,
                      onChanged: (value) async {
                        if (value) {
                          await ref.read(appLockProvider.notifier).enableBiometricSecondary();
                        } else {
                          await ref.read(appLockProvider.notifier).disableBiometric();
                        }
                      },
                    ),
                  ),
                ],
                
                // Auto-lock timeout
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.timer_rounded),
                  title: Text(
                    'Auto-lock',
                    style: FinvixTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    _getAutoLockText(lockState.autoLockMinutes),
                    style: FinvixTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAutoLockDialog(context, ref, lockState.autoLockMinutes),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getLockTypeName(LockType type) {
    switch (type) {
      case LockType.pin:
        return 'PIN';
      case LockType.pattern:
        return 'Pattern';
      case LockType.biometric:
        return 'Biometric';
      case LockType.none:
        return 'None';
    }
  }

  IconData _getBiometricIcon(AppLockState state) {
    if (state.availableBiometrics.any((b) => b.toString().contains('face'))) {
      return Icons.face_rounded;
    }
    return Icons.fingerprint_rounded;
  }

  String _getAutoLockText(int minutes) {
    if (minutes == 0) return 'Immediately';
    if (minutes == -1) return 'Never';
    if (minutes == 1) return 'After 1 minute';
    if (minutes < 60) return 'After $minutes minutes';
    final hours = minutes ~/ 60;
    return 'After $hours hour${hours > 1 ? 's' : ''}';
  }

  void _showLockSetupDialog(BuildContext context, WidgetRef ref) {
    final lockState = ref.read(appLockProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(FinvixSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: FinvixSpacing.lg),
            Text(
              'Choose Lock Type',
              style: FinvixTypography.headlineSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: FinvixSpacing.lg),
            
            // PIN option
            _buildLockOption(
              context: context,
              icon: Icons.pin_rounded,
              title: 'PIN Lock',
              subtitle: '4 digit number',
              onTap: () {
                Navigator.pop(context);
                _navigateToLockSetup(context, LockType.pin);
              },
            ),
            
            const SizedBox(height: FinvixSpacing.md),
            
            // Pattern option
            _buildLockOption(
              context: context,
              icon: Icons.pattern_rounded,
              title: 'Pattern Lock',
              subtitle: 'Connect at least 4 dots',
              onTap: () {
                Navigator.pop(context);
                _navigateToLockSetup(context, LockType.pattern);
              },
            ),
            
            // Biometric option (if available)
            if (lockState.biometricAvailable) ...[
              const SizedBox(height: FinvixSpacing.md),
              _buildLockOption(
                context: context,
                icon: _getBiometricIcon(lockState),
                title: lockState.biometricDisplayName,
                subtitle: 'Use your biometric to unlock',
                onTap: () async {
                  Navigator.pop(context);
                  final success = await ref.read(appLockProvider.notifier).setupBiometricLock();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Biometric lock enabled!')),
                    );
                  }
                },
              ),
            ],
            
            const SizedBox(height: FinvixSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildLockOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: FinvixRadius.radiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: FinvixRadius.radiusMd,
        child: Padding(
          padding: const EdgeInsets.all(FinvixSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: FinvixRadius.radiusMd,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: FinvixSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FinvixTypography.titleMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: FinvixTypography.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLockSetup(BuildContext context, LockType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LockScreen(
          isSetup: true,
          setupType: type,
          onUnlock: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${_getLockTypeName(type)} lock enabled!')),
            );
          },
        ),
      ),
    );
  }

  void _confirmDisableLock(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable App Lock?'),
        content: const Text(
          'Your data will no longer be protected. Anyone with access to your device can view your expenses.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(appLockProvider.notifier).disableLock();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App lock disabled')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: FinvixColors.error),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }

  void _showAutoLockDialog(BuildContext context, WidgetRef ref, int currentMinutes) {
    final options = [
      (0, 'Immediately'),
      (1, '1 minute'),
      (5, '5 minutes'),
      (15, '15 minutes'),
      (30, '30 minutes'),
      (60, '1 hour'),
      (-1, 'Never'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(FinvixSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: FinvixSpacing.lg),
              Text(
                'Auto-lock After',
                style: FinvixTypography.headlineSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: FinvixSpacing.md),
              ...options.map((option) => RadioListTile<int>(
                value: option.$1,
                groupValue: currentMinutes,
                title: Text(option.$2),
                onChanged: (value) async {
                  if (value != null) {
                    await ref.read(appLockProvider.notifier).setAutoLockMinutes(value);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              )),
              const SizedBox(height: FinvixSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  • ',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    // Show format selection dialog
    final format = await showDialog<ExportFormat>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Export Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.data_object, color: Colors.blue),
              title: const Text('JSON'),
              subtitle: const Text('Full backup with all data'),
              onTap: () => Navigator.pop(context, ExportFormat.json),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('CSV'),
              subtitle: const Text('Transaction data only'),
              onTap: () => Navigator.pop(context, ExportFormat.csv),
            ),
            ListTile(
              leading: const Icon(Icons.file_present, color: Colors.orange),
              title: const Text('Excel (CSV)'),
              subtitle: const Text('Open with Excel'),
              onTap: () => Navigator.pop(context, ExportFormat.excel),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (format == null) return;

    try {
      // Show loading
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exporting data...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      final categoryRepo = ref.read(categoryRepositoryProvider);
      final transactionRepo = ref.read(transactionRepositoryProvider);
      
      // Check if there's any data to export
      final categories = categoryRepo.getAllCategories();
      final transactions = transactionRepo.getAllTransactions();
      
      if (categories.isEmpty && transactions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No data to export')),
          );
        }
        return;
      }

      final exportService = ExportImportService(categoryRepo, transactionRepo);
      final result = await exportService.exportData(format);

      if (context.mounted) {
        if (result['success']) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Export Successful'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data exported successfully!'),
                  const SizedBox(height: 8),
                  Text('Categories: ${result['categoriesCount']}'),
                  Text('Transactions: ${result['transactionsCount']}'),
                  const SizedBox(height: 16),
                  Text('File: ${result['fileName']}', style: const TextStyle(fontSize: 12)),
                  if (result['filePath'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Location: ${result['filePath']}',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    'The file has been saved to your Download folder.',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          throw Exception(result['error'] ?? 'Unknown error');
        }
      }
    } catch (e) {
      print('Export error: $e');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Export Failed'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Failed to export data.'),
                const SizedBox(height: 8),
                Text('Error: ${e.toString()}', style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv', 'xlsx', 'xls'],
        dialogTitle: 'Select Backup File',
        withData: true, // Important for web platform
      );

      if (result == null || result.files.isEmpty) {
        // User cancelled the picker
        return;
      }

      final fileName = result.files.single.name;
      
      print('Selected file: $fileName');

      final categoryRepo = ref.read(categoryRepositoryProvider);
      final transactionRepo = ref.read(transactionRepositoryProvider);
      final exportService = ExportImportService(categoryRepo, transactionRepo);

      print('Reading file...');
      // Read file bytes
      final bytes = result.files.first.bytes;
      if (bytes == null) {
        throw Exception('Could not read file');
      }
      final fileData = utf8.decode(bytes);
      print('File read successfully, size: ${fileData.length} bytes');

      print('Importing data...');
      final fileExtension = fileName.split('.').last.toLowerCase();
      Map<String, dynamic> importResult;
      
      if (fileExtension == 'json') {
        importResult = await exportService.importFromJson(fileData);
      } else if (fileExtension == 'csv' || fileExtension == 'xlsx' || fileExtension == 'xls') {
        importResult = await exportService.importFromCsv(fileData, categoryRepo);
      } else {
        throw Exception('Unsupported file format: $fileExtension');
      }

      if (context.mounted) {
        if (importResult['success']) {
          // Refresh providers
          ref.invalidate(categoriesProvider);
          ref.invalidate(transactionsProvider);
          
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Import Successful'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data imported successfully!'),
                  const SizedBox(height: 16),
                  Text('Categories imported: ${importResult['categoriesCount']}'),
                  Text('Transactions imported: ${importResult['transactionsCount']}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Your data has been merged with the imported data.',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Import Failed'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Failed to import data.'),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${importResult['error']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Make sure the file is a valid Finvix backup file.',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('Import error: $e');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Import Failed'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('An error occurred during import.'),
                const SizedBox(height: 8),
                Text('Error: $e', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 16),
                const Text(
                  'Please check that you selected a valid Finvix backup file.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
