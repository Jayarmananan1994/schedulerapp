import 'package:schedulerapp/data/models/gym_package.dart';

abstract class GymPackageRepository {
  Future<void> init();
  GymPackage getPackageById(String id);
  Future<List<GymPackage>> getAllPackages();
}
