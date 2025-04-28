import 'package:flutter/material.dart';
import 'package:schedulerapp/page/home_page.dart';
import 'package:schedulerapp/page/home_page_old.dart';
import 'package:schedulerapp/page/schedule_page.dart';
import 'package:schedulerapp/page/schedule_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
