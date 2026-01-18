import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/format_helper.dart';
import '../providers/transaction_provider.dart';
import '../constants/design_system.dart';
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
      return Center(
        child: Padding(
          padding: FinvixSpacing.paddingXl,
          child: Column(
            children: [
              Container(
                padding: FinvixSpacing.paddingLg,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: FinvixRadius.radiusLg,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: FinvixSpacing.lg),
              Text(
                'No recent transactions',
                style: FinvixTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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

        return Container(
          margin: const EdgeInsets.only(bottom: FinvixSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: FinvixRadius.radiusLg,
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 0.5,
            ),
          ),
          child: ListTile(
            contentPadding: FinvixSpacing.paddingLg,
            leading: CircleAvatar(
              radius: 22,
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
              style: FinvixTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              FormatHelper.formatShortDate(transaction.date),
              style: FinvixTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${transaction.type == 'income' ? '+' : '-'} ${FormatHelper.formatCurrency(transaction.amount)}',
                  style: FinvixTypography.titleMedium.copyWith(
                    color: transaction.type == 'income' ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: FinvixSpacing.sm),
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
