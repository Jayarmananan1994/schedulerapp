import 'package:flutter/cupertino.dart';
import 'package:schedulerapp/page/dashboard/new_dashboard_screen.dart';
import 'package:schedulerapp/page/gym_management/gym_management_screen.dart';
import 'package:schedulerapp/page/payroll/staff_payroll_screen.dart';
import 'package:schedulerapp/page/schedule_screen.dart';
import 'package:schedulerapp/page/setting_screen/setting_screen.dart';

class HomePage extends StatelessWidget {
  final List<Widget> tabs = [
    NewDashboardScreen(),
    ScheduleScreen(),
    StaffPayrollScreen(),
    GymManagementScreen(),
    SettingScreen(),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder:
          (context, index) => CupertinoTabView(
            builder: (context) {
              return tabs[index];
            },
          ),
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.rectangle_grid_2x2),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar),
            label: 'Payroll',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            // label: 'Gym Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            // label: 'Gym Management',
          ),
        ],
      ),
    );
  }
}
