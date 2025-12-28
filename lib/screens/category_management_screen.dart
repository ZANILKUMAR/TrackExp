import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider).value ?? [];
    final expenseCategories = categories.where((c) => c.type == 'expense').toList();
    final incomeCategories = categories.where((c) => c.type == 'income').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expense', icon: Icon(Icons.arrow_downward)),
              Tab(text: 'Income', icon: Icon(Icons.arrow_upward)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CategoryList(categories: expenseCategories, type: 'expense'),
            _CategoryList(categories: incomeCategories, type: 'income'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddCategoryDialog(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const _AddEditCategoryDialog(),
    );
  }
}

class _CategoryList extends ConsumerWidget {
  final List<Category> categories;
  final String type;

  const _CategoryList({required this.categories, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              'No categories found',
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: category.colorValue != null
                  ? Color(category.colorValue!)
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              child: Icon(
                category.iconCodePoint != null
                    ? IconData(category.iconCodePoint!, fontFamily: 'MaterialIcons')
                    : Icons.category,
                color: Colors.white,
              ),
            ),
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditCategoryDialog(context, ref, category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCategory(context, ref, category),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => _AddEditCategoryDialog(category: category),
    );
  }

  void _deleteCategory(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(categoryNotifierProvider.notifier).deleteCategory(category.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Category deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _AddEditCategoryDialog extends ConsumerStatefulWidget {
  final Category? category;

  const _AddEditCategoryDialog({this.category});

  @override
  ConsumerState<_AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends ConsumerState<_AddEditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _type = 'expense';
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.category;

  final List<IconData> _availableIcons = [
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

  final List<Color> _availableColors = [
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

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _type = widget.category!.type;
      if (widget.category!.colorValue != null) {
        _selectedColor = Color(widget.category!.colorValue!);
      }
      if (widget.category!.iconCodePoint != null) {
        _selectedIcon = IconData(widget.category!.iconCodePoint!, fontFamily: 'MaterialIcons');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: widget.category?.id ?? const Uuid().v4(),
        name: _nameController.text,
        type: _type,
        colorValue: _selectedColor.value,
        iconCodePoint: _selectedIcon.codePoint,
      );

      if (widget.category != null) {
        ref.read(categoryNotifierProvider.notifier).updateCategory(category);
      } else {
        ref.read(categoryNotifierProvider.notifier).addCategory(category);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category ${widget.category != null ? 'updated' : 'added'} successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showAllIcons = false;
    bool showAllColors = false;

    return StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(widget.category != null ? 'Edit Category' : 'Add Category'),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon & Color Selection in a Row (at top)
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
                            color: _selectedColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor,
                              width: 2,
                            ),
                          ),
                          child: Icon(_selectedIcon, color: _selectedColor, size: 30),
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
                            color: _selectedColor,
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
                        itemCount: _availableIcons.length,
                        itemBuilder: (context, index) {
                          final icon = _availableIcons[index];
                          final isSelected = _selectedIcon == icon;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIcon = icon;
                              });
                              setDialogState(() {
                                showAllIcons = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? _selectedColor.withOpacity(0.2) : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? _selectedColor : Theme.of(context).colorScheme.outline,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                icon,
                                color: isSelected ? _selectedColor : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                      children: _availableColors.map((color) {
                        final isSelected = _selectedColor == color;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                            setDialogState(() {
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
                  
                  // Category Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Type Selection
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'expense', child: Text('Expense')),
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _type = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _save,
            child: Text(widget.category != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }
}
