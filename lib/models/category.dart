import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String type; // 'income' or 'expense'

  @HiveField(3)
  int? colorValue; // Store color as int

  @HiveField(4)
  int? iconCodePoint; // Store icon as int

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.colorValue,
    this.iconCodePoint,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
    };
  }

  // Create from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      colorValue: json['colorValue'] as int?,
      iconCodePoint: json['iconCodePoint'] as int?,
    );
  }

  Category copyWith({
    String? id,
    String? name,
    String? type,
    int? colorValue,
    int? iconCodePoint,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
    );
  }
}
