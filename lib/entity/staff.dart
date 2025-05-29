import 'package:hive/hive.dart';

part 'staff.g.dart';

@HiveType(typeId: 1)
class Staff extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? imageUrl;
  @HiveField(3)
  final double payRate;
  @HiveField(4)
  final String? role;

  Staff({
    required this.id,
    required this.name,
    required this.payRate,
    this.imageUrl,
    this.role,
  });

  @override
  String toString() {
    return 'Staff(id: $id, name: $name, imageUrl: $imageUrl, payRate: $payRate, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! Staff) return false;

    return id == other.id &&
        name == other.name &&
        imageUrl == other.imageUrl &&
        payRate == other.payRate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imageUrl.hashCode ^ payRate.hashCode;
  }
}
