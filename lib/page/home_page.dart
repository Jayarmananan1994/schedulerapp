import 'package:flutter/material.dart';
import 'package:schedulerapp/page/client_list_screen.dart';
import 'package:schedulerapp/page/schedule_screen.dart';
import 'package:schedulerapp/page/staff_list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: [ScheduleScreen(), StaffListScreen(), ClientListScreen()],
      ),
      bottomNavigationBar: TabBar(
        controller: tabController,
        tabs: [
          Tab(icon: Icon(Icons.home), text: "Home"),
          Tab(icon: Icon(Icons.group), text: 'Trainers'),
          Tab(icon: Icon(Icons.badge), text: 'Clients'),
        ],
      ),
    );
  }
}
