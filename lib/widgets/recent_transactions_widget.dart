import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/format_helper.dart';
import '../providers/transaction_provider.dart';
import '../screens/add_transaction_screen.dart';

class RecentTransactionsWidget extends ConsumerWidget {
  final List<Transaction> transactions;
  final List<Category> categories;

  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No recent transactions'),
        ),
      );
    }

    return Column(
      children: transactions.map((transaction) {
        final category = categories.firstWhere(
          (c) => c.id == transaction.categoryId,
          orElse: () => Category(
            id: 'unknown',
            name: 'Unknown',
            type: transaction.type,
          ),
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: category.colorValue != null
                  ? Color(category.colorValue!)
                  : (transaction.type == 'income' ? Colors.green : Colors.red),
              child: Icon(
                transaction.type == 'income'
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(FormatHelper.formatShortDate(transaction.date)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${transaction.type == 'income' ? '+' : '-'} ${FormatHelper.formatCurrency(transaction.amount)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == 'income' ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
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
        );
      }).toList(),
    );
  }
}
