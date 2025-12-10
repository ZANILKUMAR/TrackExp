import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final Box<Transaction> _box = Hive.box<Transaction>('transactions');

  // Get all transactions
  List<Transaction> getAllTransactions() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transaction by id
  Transaction? getTransactionById(String id) {
    return _box.get(id);
  }

  // Add transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  // Update transaction
  Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  // Get transactions by date range
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _box.values
        .where((t) => t.date.isAfter(start.subtract(const Duration(days: 1))) &&
                     t.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transactions by type
  List<Transaction> getTransactionsByType(String type) {
    return _box.values
        .where((t) => t.type == type)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(String categoryId) {
    return _box.values
        .where((t) => t.categoryId == categoryId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get monthly transactions
  List<Transaction> getMonthlyTransactions(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);
    return getTransactionsByDateRange(start, end);
  }

  // Calculate total by type
  double getTotalByType(String type, {DateTime? start, DateTime? end}) {
    List<Transaction> transactions;
    
    if (start != null && end != null) {
      transactions = getTransactionsByDateRange(start, end);
    } else {
      transactions = getAllTransactions();
    }
    
    return transactions
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Calculate total by category
  double getTotalByCategory(String categoryId, {DateTime? start, DateTime? end}) {
    List<Transaction> transactions;
    
    if (start != null && end != null) {
      transactions = getTransactionsByDateRange(start, end);
    } else {
      transactions = getAllTransactions();
    }
    
    return transactions
        .where((t) => t.categoryId == categoryId)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Watch transactions
  Stream<List<Transaction>> watchTransactions() {
    return Stream<List<Transaction>>.multi((controller) {
      List<String> lastIds = [];
      
      void emitIfChanged() {
        if (!controller.isClosed) {
          final current = getAllTransactions();
          final currentIds = current.map((t) => t.id).toList()..sort();
          final lastIdsSorted = List<String>.from(lastIds)..sort();
          
          // Only emit if the transaction list has actually changed
          if (currentIds.length != lastIdsSorted.length ||
              !_listsEqual(currentIds, lastIdsSorted)) {
            lastIds = currentIds;
            controller.add(current);
          }
        }
      }
      
      // Emit current data immediately
      final initial = getAllTransactions();
      lastIds = initial.map((t) => t.id).toList();
      controller.add(initial);
      
      // Listen to box changes and emit updates
      final subscription = _box.watch().listen((_) {
        emitIfChanged();
      });
      
      // Add periodic check as fallback for mobile platforms (every 2 seconds)
      // This ensures updates are caught even if watch() doesn't fire reliably
      final timer = Stream.periodic(const Duration(seconds: 2)).listen((_) {
        emitIfChanged();
      });
      
      controller.onCancel = () {
        subscription.cancel();
        timer.cancel();
      };
    });
  }
  
  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
