import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/page/home_page.dart';
import 'package:schedulerapp/provider/staff_provider.dart';
import 'package:schedulerapp/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StaffProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Scheduler App',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
    );
  }
}
