import 'package:flutter/material.dart';

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
      appBar: AppBar(
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.verified_user), text: "Clients"),
            Tab(icon: Icon(Icons.verified_user_outlined), text: 'Staff'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Text('First screen'),
          Center(child: Text('Second screen')),
          Center(child: Text('Third screen')),
        ],
      ),
    );
  }
}
