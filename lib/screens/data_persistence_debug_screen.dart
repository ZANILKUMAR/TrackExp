import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/category.dart';

/// Debug screen to verify data persistence
class DataPersistenceDebugScreen extends ConsumerWidget {
  const DataPersistenceDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsBox = Hive.box<Transaction>('transactions');
    final categoriesBox = Hive.box<Category>('categories');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Persistence Debug'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Storage Status',
              [
                _buildInfoRow('Hive Initialized', '${Hive.isBoxOpen('transactions')}'),
                _buildInfoRow('Transactions Box Open', '${transactionsBox.isOpen}'),
                _buildInfoRow('Categories Box Open', '${categoriesBox.isOpen}'),
                _buildInfoRow('Transactions Count', '${transactionsBox.length}'),
                _buildInfoRow('Categories Count', '${categoriesBox.length}'),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Transaction Data',
              transactionsBox.values.isEmpty
                  ? [const Text('No transactions stored')]
                  : transactionsBox.values.map((t) {
                      return Card(
                        child: ListTile(
                          title: Text(t.notes ?? 'No notes'),
                          subtitle: Text('₹${t.amount.toStringAsFixed(2)} - ${t.date}'),
                          trailing: Text(t.type),
                        ),
                      );
                    }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Category Data',
              categoriesBox.values.isEmpty
                  ? [const Text('No categories stored')]
                  : categoriesBox.values.map((c) {
                      return Card(
                        child: ListTile(
                          leading: c.iconCodePoint != null
                              ? Icon(
                                  IconData(c.iconCodePoint!, fontFamily: 'MaterialIcons'),
                                  color: c.colorValue != null ? Color(c.colorValue!) : null,
                                )
                              : null,
                          title: Text(c.name),
                          trailing: Text(c.type),
                        ),
                      );
                    }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                // Add test transaction
                final testTransaction = Transaction(
                  id: 'test_${DateTime.now().millisecondsSinceEpoch}',
                  type: 'expense',
                  categoryId: 'exp_1',
                  amount: 100.0,
                  date: DateTime.now(),
                  notes: 'Persistence Test Transaction',
                );
                await transactionsBox.put(testTransaction.id, testTransaction);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test transaction added! Restart app to verify persistence.')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Test Transaction'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final keys = transactionsBox.keys.toList();
                if (keys.isNotEmpty) {
                  await transactionsBox.delete(keys.last);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Last transaction deleted')),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete Last Transaction'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
