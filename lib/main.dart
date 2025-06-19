import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/app/scheduler_app.dart';
import 'package:schedulerapp/provider/trainer_provider.dart';
import 'package:schedulerapp/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TrainerProvider())],
      child: const SchedulerApp(),
    ),
  );
}
