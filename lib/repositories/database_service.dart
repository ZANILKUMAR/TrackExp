import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class DatabaseService {
  static const String categoriesBox = 'categories';
  static const String transactionsBox = 'transactions';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TransactionAdapter());
    
    // Open boxes
    await Hive.openBox<Category>(categoriesBox);
    await Hive.openBox<Transaction>(transactionsBox);
    
    // Add default categories if empty
    await _addDefaultCategories();
  }

  static Future<void> _addDefaultCategories() async {
    final box = Hive.box<Category>(categoriesBox);
    
    if (box.isEmpty) {
      // Default expense categories
      final expenseCategories = [
        Category(id: 'exp_1', name: 'Food & Dining', type: 'expense', colorValue: 0xFFFF6B6B),
        Category(id: 'exp_2', name: 'Transportation', type: 'expense', colorValue: 0xFF4ECDC4),
        Category(id: 'exp_3', name: 'Shopping', type: 'expense', colorValue: 0xFFFFE66D),
        Category(id: 'exp_4', name: 'Entertainment', type: 'expense', colorValue: 0xFFA8E6CF),
        Category(id: 'exp_5', name: 'Healthcare', type: 'expense', colorValue: 0xFFFF8B94),
        Category(id: 'exp_6', name: 'Bills & Utilities', type: 'expense', colorValue: 0xFFC7CEEA),
        Category(id: 'exp_7', name: 'Education', type: 'expense', colorValue: 0xFFB4A7D6),
        Category(id: 'exp_8', name: 'Rent', type: 'expense', colorValue: 0xFFFF9A9E),
        Category(id: 'exp_9', name: 'Groceries', type: 'expense', colorValue: 0xFF98D8C8),
        Category(id: 'exp_10', name: 'Others', type: 'expense', colorValue: 0xFFB0B0B0),
      ];
      
      // Default income categories
      final incomeCategories = [
        Category(id: 'inc_1', name: 'Salary', type: 'income', colorValue: 0xFF95E1D3),
        Category(id: 'inc_2', name: 'Business', type: 'income', colorValue: 0xFFF38181),
        Category(id: 'inc_3', name: 'Freelance', type: 'income', colorValue: 0xFF6BCF7F),
        Category(id: 'inc_4', name: 'Investments', type: 'income', colorValue: 0xFFAA96DA),
        Category(id: 'inc_5', name: 'Gifts', type: 'income', colorValue: 0xFFFFD93D),
        Category(id: 'inc_6', name: 'Others', type: 'income', colorValue: 0xFFFCBAD3),
      ];
      
      for (var category in [...expenseCategories, ...incomeCategories]) {
        await box.put(category.id, category);
      }
    }
  }

  // Close all boxes
  static Future<void> close() async {
    await Hive.close();
  }
}
