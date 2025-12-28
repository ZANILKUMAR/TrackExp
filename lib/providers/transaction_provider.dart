import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchTransactions();
});

// Filter state providers
final selectedTransactionTypeProvider = StateProvider<String?>((ref) => null);
final selectedCategoriesFilterProvider = StateProvider<List<String>>((ref) => []); // Changed to List
final selectedDateRangeProvider = StateProvider<TransactionDateRange?>((ref) => null);
final selectedDateFilterTypeProvider = StateProvider<String?>((ref) => null); // 'week', 'month', 'custom'
final selectedGroupFilterProvider = StateProvider<String?>((ref) => null); // Filter by group

class TransactionDateRange {
  final DateTime start;
  final DateTime end;

  TransactionDateRange(this.start, this.end);
}

// Filtered transactions provider
final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final allTransactions = ref.watch(transactionsProvider).value ?? [];
  final typeFilter = ref.watch(selectedTransactionTypeProvider);
  final categoriesFilter = ref.watch(selectedCategoriesFilterProvider);
  final dateRange = ref.watch(selectedDateRangeProvider);
  final groupFilter = ref.watch(selectedGroupFilterProvider);

  var filtered = allTransactions;

  if (typeFilter != null) {
    filtered = filtered.where((t) => t.type == typeFilter).toList();
  }

  if (categoriesFilter.isNotEmpty) {
    filtered = filtered.where((t) => categoriesFilter.contains(t.categoryId)).toList();
  }

  if (dateRange != null) {
    filtered = filtered.where((t) => 
      t.date.isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
      t.date.isBefore(dateRange.end.add(const Duration(days: 1)))
    ).toList();
  }

  if (groupFilter != null) {
    if (groupFilter == 'ungrouped') {
      // Filter for transactions without a group
      filtered = filtered.where((t) => t.groupId == null || t.groupId!.isEmpty).toList();
    } else {
      // Filter for specific group
      filtered = filtered.where((t) => t.groupId == groupFilter).toList();
    }
  }

  return filtered;
});

// Monthly summary providers
final currentMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final monthlyTransactionsProvider = Provider<List<Transaction>>((ref) {
  final allTransactions = ref.watch(transactionsProvider).value ?? [];
  final currentMonth = ref.watch(currentMonthProvider);
  
  final start = DateTime(currentMonth.year, currentMonth.month, 1);
  final end = DateTime(currentMonth.year, currentMonth.month + 1, 0);
  
  return allTransactions
      .where((t) => 
        t.date.isAfter(start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1))))
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

final monthlyIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(monthlyTransactionsProvider);
  return transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlyExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(monthlyTransactionsProvider);
  return transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlySavingsProvider = Provider<double>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expense = ref.watch(monthlyExpenseProvider);
  return income - expense;
});

// Category-wise spending for pie chart
final categoryWiseSpendingProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(monthlyTransactionsProvider);
  final expenseTransactions = transactions.where((t) => t.type == 'expense');
  
  final Map<String, double> categoryTotals = {};
  for (var transaction in expenseTransactions) {
    categoryTotals[transaction.categoryId] = 
        (categoryTotals[transaction.categoryId] ?? 0) + transaction.amount;
  }
  
  return categoryTotals;
});

class TransactionNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionRepository repository;

  TransactionNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  void loadTransactions() {
    state = AsyncValue.data(repository.getAllTransactions());
  }

  Future<void> addTransaction(Transaction transaction) async {
    await repository.addTransaction(transaction);
    // Force reload and notify listeners
    state = AsyncValue.data(repository.getAllTransactions());
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await repository.updateTransaction(transaction);
    // Force reload and notify listeners
    state = AsyncValue.data(repository.getAllTransactions());
  }

  Future<void> deleteTransaction(String id) async {
    await repository.deleteTransaction(id);
    // Force reload and notify listeners
    state = AsyncValue.data(repository.getAllTransactions());
  }
}

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<List<Transaction>>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});
