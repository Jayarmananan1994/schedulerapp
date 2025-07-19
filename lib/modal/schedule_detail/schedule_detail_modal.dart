import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/component/gogym_avatar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';
import 'package:schedulerapp/provider/schedule_provider.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class SchdeuleDetailModal extends StatelessWidget {
  final ScheduleDto scheduleDto;
  const SchdeuleDetailModal({super.key, required this.scheduleDto});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        middle: Text(
          'Session Details',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: scheduleDetailContentIos(scheduleDto, context),
            ),
          ],
        ),
      ),
    );
  }

  scheduleDetailContentIos(ScheduleDto scheduleDto, context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sessionTitle(context),
          _sessionTime(),
          _sessionLocation(),
          _trainerDetail(),
          _traineeDetail(),
          _cancelButton(context),
        ],
      ),
    );
  }

  _sessionTitle(context) {
    String statusText;
    Color bgColor;
    Color textColor;

    if (scheduleDto.isCancelled) {
      statusText = 'Cancelled';
      bgColor = Colors.red[50]!;
      textColor = colorRed;
    } else {
      bool isUpcoming = scheduleDto.startTime.isAfter(DateTime.now());
      statusText = isUpcoming ? 'Upcoming' : 'Completed';
      bgColor = isUpcoming ? colorGreenShadow : Colors.grey[100]!;
      textColor = isUpcoming ? colorgreen : Colors.grey;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                scheduleDto.title,
                style: GoogleFonts.inter(fontSize: 24),
                softWrap: true,
              ),
            ),
            // IconButton(
            //   onPressed: () => _showEditTitleDialog(context),
            //   icon: Icon(Icons.edit, color: colorBlueTwo),
            // ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: bgColor, width: 1),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  _sessionTime() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: colorgrey),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(scheduleDto.startTime),
                style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
              ),
              Text(
                '${DateFormat('h:mm a').format(scheduleDto.startTime)} - ${DateFormat('h:mm a').format(scheduleDto.endTime)}',
                style: GoogleFonts.inter(fontSize: 16, color: colorGreyTwo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _sessionLocation() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Icon(Icons.location_on, color: colorgrey),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              scheduleDto.location == null || scheduleDto.location!.isEmpty
                  ? 'No location specified'
                  : scheduleDto.location!,
              style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  _trainerDetail() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trainer Details',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: colorblack,
              fontWeight: FontWeight.w500,
            ),
          ),
          // SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorShadowGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GoGymAvatar(
                      imageUrl: scheduleDto.trainer.imageUrl,
                      text:
                          scheduleDto.trainer.name
                              .substring(0, 1)
                              .toUpperCase(),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheduleDto.trainer.name,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          scheduleDto.trainer.role,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: colorGreyTwo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorBlueTwo),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Change Trainer',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: colorBlueTwo,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _traineeDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trainee Details',
          style: GoogleFonts.inter(
            fontSize: 18,
            color: colorblack,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          //margin: EdgeInsets.symmetric(vertical: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorShadowGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GoGymAvatar(
                    imageUrl: scheduleDto.trainee.imageUrl,
                    text:
                        scheduleDto.trainer.name.substring(0, 1).toUpperCase(),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheduleDto.trainee.name,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  _cancelButton(context) {
    bool isUpcoming = scheduleDto.startTime.isAfter(DateTime.now());
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed:
            isUpcoming && !scheduleDto.isCancelled
                ? () => handleCancelSession(context, scheduleDto)
                : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color:
                isUpcoming && !scheduleDto.isCancelled
                    ? colorRed
                    : colorGreyTwo,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          'Cancel Session',
          style: GoogleFonts.inter(
            fontSize: 16,
            color:
                isUpcoming && !scheduleDto.isCancelled
                    ? colorRed
                    : colorGreyTwo,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  handleCancelSession(context, ScheduleDto scheduleDto) async {
    bool isConfirmed = await showAppConfirmationDialog(
      context,
      'Confirmation',
      'Are you sure you want to cancel this session? This action cannot be undone.',
    );
    if (isConfirmed) {
      Provider.of<ScheduleProvider>(
        context,
        listen: false,
      ).cancelSchedule(scheduleDto.id);
      Navigator.pop(context);
    }
  }
}
