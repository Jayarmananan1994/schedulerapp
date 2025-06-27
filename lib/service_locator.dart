import 'package:get_it/get_it.dart';
import 'package:schedulerapp/data/repositories/gym_package_repository.dart';
import 'package:schedulerapp/data/repositories/implementations/hive_gym_package_repository.dart';
import 'package:schedulerapp/data/repositories/implementations/hive_schedule_repository.dart';
import 'package:schedulerapp/data/repositories/implementations/hive_trainee_repository.dart';
import 'package:schedulerapp/data/repositories/implementations/hive_trainer_repository.dart';
import 'package:schedulerapp/data/repositories/schedule_repository.dart';
import 'package:schedulerapp/data/repositories/trainee_repository.dart';
import 'package:schedulerapp/data/repositories/trainer_repository.dart';
import 'package:schedulerapp/domain/service/schedule_service.dart';
import 'package:schedulerapp/domain/service/trainer_service.dart';
import 'package:schedulerapp/service/hive_storage_service.dart';
import 'package:schedulerapp/service/storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<StorageService>(HiveStorageService());
  getIt.registerSingleton<ScheduleRepository>(HiveScheduleRepository());
  getIt.registerSingleton<TraineeRepository>(HiveTraineeRepository());
  getIt.registerSingleton<TrainerRepository>(HiveTrainerRepository());
  getIt.registerSingleton<GymPackageRepository>(HiveGymPackageRepository());
  getIt.registerLazySingleton<ScheduleService>(() => ScheduleService());
  getIt.registerLazySingleton<TrainerService>(
    () => TrainerService(getIt<TrainerRepository>()),
  );

  await getIt<TraineeRepository>().init();
  await getIt<TrainerRepository>().init();
  await getIt<ScheduleRepository>().init();
  await getIt<GymPackageRepository>().init();
  await getIt<StorageService>().init();
}
