import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 2)
class ExpenseGroup extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  int? colorValue; // Store color as int

  @HiveField(4)
  int? iconCodePoint; // Store icon as int

  @HiveField(5)
  late DateTime createdAt;

  ExpenseGroup({
    required this.id,
    required this.name,
    this.description,
    this.colorValue,
    this.iconCodePoint,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory ExpenseGroup.fromJson(Map<String, dynamic> json) {
    return ExpenseGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      colorValue: json['colorValue'] as int?,
      iconCodePoint: json['iconCodePoint'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  ExpenseGroup copyWith({
    String? id,
    String? name,
    String? description,
    int? colorValue,
    int? iconCodePoint,
    DateTime? createdAt,
  }) {
    return ExpenseGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
