import 'package:hive_flutter/adapters.dart';

part 'trainee.g.dart';

@HiveType(typeId: 2)
class Trainee {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double feePerSession;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final int sessionsLeft;

  Trainee({
    required this.id,
    required this.name,
    required this.feePerSession,
    this.imageUrl,
    required this.sessionsLeft,
  });

  @override
  String toString() {
    return 'Trainee(id: $id, name: $name, payRate: $feePerSession, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! Trainee) return false;

    return id == other.id &&
        name == other.name &&
        feePerSession == other.feePerSession &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        feePerSession.hashCode ^
        imageUrl.hashCode;
  }
}
