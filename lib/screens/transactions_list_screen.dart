import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../utils/format_helper.dart';
import 'add_transaction_screen.dart';

class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  ConsumerState<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends ConsumerState<TransactionsListScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(filteredTransactionsProvider);
    final categories = ref.watch(categoriesProvider).value ?? [];
    final typeFilter = ref.watch(selectedTransactionTypeProvider);
    final categoriesFilter = ref.watch(selectedCategoriesFilterProvider);
    final dateRange = ref.watch(selectedDateRangeProvider);
    final dateFilterType = ref.watch(selectedDateFilterTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, categories),
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters
          if (typeFilter != null || categoriesFilter.isNotEmpty || dateRange != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.filter_alt, size: 14, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            'Active Filters',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ref.read(selectedTransactionTypeProvider.notifier).state = null;
                          ref.read(selectedCategoriesFilterProvider.notifier).state = [];
                          ref.read(selectedDateRangeProvider.notifier).state = null;
                          ref.read(selectedDateFilterTypeProvider.notifier).state = null;
                        },
                        icon: const Icon(Icons.clear_all, size: 14),
                        label: const Text('Clear All', style: TextStyle(fontSize: 11)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (dateRange != null)
                        _buildActiveFilterChip(
                          label: dateFilterType == 'week' 
                              ? 'This Week' 
                              : dateFilterType == 'month' 
                                  ? 'This Month' 
                                  : '${FormatHelper.formatShortDate(dateRange.start)} - ${FormatHelper.formatShortDate(dateRange.end)}',
                          icon: Icons.calendar_today,
                          onDeleted: () {
                            ref.read(selectedDateRangeProvider.notifier).state = null;
                            ref.read(selectedDateFilterTypeProvider.notifier).state = null;
                          },
                        ),
                      if (typeFilter != null)
                        _buildActiveFilterChip(
                          label: typeFilter == 'income' ? 'Income' : 'Expense',
                          icon: typeFilter == 'income' ? Icons.trending_up : Icons.trending_down,
                          color: typeFilter == 'income' ? Colors.green : Colors.red,
                          onDeleted: () {
                            ref.read(selectedTransactionTypeProvider.notifier).state = null;
                          },
                        ),
                      ...categoriesFilter.map((categoryId) {
                        final category = categories.firstWhere((c) => c.id == categoryId);
                        return _buildActiveFilterChip(
                          label: category.name,
                          icon: category.iconCodePoint != null 
                              ? IconData(category.iconCodePoint!, fontFamily: 'MaterialIcons')
                              : Icons.category,
                          color: category.colorValue != null ? Color(category.colorValue!) : null,
                          onDeleted: () {
                            final updated = List<String>.from(categoriesFilter)..remove(categoryId);
                            ref.read(selectedCategoriesFilterProvider.notifier).state = updated;
                          },
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

          // Filter Summary (Income/Expense Totals)
          if (typeFilter != null || categoriesFilter.isNotEmpty || dateRange != null)
            _buildFilterSummary(transactions),

          // Transactions List
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  )
                : _buildGroupedTransactionsList(transactions, categories),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedTransactionsList(List transactions, List<Category> categories) {
    // Group transactions by date
    final Map<String, List> groupedTransactions = {};
    for (var transaction in transactions) {
      final dateKey = FormatHelper.formatDate(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) {
        final dateA = groupedTransactions[a]![0].date;
        final dateB = groupedTransactions[b]![0].date;
        return dateB.compareTo(dateA); // Most recent first
      });

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, groupIndex) {
        final dateKey = sortedDates[groupIndex];
        final dateTransactions = groupedTransactions[dateKey]!;
        final transactionDate = dateTransactions[0].date;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getRelativeDateLabel(transactionDate),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateKey,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Transactions for this date
            ...dateTransactions.asMap().entries.map((entry) {
              final index = entry.key;
              final transaction = entry.value;
              final category = categories.firstWhere(
                (c) => c.id == transaction.categoryId,
                orElse: () => Category(
                  id: 'unknown',
                  name: 'Unknown',
                  type: transaction.type,
                ),
              );

              return Dismissible(
                key: Key(transaction.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Transaction'),
                      content: const Text('Are you sure you want to delete this transaction?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  ref.read(transactionNotifierProvider.notifier)
                      .deleteTransaction(transaction.id);
                  // Force refresh providers to ensure UI updates on all platforms
                  ref.invalidate(transactionsProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction deleted')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: index == dateTransactions.length - 1
                            ? Theme.of(context).colorScheme.surfaceContainerHighest
                            : Theme.of(context).colorScheme.surface,
                        width: index == dateTransactions.length - 1 ? 1 : 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: category.colorValue != null
                          ? Color(category.colorValue!)
                          : (transaction.type == 'income' ? Colors.green : Colors.red),
                      child: Icon(
                        transaction.type == 'income'
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: transaction.notes != null
                        ? Text(
                            transaction.notes!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${transaction.type == 'income' ? '+' : '-'} ${FormatHelper.formatCurrency(transaction.amount)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: transaction.type == 'income' ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          color: Colors.red.shade400,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Transaction'),
                                      content: const Text('Are you sure you want to delete this transaction?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    ref.read(transactionNotifierProvider.notifier)
                                        .deleteTransaction(transaction.id);
                                    // Force refresh providers to ensure UI updates on all platforms
                                    ref.invalidate(transactionsProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Transaction deleted')),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTransactionScreen(
                                  transaction: transaction,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
          ],
        );
      },
    );
  }

  String _getRelativeDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      final difference = today.difference(transactionDate).inDays;
      if (difference < 7) {
        return '$difference days ago';
      }
      return '';
    }
  }

  void _showFilterDialog(BuildContext context, List<Category> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            ref.read(selectedTransactionTypeProvider.notifier).state = null;
                            ref.read(selectedCategoriesFilterProvider.notifier).state = [];
                            ref.read(selectedDateRangeProvider.notifier).state = null;
                            ref.read(selectedDateFilterTypeProvider.notifier).state = null;
                          },
                          child: const Text('Clear All'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Tabs
              TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.calendar_today, size: 20), text: 'Date'),
                  Tab(icon: Icon(Icons.swap_vert, size: 20), text: 'Type'),
                  Tab(icon: Icon(Icons.category, size: 20), text: 'Category'),
                ],
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              
              // Tab Views
              Expanded(
                child: TabBarView(
                  children: [
                    // Date Filter Tab
                    _buildDateFilterTab(),
                    
                    // Type Filter Tab
                    _buildTypeFilterTab(),
                    
                    // Category Filter Tab
                    _buildCategoryFilterTab(categories),
                  ],
                ),
              ),
              
              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Filters', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDateFilterTab() {
    return Consumer(
      builder: (context, ref, child) {
        final dateFilterType = ref.watch(selectedDateFilterTypeProvider);
        final dateRange = ref.watch(selectedDateRangeProvider);
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildFilterOption(
              title: 'All Time',
              subtitle: 'Show all transactions',
              icon: Icons.all_inclusive,
              isSelected: dateFilterType == null,
              onTap: () {
                ref.read(selectedDateRangeProvider.notifier).state = null;
                ref.read(selectedDateFilterTypeProvider.notifier).state = null;
              },
            ),
            const SizedBox(height: 12),
            _buildFilterOption(
              title: 'This Week',
              subtitle: 'Last 7 days',
              icon: Icons.view_week,
              isSelected: dateFilterType == 'week',
              onTap: () {
                final now = DateTime.now();
                final start = now.subtract(Duration(days: now.weekday - 1));
                final end = start.add(const Duration(days: 6));
                ref.read(selectedDateRangeProvider.notifier).state = 
                    TransactionDateRange(DateTime(start.year, start.month, start.day), 
                                 DateTime(end.year, end.month, end.day, 23, 59, 59));
                ref.read(selectedDateFilterTypeProvider.notifier).state = 'week';
              },
            ),
            const SizedBox(height: 12),
            _buildFilterOption(
              title: 'This Month',
              subtitle: 'Current month',
              icon: Icons.calendar_month,
              isSelected: dateFilterType == 'month',
              onTap: () {
                final now = DateTime.now();
                final start = DateTime(now.year, now.month, 1);
                final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
                ref.read(selectedDateRangeProvider.notifier).state = TransactionDateRange(start, end);
                ref.read(selectedDateFilterTypeProvider.notifier).state = 'month';
              },
            ),
            const SizedBox(height: 12),
            _buildFilterOption(
              title: 'Custom Range',
              subtitle: 'Select from and to dates',
              icon: Icons.date_range,
              isSelected: dateFilterType == 'custom',
              onTap: () {
                ref.read(selectedDateFilterTypeProvider.notifier).state = 'custom';
              },
            ),
            if (dateFilterType == 'custom') ...[
              const SizedBox(height: 16),
              _buildCustomDateRangePicker(ref, dateRange),
            ],
          ],
        );
      },
    );
  }
  
  Widget _buildTypeFilterTab() {
    return Consumer(
      builder: (context, ref, child) {
        final currentType = ref.watch(selectedTransactionTypeProvider);
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildFilterOption(
              title: 'All Transactions',
              subtitle: 'Both income and expense',
              icon: Icons.list,
              isSelected: currentType == null,
              onTap: () {
                ref.read(selectedTransactionTypeProvider.notifier).state = null;
                // Clear category filter when switching to "All" to avoid confusion
                ref.read(selectedCategoriesFilterProvider.notifier).state = [];
              },
            ),
            const SizedBox(height: 12),
            _buildFilterOption(
              title: 'Income Only',
              subtitle: 'Money received',
              icon: Icons.trending_up,
              iconColor: Colors.green,
              isSelected: currentType == 'income',
              onTap: () {
                ref.read(selectedTransactionTypeProvider.notifier).state = 'income';
                // Clear categories that don't match the new type
                final selectedCats = ref.read(selectedCategoriesFilterProvider);
                final categories = ref.read(categoriesProvider).value ?? [];
                final validCats = selectedCats.where((catId) {
                  final cat = categories.firstWhere((c) => c.id == catId, orElse: () => Category(id: '', name: '', type: ''));
                  return cat.type == 'income';
                }).toList();
                ref.read(selectedCategoriesFilterProvider.notifier).state = validCats;
              },
            ),
            const SizedBox(height: 12),
            _buildFilterOption(
              title: 'Expense Only',
              subtitle: 'Money spent',
              icon: Icons.trending_down,
              iconColor: Colors.red,
              isSelected: currentType == 'expense',
              onTap: () {
                ref.read(selectedTransactionTypeProvider.notifier).state = 'expense';
                // Clear categories that don't match the new type
                final selectedCats = ref.read(selectedCategoriesFilterProvider);
                final categories = ref.read(categoriesProvider).value ?? [];
                final validCats = selectedCats.where((catId) {
                  final cat = categories.firstWhere((c) => c.id == catId, orElse: () => Category(id: '', name: '', type: ''));
                  return cat.type == 'expense';
                }).toList();
                ref.read(selectedCategoriesFilterProvider.notifier).state = validCats;
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildCategoryFilterTab(List<Category> categories) {
    return Consumer(
      builder: (context, ref, child) {
        final typeFilter = ref.watch(selectedTransactionTypeProvider);
        final selectedCategories = ref.watch(selectedCategoriesFilterProvider);
        
        final filteredCategories = typeFilter != null
            ? categories.where((c) => c.type == typeFilter).toList()
            : categories;
        
        if (filteredCategories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  'No categories available',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                ),
                const SizedBox(height: 8),
                Text(
                  typeFilter != null ? 'Select "All" in Type filter' : 'Add categories in settings',
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                ),
              ],
            ),
          );
        }
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: filteredCategories.map((category) {
            final isSelected = selectedCategories.contains(category.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildFilterOption(
                title: category.name,
                subtitle: category.type == 'income' ? 'Income category' : 'Expense category',
                icon: category.iconCodePoint != null 
                    ? IconData(category.iconCodePoint!, fontFamily: 'MaterialIcons')
                    : Icons.category,
                iconColor: category.colorValue != null ? Color(category.colorValue!) : null,
                isSelected: isSelected,
                onTap: () {
                  final updated = List<String>.from(selectedCategories);
                  if (isSelected) {
                    updated.remove(category.id);
                  } else {
                    updated.add(category.id);
                  }
                  ref.read(selectedCategoriesFilterProvider.notifier).state = updated;
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
  
  Widget _buildFilterOption({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1) 
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActiveFilterChip({
    required String label,
    required IconData icon,
    Color? color,
    required VoidCallback onDeleted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDeleted,
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              Icons.close,
              size: 14,
              color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSummary(List transactions) {
    // Calculate filtered totals
    final filteredIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final filteredExpense = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final balance = filteredIncome - filteredExpense;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.08),
            Theme.of(context).primaryColor.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          // Income
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  FormatHelper.formatCurrency(filteredIncome),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 40,
            width: 1,
            color: Theme.of(context).dividerColor,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          
          // Expense
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_downward, size: 16, color: Colors.red.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Expense',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  FormatHelper.formatCurrency(filteredExpense),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 40,
            width: 1,
            color: Theme.of(context).dividerColor,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          
          // Balance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 16,
                      color: balance >= 0 ? Colors.blue.shade700 : Colors.orange.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Balance',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  FormatHelper.formatCurrency(balance.abs()),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: balance >= 0 ? Colors.blue.shade700 : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCustomDateRangePicker(WidgetRef ref, TransactionDateRange? dateRange) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date Range',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dateRange?.start ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      helpText: 'Select From Date',
                    );
                    if (picked != null) {
                      final endDate = dateRange?.end ?? picked;
                      ref.read(selectedDateRangeProvider.notifier).state = 
                          TransactionDateRange(picked, endDate);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                    ),
                    child: Text(
                      dateRange != null 
                          ? FormatHelper.formatShortDate(dateRange.start)
                          : 'Select date',
                      style: TextStyle(
                        fontSize: 14,
                        color: dateRange != null ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dateRange?.end ?? DateTime.now(),
                      firstDate: dateRange?.start ?? DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      helpText: 'Select To Date',
                    );
                    if (picked != null) {
                      final startDate = dateRange?.start ?? picked;
                      ref.read(selectedDateRangeProvider.notifier).state = 
                          TransactionDateRange(startDate, picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                    ),
                    child: Text(
                      dateRange != null 
                          ? FormatHelper.formatShortDate(dateRange.end)
                          : 'Select date',
                      style: TextStyle(
                        fontSize: 14,
                        color: dateRange != null ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (dateRange != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${FormatHelper.formatShortDate(dateRange.start)} to ${FormatHelper.formatShortDate(dateRange.end)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
