import 'package:hive/hive.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/repositories/gym_package_repository.dart';

class HiveGymPackageRepository implements GymPackageRepository {
  late Box<GymPackage> _gymPackageBox;

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(GymPackageAdapter());
      _gymPackageBox = await Hive.openBox<GymPackage>('packageBox');
    }
  }

  @override
  GymPackage getPackageById(String id) {
    if (!_gymPackageBox.isOpen) {
      throw Exception('Gym package box is not open');
    }
    final package = _gymPackageBox.values.firstWhere(
      (pkg) => pkg.id == id,
      orElse: () => throw Exception('Gym package not found'),
    );
    return package;
  }

  @override
  Future<List<GymPackage>> getAllPackages() {
    if (!_gymPackageBox.isOpen) {
      throw Exception('Gym package box is not open');
    }
    return Future.value(_gymPackageBox.values.toList());
  }

  @override
  Future<void> updatePackage(GymPackage package) {
    return _gymPackageBox.put(package.id, package);
  }

  @override
  Future<GymPackage> save(GymPackage package) {
    if (!_gymPackageBox.isOpen) {
      throw Exception('Gym package box is not open');
    }
    return _gymPackageBox.put(package.id, package).then((_) => package);
  }
}
