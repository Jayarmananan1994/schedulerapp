import 'package:get_it/get_it.dart';
import 'package:schedulerapp/service/hive_storage_service.dart';
import 'package:schedulerapp/service/storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<StorageService>(HiveStorageService());
  await getIt<StorageService>().init();
}
