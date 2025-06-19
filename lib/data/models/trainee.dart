import 'package:hive/hive.dart';

part 'trainee.g.dart';

@HiveType(typeId: 2)
class Trainee extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final double feePerSession;

  Trainee(this.id, this.name, this.imageUrl, this.feePerSession);

  @override
  String toString() {
    return 'Trainee(id: $id, name: $name, imageUrl: $imageUrl, feePerSession: $feePerSession)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Trainee) return false;
    return id == other.id && name == other.name && imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ (imageUrl?.hashCode ?? 0);
  }
}
