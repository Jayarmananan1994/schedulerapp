import 'package:hive/hive.dart';

part 'gym_package.g.dart';

@HiveType(typeId: 3)
class GymPackage extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int noOfSessions;
  @HiveField(2)
  final double cost;
  @HiveField(3)
  int noOfSessionsAvailable;
  @HiveField(4)
  String traineeId;

  GymPackage(
    this.id,
    this.noOfSessions,
    this.cost,
    this.noOfSessionsAvailable,
    this.traineeId,
  );

  Future<GymPackage> deductSession(int count) async {
    noOfSessionsAvailable -= count;
    await save();
    return this;
  }
}
