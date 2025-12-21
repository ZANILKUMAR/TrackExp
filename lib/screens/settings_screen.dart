import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/export_import_service.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import 'category_management_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme Settings
          ListTile(
            leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme(value);
              },
            ),
          ),
          const Divider(),

          // Category Management
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
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
          const Divider(),

          // Data Management Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Data Management',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Export Data
          ListTile(
            leading: const Icon(Icons.upload_file, color: Colors.blue),
            title: const Text('Export Data'),
            subtitle: const Text('Save as JSON, CSV, or Excel'),
            onTap: () => _exportData(context, ref),
          ),

          // Import Data
          ListTile(
            leading: const Icon(Icons.download, color: Colors.green),
            title: const Text('Import Data'),
            subtitle: const Text('Restore from JSON, CSV, or Excel'),
            onTap: () => _importData(context, ref),
          ),
          const Divider(),

          // About Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          const Divider(),
          
          // App Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About FinExp',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'FinExp is your personal finance companion designed to help you track income and expenses effortlessly. With intuitive categorization, detailed analytics, and powerful filtering options, take control of your financial journey.',
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
                _buildFeatureItem(context, '📅 Filter transactions by date and type'),
                _buildFeatureItem(context, '💾 Export/Import data (JSON, CSV, Excel)'),
                _buildFeatureItem(context, '🎨 Customizable categories with icons and colors'),
                _buildFeatureItem(context, '🌙 Dark mode support'),
                _buildFeatureItem(context, '📱 Offline-first with local data storage'),
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
            leading: Icon(Icons.copyright, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            title: const Text('© 2026 FinExp'),
            subtitle: const Text('All rights reserved'),
          ),
        ],
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
                    'Make sure the file is a valid FinExp backup file.',
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
                  'Please check that you selected a valid FinExp backup file.',
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
