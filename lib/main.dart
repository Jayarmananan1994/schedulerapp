import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:schedulerapp/app/scheduler_app.dart';
import 'package:schedulerapp/data/repositories/gym_package_repository.dart';
import 'package:schedulerapp/data/repositories/schedule_repository.dart';
import 'package:schedulerapp/data/repositories/trainee_repository.dart';
import 'package:schedulerapp/data/repositories/trainer_repository.dart';
import 'package:schedulerapp/domain/service/trainer_service.dart';
import 'package:schedulerapp/provider/payroll_provider.dart';
import 'package:schedulerapp/provider/schedule_provider.dart';
import 'package:schedulerapp/provider/trainer_provider.dart';
import 'package:schedulerapp/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dbDir.path);
  await setupServiceLocator();
  await Hive.initFlutter();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TrainerProvider(GetIt.I<TrainerRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ScheduleProvider(
                GetIt.I<ScheduleRepository>(),
                GetIt.I<TrainerRepository>(),
                GetIt.I<TraineeRepository>(),
                GetIt.I<GymPackageRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PayrollProvider(
                context.read<ScheduleProvider>(),
                GetIt.I<TrainerService>(),
              ),
        ),
      ],
      child: const SchedulerApp(),
    ),
  );
}
