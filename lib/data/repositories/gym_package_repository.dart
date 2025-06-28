import 'package:schedulerapp/data/models/gym_package.dart';

abstract class GymPackageRepository {
  Future<void> init();
  Future<GymPackage> save(GymPackage package);
  GymPackage getPackageById(String id);
  Future<List<GymPackage>> getAllPackages();
  Future<void> updatePackage(GymPackage package);
}
