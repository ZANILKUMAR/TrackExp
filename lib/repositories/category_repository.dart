import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';

class CategoryRepository {
  final Box<Category> _box = Hive.box<Category>('categories');

  // Get all categories
  List<Category> getAllCategories() {
    return _box.values.toList();
  }

  // Get categories by type
  List<Category> getCategoriesByType(String type) {
    return _box.values.where((cat) => cat.type == type).toList();
  }

  // Get category by id
  Category? getCategoryById(String id) {
    return _box.get(id);
  }

  // Add category
  Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
  }

  // Update category
  Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
  }

  // Delete category
  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }

  // Check if category has transactions
  bool hasTransactions(String categoryId) {
    final transactionsBox = Hive.box('transactions');
    return transactionsBox.values.any((t) => t.categoryId == categoryId);
  }

  // Watch categories
  Stream<List<Category>> watchCategories() async* {
    // Emit current data immediately
    yield getAllCategories();
    // Then emit updates
    await for (final _ in _box.watch()) {
      yield getAllCategories();
    }
  }
}
