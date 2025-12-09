import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.watchCategories();
});

final expenseCategoriesProvider = Provider<List<Category>>((ref) {
  final categories = ref.watch(categoriesProvider).value ?? [];
  return categories.where((cat) => cat.type == 'expense').toList();
});

final incomeCategoriesProvider = Provider<List<Category>>((ref) {
  final categories = ref.watch(categoriesProvider).value ?? [];
  return categories.where((cat) => cat.type == 'income').toList();
});

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final CategoryRepository repository;

  CategoryNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadCategories();
  }

  void loadCategories() {
    state = AsyncValue.data(repository.getAllCategories());
  }

  Future<void> addCategory(Category category) async {
    await repository.addCategory(category);
    loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    await repository.updateCategory(category);
    loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await repository.deleteCategory(id);
    loadCategories();
  }
}

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});
