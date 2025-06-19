import 'package:flutter/cupertino.dart';
import 'package:schedulerapp/page/dashboard/new_dashboard_screen.dart';
import 'package:schedulerapp/page/gym_management/gym_management_screen.dart';
import 'package:schedulerapp/page/payroll/staff_payroll_screen.dart';
import 'package:schedulerapp/page/schedule_screen.dart';
import 'package:schedulerapp/page/setting_screen/setting_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Key _tabAKey = UniqueKey();
  bool _shouldRefreshPayrollPage = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder:
          (context, index) => CupertinoTabView(
            builder: (context) {
              return getTabs()[index];
            },
          ),
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;
          if (index == 0 && _shouldRefreshPayrollPage) {
            _tabAKey = UniqueKey();
            _shouldRefreshPayrollPage = false;
          }
        },
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
            label: 'Gym Mngmnt',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  getTabs() {
    return [
      NewDashboardScreen(),
      ScheduleScreen(),
      StaffPayrollScreen(key: _tabAKey),
      GymManagementScreen(
        onTrainerUpdate: (isUpdated) {
          _shouldRefreshPayrollPage = isUpdated;
        },
        onTraineeUpdate: (isupdated) {
          _shouldRefreshPayrollPage = isupdated;
        },
      ),
      SettingScreen(),
    ];
  }
}
