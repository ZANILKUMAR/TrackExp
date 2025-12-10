import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import '../models/category.dart';
import '../models/transaction.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';

enum ExportFormat { json, csv, excel }

class ExportImportService {
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;

  ExportImportService(this.categoryRepository, this.transactionRepository);

  // Export data in specified format
  Future<Map<String, dynamic>> exportData(ExportFormat format) async {
    try {
      final categories = categoryRepository.getAllCategories();
      final transactions = transactionRepository.getAllTransactions();

      print('Exporting ${categories.length} categories and ${transactions.length} transactions');

      String fileName;
      String data;
      String mimeType;

      switch (format) {
        case ExportFormat.json:
          fileName = 'finexp_backup_${DateTime.now().millisecondsSinceEpoch}.json';
          data = _exportToJson(categories, transactions);
          mimeType = 'application/json';
          break;
        case ExportFormat.csv:
          fileName = 'finexp_transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
          data = _exportToCsv(categories, transactions);
          mimeType = 'text/csv';
          break;
        case ExportFormat.excel:
          // For simplicity, we'll use CSV format which Excel can open
          fileName = 'finexp_transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
          data = _exportToCsv(categories, transactions);
          mimeType = 'text/csv';
          break;
      }

      // Download file
      final filePath = await _downloadFile(data, fileName, mimeType);

      return {
        'success': true,
        'categoriesCount': categories.length,
        'transactionsCount': transactions.length,
        'fileName': fileName,
        'filePath': filePath, // Mobile will have file path, web will be null
      };
    } catch (e) {
      print('Error in exportData: $e');
      return {
        'success': false,
        'error': e.toString(),
        'categoriesCount': 0,
        'transactionsCount': 0,
      };
    }
  }

  String _exportToJson(List<Category> categories, List<Transaction> transactions) {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
      'appName': 'FinExp',
      'categories': categories.map((c) => c.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
    return jsonEncode(data);
  }

  String _exportToCsv(List<Category> categories, List<Transaction> transactions) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    // Create CSV with categories section
    List<List<dynamic>> rows = [];
    
    // Add Categories section
    rows.add(['CATEGORIES']); // Section marker
    rows.add(['ID', 'Name', 'Type', 'Color', 'Icon']); // Category header
    
    for (var category in categories) {
      rows.add([
        category.id,
        category.name,
        category.type,
        category.colorValue?.toString() ?? '',
        category.iconCodePoint?.toString() ?? '',
      ]);
    }
    
    // Add empty row as separator
    rows.add([]);
    
    // Add Transactions section
    rows.add(['TRANSACTIONS']); // Section marker
    rows.add(['Date', 'Type', 'Category', 'Amount', 'Notes']); // Transaction header

    for (var transaction in transactions) {
      final category = categories.firstWhere(
        (c) => c.id == transaction.categoryId,
        orElse: () => Category(id: '', name: 'Unknown', type: transaction.type),
      );

      rows.add([
        dateFormat.format(transaction.date),
        transaction.type,
        category.name,
        transaction.amount.toStringAsFixed(2),
        transaction.notes ?? '',
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  Future<String?> _downloadFile(String data, String fileName, String mimeType) async {
    if (kIsWeb) {
      // Web platform
      final bytes = utf8.encode(data);
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
      return null; // Web doesn't return file path
    } else {
      // Mobile/Desktop platform
      try {
        // Request storage permission for Android
        if (Platform.isAndroid) {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            // For Android 13+ (API 33+), use photos/media permissions
            if (await Permission.photos.isGranted || await Permission.mediaLibrary.isGranted) {
              // Already have media access
            } else {
              // Request permission
              status = await Permission.storage.request();
              if (!status.isGranted) {
                // Try requesting photos permission for Android 13+
                final photosStatus = await Permission.photos.request();
                if (!photosStatus.isGranted) {
                  throw Exception('Storage permission denied');
                }
              }
            }
          }
        }

        // Get the Downloads directory
        Directory? directory;
        if (Platform.isAndroid) {
          // For Android, use external storage Downloads directory
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            // Fallback to app's external storage
            directory = await getExternalStorageDirectory();
          }
        } else {
          // For iOS or other platforms
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory == null) {
          throw Exception('Could not access storage directory');
        }

        // Create the file path
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        // Write the data to file
        await file.writeAsString(data);

        print('File saved to: $filePath');
        return filePath;
      } catch (e) {
        print('Error saving file: $e');
        rethrow;
      }
    }
  }

  // Import data from JSON string
  Future<Map<String, dynamic>> importFromJson(String jsonData) async {
    try {
      print('Parsing JSON data...');
      final data = jsonDecode(jsonData);
      
      int categoriesCount = 0;
      int transactionsCount = 0;

      // Import categories
      if (data['categories'] != null) {
        print('Importing categories...');
        for (var categoryJson in data['categories']) {
          try {
            final category = Category.fromJson(categoryJson);
            // Check if category already exists
            final existing = categoryRepository.getAllCategories()
                .where((c) => c.id == category.id)
                .firstOrNull;
            if (existing == null) {
              await categoryRepository.addCategory(category);
              categoriesCount++;
            }
          } catch (e) {
            print('Error importing category: $e');
          }
        }
        print('Imported $categoriesCount categories');
      }

      // Import transactions
      if (data['transactions'] != null) {
        print('Importing transactions...');
        for (var transactionJson in data['transactions']) {
          try {
            final transaction = Transaction.fromJson(transactionJson);
            // Check if transaction already exists
            final existing = transactionRepository.getAllTransactions()
                .where((t) => t.id == transaction.id)
                .firstOrNull;
            if (existing == null) {
              await transactionRepository.addTransaction(transaction);
              transactionsCount++;
            }
          } catch (e) {
            print('Error importing transaction: $e');
          }
        }
        print('Imported $transactionsCount transactions');
      }

      return {
        'success': true,
        'categoriesCount': categoriesCount,
        'transactionsCount': transactionsCount,
      };
    } catch (e) {
      print('Import error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'categoriesCount': 0,
        'transactionsCount': 0,
      };
    }
  }

  // Import data from CSV string
  Future<Map<String, dynamic>> importFromCsv(String csvData, CategoryRepository categoryRepo) async {
    try {
      print('Parsing CSV data...');
      final rows = const CsvToListConverter().convert(csvData);
      
      if (rows.isEmpty || rows.length < 2) {
        throw Exception('CSV file is empty or invalid');
      }
      
      int categoriesCount = 0;
      int transactionsCount = 0;
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      Map<String, String> categoryNameToId = {}; // Map to track category names to IDs
      
      // Find section markers
      int categoryStartIndex = -1;
      int transactionStartIndex = -1;
      
      for (int i = 0; i < rows.length; i++) {
        if (rows[i].isNotEmpty && rows[i][0].toString().toUpperCase() == 'CATEGORIES') {
          categoryStartIndex = i + 1; // Next row is header
        } else if (rows[i].isNotEmpty && rows[i][0].toString().toUpperCase() == 'TRANSACTIONS') {
          transactionStartIndex = i + 1; // Next row is header
          break;
        }
      }
      
      // Import categories if section exists
      if (categoryStartIndex > 0) {
        print('Importing categories from CSV...');
        // Skip header row at categoryStartIndex, process data rows
        for (int i = categoryStartIndex + 1; i < rows.length; i++) {
          final row = rows[i];
          // Stop if we hit empty row or transactions section
          if (row.isEmpty || (row.isNotEmpty && row[0].toString().toUpperCase() == 'TRANSACTIONS')) {
            break;
          }
          
          if (row.length < 3) continue; // Need at least ID, Name, Type
          
          try {
            // Parse: ID, Name, Type, Color, Icon
            final id = row[0].toString();
            final name = row[1].toString();
            final type = row[2].toString().toLowerCase();
            final colorValue = row.length > 3 && row[3].toString().isNotEmpty 
                ? int.tryParse(row[3].toString()) 
                : null;
            final iconCodePoint = row.length > 4 && row[4].toString().isNotEmpty 
                ? int.tryParse(row[4].toString()) 
                : null;
            
            // Check if category already exists by ID or name
            final existingById = categoryRepo.getAllCategories()
                .where((c) => c.id == id)
                .firstOrNull;
            final existingByName = categoryRepo.getAllCategories()
                .where((c) => c.name.toLowerCase() == name.toLowerCase() && c.type == type)
                .firstOrNull;
            
            if (existingById == null && existingByName == null) {
              final category = Category(
                id: id,
                name: name,
                type: type,
                colorValue: colorValue,
                iconCodePoint: iconCodePoint,
              );
              await categoryRepo.addCategory(category);
              categoryNameToId[name.toLowerCase()] = id;
              categoriesCount++;
            } else {
              // Use existing category
              categoryNameToId[name.toLowerCase()] = existingById?.id ?? existingByName!.id;
            }
          } catch (e) {
            print('Error importing category row $i: $e');
          }
        }
        print('Imported $categoriesCount categories from CSV');
      }
      
      // Import transactions if section exists
      if (transactionStartIndex > 0) {
        print('Importing transactions from CSV...');
        // Skip header row at transactionStartIndex, process data rows
        for (int i = transactionStartIndex + 1; i < rows.length; i++) {
          try {
            final row = rows[i];
            if (row.length < 4) continue; // Need at least Date, Type, Category, Amount
            
            // Parse: Date, Type, Category, Amount, Notes
            final dateStr = row[0].toString();
            final type = row[1].toString().toLowerCase();
            final categoryName = row[2].toString();
            final amount = double.tryParse(row[3].toString()) ?? 0.0;
            final notes = row.length > 4 ? row[4].toString() : null;
            
            // Parse date
            DateTime date;
            try {
              date = dateFormat.parse(dateStr);
            } catch (e) {
              // Try alternative date formats
              try {
                date = DateTime.parse(dateStr);
              } catch (e2) {
                print('Could not parse date: $dateStr, skipping row');
                continue;
              }
            }
            
            // Find category by name (use imported or existing)
            String? categoryId = categoryNameToId[categoryName.toLowerCase()];
            if (categoryId == null) {
              // Try to find existing category
              final categories = categoryRepo.getCategoriesByType(type);
              Category? category = categories.firstWhere(
                (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
                orElse: () => Category(id: '', name: '', type: type),
              );
              
              // If category not found, create a new one
              if (category.id.isEmpty) {
                category = Category(
                  id: 'imported_${DateTime.now().millisecondsSinceEpoch}_${categoryName.replaceAll(' ', '_')}',
                  name: categoryName,
                  type: type,
                  colorValue: type == 'income' ? 0xFF95E1D3 : 0xFFFF6B6B,
                );
                await categoryRepo.addCategory(category);
              }
              categoryId = category.id;
            }
            
            // Create transaction
            final transaction = Transaction(
              id: 'imported_${DateTime.now().millisecondsSinceEpoch}_$i',
              type: type,
              categoryId: categoryId,
              amount: amount,
              date: date,
              notes: notes,
            );
            
            // Check if transaction already exists (by checking similar data)
            final existing = transactionRepository.getAllTransactions().where(
              (t) => t.amount == transaction.amount && 
                     t.date.difference(transaction.date).abs() < const Duration(seconds: 1) &&
                     t.categoryId == transaction.categoryId
            ).firstOrNull;
            
            if (existing == null) {
              await transactionRepository.addTransaction(transaction);
              transactionsCount++;
            }
          } catch (e) {
            print('Error importing transaction row $i: $e');
            // Continue with next row
          }
        }
        print('Imported $transactionsCount transactions from CSV');
      }
      
      return {
        'success': true,
        'categoriesCount': categoriesCount,
        'transactionsCount': transactionsCount,
      };
    } catch (e) {
      print('CSV import error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'categoriesCount': 0,
        'transactionsCount': 0,
      };
    }
  }
}
