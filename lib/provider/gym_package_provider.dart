import 'package:flutter/foundation.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/repositories/gym_package_repository.dart';

class GymPackageProvider with ChangeNotifier {
  final GymPackageRepository _gymPackageRepository;
  List<GymPackage>? _gymPackages;
  bool _isLoading = false;
  String? _error;

  List<GymPackage>? get gymPackages => _gymPackages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  GymPackageProvider(this._gymPackageRepository) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _gymPackages = await _gymPackageRepository.getAllPackages();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void deductPackageAvailability(GymPackage? package, int count) async {
    if (package != null && package.noOfSessionsAvailable > 0) {
      package.noOfSessionsAvailable -= count;
      print(
        'Updating package: ${package.id} with new availability: ${package.noOfSessionsAvailable}',
      );
      await _gymPackageRepository.updatePackage(package);
      notifyListeners();
    } else {
      throw Exception('No available sessions left for this package: $package');
    }
  }

  Future<void> saveGymPackage(
    String packageName,
    int sessionPurchased,
    double price,
    String id,
  ) async {
    final package = GymPackage(
      UniqueKey().toString(),
      packageName,
      sessionPurchased,
      price,
      sessionPurchased,
      id,
    );
    await _gymPackageRepository.save(package);
  }

  // Future<void> addGymPackage(GymPackage gymPackage) async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();
  //     await _gymPackageRepository.addPackage(gymPackage);
  //     _gymPackages?.add(gymPackage);
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
