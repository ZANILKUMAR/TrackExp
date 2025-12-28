import 'package:hive_flutter/hive_flutter.dart';
import '../models/group.dart';

class GroupRepository {
  final Box<ExpenseGroup> _box = Hive.box<ExpenseGroup>('groups');

  // Get all groups
  List<ExpenseGroup> getAllGroups() {
    return _box.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get group by id
  ExpenseGroup? getGroupById(String id) {
    return _box.get(id);
  }

  // Add group
  Future<void> addGroup(ExpenseGroup group) async {
    await _box.put(group.id, group);
  }

  // Update group
  Future<void> updateGroup(ExpenseGroup group) async {
    await _box.put(group.id, group);
  }

  // Delete group
  Future<void> deleteGroup(String id) async {
    await _box.delete(id);
  }

  // Watch groups
  Stream<List<ExpenseGroup>> watchGroups() {
    return Stream<List<ExpenseGroup>>.multi((controller) {
      List<String> lastIds = [];
      
      void emitIfChanged() {
        if (!controller.isClosed) {
          final current = getAllGroups();
          final currentIds = current.map((g) => g.id).toList()..sort();
          final lastIdsSorted = List<String>.from(lastIds)..sort();
          
          // Only emit if the group list has actually changed
          if (currentIds.length != lastIdsSorted.length ||
              !_listsEqual(currentIds, lastIdsSorted)) {
            lastIds = currentIds;
            controller.add(current);
          }
        }
      }
      
      // Emit current data immediately
      final initial = getAllGroups();
      lastIds = initial.map((g) => g.id).toList();
      controller.add(initial);
      
      // Listen to box changes and emit updates
      final subscription = _box.watch().listen((_) {
        emitIfChanged();
      });
      
      // Add periodic check as fallback for mobile platforms (every 2 seconds)
      final timer = Stream.periodic(const Duration(seconds: 2)).listen((_) {
        emitIfChanged();
      });
      
      controller.onCancel = () {
        subscription.cancel();
        timer.cancel();
      };
    });
  }
  
  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
