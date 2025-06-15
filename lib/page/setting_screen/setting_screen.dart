import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/page/setting_screen/delete_all_button_widget.dart';
import 'package:schedulerapp/page/setting_screen/delete_schedule_widget.dart';
import 'package:schedulerapp/page/setting_screen/delete_trainees_widget.dart';
import 'package:schedulerapp/page/setting_screen/delete_trainers_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Settings',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: colorblack,
            ),
          ),
        ),
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: SingleChildScrollView(child: _settingContent()),
            ),
          ],
        ),
      ),
    );
  }

  _settingContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Management',
            style: GoogleFonts.inter(fontSize: 13, color: colorgrey),
          ),
          SizedBox(height: 8),
          DeleteTraineesWidget(),
          DeleteTrainerWidget(),
          DeleteScheduleWidget(),
          SizedBox(height: 24),
          Text(
            'Danger Zone',
            style: GoogleFonts.inter(fontSize: 13, color: colorRed),
          ),
          SizedBox(height: 8),
          DeleteAllButtonWidget(),
        ],
      ),
    );
  }
}
