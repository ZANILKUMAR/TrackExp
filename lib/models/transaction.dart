import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type; // 'income' or 'expense'

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String categoryId;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  late DateTime date;

  @HiveField(6)
  String? groupId; // Optional group association

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    this.notes,
    required this.date,
    this.groupId,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'categoryId': categoryId,
      'notes': notes,
      'date': date.toIso8601String(),
      'groupId': groupId,
    };
  }

  // Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      notes: json['notes'] as String?,
      date: DateTime.parse(json['date'] as String),
      groupId: json['groupId'] as String?,
    );
  }

  Transaction copyWith({
    String? id,
    String? type,
    double? amount,
    String? categoryId,
    String? notes,
    DateTime? date,
    String? groupId,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      groupId: groupId ?? this.groupId,
    );
  }
}
