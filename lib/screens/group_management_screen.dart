import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/group.dart';
import '../providers/group_provider.dart';
import '../providers/transaction_provider.dart';
import '../constants/design_system.dart';

class GroupManagementScreen extends ConsumerWidget {
  const GroupManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);
    final allTransactions = ref.watch(transactionsProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Groups',
          style: FinvixTypography.headlineMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditGroupDialog(context, ref),
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Padding(
                padding: FinvixSpacing.paddingXl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: FinvixSpacing.paddingXl,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: FinvixRadius.radiusXl,
                      ),
                      child: Icon(
                        Icons.folder_open,
                        size: 56,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: FinvixSpacing.xl),
                    Text(
                      'No groups yet',
                      style: FinvixTypography.headlineSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: FinvixSpacing.md),
                    Text(
                      'Create a group to organize your expenses',
                      style: FinvixTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: FinvixSpacing.md,
              vertical: FinvixSpacing.lg,
            ),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              final transactionsInGroup = allTransactions
                  .where((t) => t.groupId == group.id)
                  .toList();
              final totalAmount = transactionsInGroup.fold<double>(
                0.0,
                (sum, t) => sum + (t.type == 'expense' ? t.amount : 0),
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
                    radius: 24,
                    backgroundColor: group.colorValue != null
                        ? Color(group.colorValue!)
                        : Theme.of(context).colorScheme.primary,
                    child: Icon(
                      group.iconCodePoint != null
                          ? IconData(group.iconCodePoint!, fontFamily: 'MaterialIcons')
                          : Icons.folder,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    group.name,
                    style: FinvixTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (group.description != null && group.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: FinvixSpacing.sm),
                          child: Text(
                            group.description!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '${transactionsInGroup.length} transactions • ₹${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showAddEditGroupDialog(
                          context,
                          ref,
                          group: group,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: Colors.red,
                        onPressed: () => _confirmDeleteGroup(
                          context,
                          ref,
                          group,
                          transactionsInGroup.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  void _showAddEditGroupDialog(
    BuildContext context,
    WidgetRef ref, {
    ExpenseGroup? group,
  }) {
    final nameController = TextEditingController(text: group?.name ?? '');
    final descriptionController = TextEditingController(text: group?.description ?? '');
    Color selectedColor = group?.colorValue != null
        ? Color(group!.colorValue!)
        : Colors.blue;
    IconData selectedIcon = group?.iconCodePoint != null
        ? IconData(group!.iconCodePoint!, fontFamily: 'MaterialIcons')
        : Icons.folder;
    bool showAllIcons = false;
    bool showAllColors = false;

    final availableIcons = [
      Icons.folder,
      Icons.work,
      Icons.travel_explore,
      Icons.home,
      Icons.school,
      Icons.medical_services,
      Icons.sports_esports,
      Icons.shopping_bag,
      Icons.restaurant,
      Icons.directions_car,
      Icons.flight,
      Icons.hotel,
      Icons.beach_access,
      Icons.fitness_center,
      Icons.pets,
      Icons.child_care,
      Icons.airplane_ticket,
      Icons.celebration,
      Icons.volunteer_activism,
      Icons.account_balance,
      Icons.business_center,
    ];

    final availableColors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
    ];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(group == null ? 'Create Group' : 'Edit Group'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon & Color Selection in a Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Selection
                    InkWell(
                      onTap: () {
                        setDialogState(() {
                          showAllIcons = !showAllIcons;
                          showAllColors = false;
                        });
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(selectedIcon, color: selectedColor, size: 30),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Color Selection
                    InkWell(
                      onTap: () {
                        setDialogState(() {
                          showAllColors = !showAllColors;
                          showAllIcons = false;
                        });
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (showAllIcons) ...[
                  const SizedBox(height: 8),
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: availableIcons.length,
                      itemBuilder: (context, index) {
                        final icon = availableIcons[index];
                        final isSelected = selectedIcon == icon;
                        return InkWell(
                          onTap: () {
                            setDialogState(() {
                              selectedIcon = icon;
                              showAllIcons = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? selectedColor.withOpacity(0.2) : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? selectedColor : Theme.of(context).colorScheme.outline,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              icon,
                              color: isSelected ? selectedColor : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                if (showAllColors) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableColors.map((color) {
                      final isSelected = selectedColor == color;
                      return InkWell(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                            showAllColors = false;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a group name')),
                  );
                  return;
                }

                final newGroup = ExpenseGroup(
                  id: group?.id ?? const Uuid().v4(),
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                  colorValue: selectedColor.value,
                  iconCodePoint: selectedIcon.codePoint,
                  createdAt: group?.createdAt ?? DateTime.now(),
                );

                final repository = ref.read(groupRepositoryProvider);
                if (group == null) {
                  await repository.addGroup(newGroup);
                } else {
                  await repository.updateGroup(newGroup);
                }

                ref.invalidate(groupsProvider);

                if (!context.mounted) return;
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Group ${group == null ? 'created' : 'updated'} successfully',
                    ),
                  ),
                );
              },
              child: Text(group == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteGroup(
    BuildContext context,
    WidgetRef ref,
    ExpenseGroup group,
    int transactionCount,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
          transactionCount > 0
              ? 'This group has $transactionCount transaction(s). Deleting this group will not delete the transactions, but they will no longer be associated with any group.\n\nAre you sure you want to delete "${group.name}"?'
              : 'Are you sure you want to delete "${group.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final repository = ref.read(groupRepositoryProvider);
              await repository.deleteGroup(group.id);
              ref.invalidate(groupsProvider);

              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Group deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
