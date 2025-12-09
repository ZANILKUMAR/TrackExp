import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../utils/format_helper.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _amountFocusNode = FocusNode();
  
  String _type = 'expense';
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _type = widget.transaction!.type;
      _amountController.text = widget.transaction!.amount.toString();
      _notesController.text = widget.transaction!.notes ?? '';
      _selectedCategoryId = widget.transaction!.categoryId;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction({bool closeAfterSave = true}) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final transaction = Transaction(
        id: widget.transaction?.id ?? const Uuid().v4(),
        type: _type,
        amount: double.parse(_amountController.text),
        categoryId: _selectedCategoryId!,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        date: _selectedDate,
      );

      // Save directly to repository to trigger stream updates
      final repository = ref.read(transactionRepositoryProvider);
      if (widget.transaction != null) {
        await repository.updateTransaction(transaction);
      } else {
        await repository.addTransaction(transaction);
      }

      if (!mounted) return;
      
      if (closeAfterSave) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction ${widget.transaction != null ? 'updated' : 'added'} successfully')),
        );
      } else {
        // Keep the screen open and reset only amount and notes
        // Keep category and date for the next transaction
        setState(() {
          _amountController.clear();
          _notesController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction added! Add another one.'),
            duration: Duration(seconds: 2),
          ),
        );
        
        // Set focus back to amount field for quick entry
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _amountFocusNode.requestFocus();
          }
        });
      }
    }
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;
    IconData selectedIcon = Icons.category;
    bool showAllIcons = false;
    bool showAllColors = false;

    final availableIcons = [
      Icons.shopping_cart,
      Icons.restaurant,
      Icons.local_cafe,
      Icons.fastfood,
      Icons.home,
      Icons.electric_bolt,
      Icons.water_drop,
      Icons.wifi,
      Icons.phone_android,
      Icons.directions_car,
      Icons.local_gas_station,
      Icons.train,
      Icons.local_hospital,
      Icons.medical_services,
      Icons.school,
      Icons.book,
      Icons.sports_esports,
      Icons.movie,
      Icons.theater_comedy,
      Icons.fitness_center,
      Icons.checkroom,
      Icons.watch,
      Icons.card_giftcard,
      Icons.volunteer_activism,
      Icons.pets,
      Icons.child_care,
      Icons.airplane_ticket,
      Icons.hotel,
      Icons.business,
      Icons.work,
      Icons.attach_money,
      Icons.account_balance,
      Icons.savings,
      Icons.trending_up,
      Icons.payment,
      Icons.subscriptions,
      Icons.category,
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
          title: const Text('Add Category'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon & Color Selection in a Row
                Row(
                  children: [
                    // Icon Selection
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setDialogState(() {
                            showAllIcons = !showAllIcons;
                            showAllColors = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: selectedColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(selectedIcon, color: selectedColor, size: 24),
                              ),
                              const SizedBox(width: 8),
                              Icon(showAllIcons ? Icons.expand_less : Icons.expand_more, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Color Selection
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setDialogState(() {
                            showAllColors = !showAllColors;
                            showAllIcons = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: selectedColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(showAllColors ? Icons.expand_less : Icons.expand_more, size: 18),
                            ],
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
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
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
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a category name')),
                  );
                  return;
                }

                final newCategory = Category(
                  id: const Uuid().v4(),
                  name: nameController.text.trim(),
                  type: _type,
                  colorValue: selectedColor.value,
                  iconCodePoint: selectedIcon.codePoint,
                );

                ref.read(categoryNotifierProvider.notifier).addCategory(newCategory);
                
                Navigator.pop(dialogContext);
                
                // Auto-select the newly created category
                setState(() {
                  _selectedCategoryId = newCategory.id;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category added successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value ?? [];
    final filteredCategories = categories.where((cat) => cat.type == _type).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction != null ? 'Edit Transaction' : 'Add Transaction'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type Selection
            const Text(
              'Transaction Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'expense',
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: 'income',
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _type = newSelection.first;
                  _selectedCategoryId = null; // Reset category when type changes
                });
              },
            ),
            const SizedBox(height: 24),

            // Amount
            TextFormField(
              controller: _amountController,
              focusNode: _amountFocusNode,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                hintText: '0.00',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                final amount = double.parse(value);
                if (amount <= 0) {
                  return 'Amount must be greater than 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Select a category'),
                    isExpanded: true,
                    items: filteredCategories.isEmpty
                        ? null
                        : filteredCategories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: category.colorValue != null
                                        ? Color(category.colorValue!)
                                        : Theme.of(context).colorScheme.secondary,
                                    child: Icon(
                                      category.iconCodePoint != null
                                          ? IconData(category.iconCodePoint!, fontFamily: 'MaterialIcons')
                                          : Icons.category,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(category.name),
                                ],
                              ),
                            );
                          }).toList(),
                    onChanged: filteredCategories.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showAddCategoryDialog(context, ref),
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add Category',
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date
            ListTile(
              title: const Text('Date'),
              subtitle: Text(FormatHelper.formatDate(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Save Buttons
            if (widget.transaction == null) ...[
              // Only show "Save & Add Another" for new transactions, not when editing
              ElevatedButton.icon(
                onPressed: () => _saveTransaction(closeAfterSave: false),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Save & Add Another'),
              ),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: () => _saveTransaction(closeAfterSave: true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(widget.transaction != null ? 'Update Transaction' : 'Save & Close'),
            ),
          ],
        ),
      ),
    );
  }
}
