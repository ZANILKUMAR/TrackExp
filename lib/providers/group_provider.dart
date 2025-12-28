import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../repositories/group_repository.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository();
});

final groupsProvider = StreamProvider<List<ExpenseGroup>>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return repository.watchGroups();
});

class GroupNotifier extends StateNotifier<AsyncValue<List<ExpenseGroup>>> {
  final GroupRepository repository;

  GroupNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadGroups();
  }

  void loadGroups() {
    state = AsyncValue.data(repository.getAllGroups());
  }

  Future<void> addGroup(ExpenseGroup group) async {
    await repository.addGroup(group);
    // Force reload and notify listeners
    state = AsyncValue.data(repository.getAllGroups());
  }

  Future<void> updateGroup(ExpenseGroup group) async {
    await repository.updateGroup(group);
    // Force reload and notify listeners
    state = AsyncValue.data(repository.getAllGroups());
  }

  Future<void> deleteGroup(String id) async {
    await repository.deleteGroup(id);
    // Force reload and notify listeners
    state = AsyncValue.data(repository.getAllGroups());
  }
}

final groupNotifierProvider =
    StateNotifierProvider<GroupNotifier, AsyncValue<List<ExpenseGroup>>>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return GroupNotifier(repository);
});
