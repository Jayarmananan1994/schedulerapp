import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/page/setting_screen/delete_all_button_widget.dart';

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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border.all(color: colorGrayBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clear Trainee List',
                  style: GoogleFonts.inter(fontSize: 17, color: colorblack),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: colorgrey),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colorGrayBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clear Trainer List',
                  style: GoogleFonts.inter(fontSize: 17, color: colorblack),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: colorgrey),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(color: colorGrayBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clear Schedules',
                  style: GoogleFonts.inter(fontSize: 17, color: colorblack),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: colorgrey),
              ],
            ),
          ),
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
