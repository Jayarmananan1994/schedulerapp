import 'package:hive/hive.dart';

part 'trainer.g.dart';

@HiveType(typeId: 1)
class Trainer extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double payRate;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String role;

  Trainer(this.id, this.name, this.payRate, this.imageUrl, this.role);

  @override
  String toString() {
    return 'Trainer(id: $id, name: $name, payRate: $payRate, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Trainer) return false;
    return id == other.id &&
        name == other.name &&
        payRate == other.payRate &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        payRate.hashCode ^
        (imageUrl?.hashCode ?? 0);
  }
}
