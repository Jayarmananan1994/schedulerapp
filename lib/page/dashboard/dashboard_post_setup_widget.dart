import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/progress_bar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/page/dashboard/client_notification_list_widget.dart';
import 'package:schedulerapp/page/dashboard/upcoming_session.dart';

class DashboardPostSetupWidget extends StatelessWidget {
  const DashboardPostSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClientNotificationListWidget(),
            //upcomingSessions(),
            UpcomingSessionsWidget(),
            groupclass(),
          ],
        ),
      ),
    );
  }

  groupclass() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Group Classes',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          ...groupclassEntries(),
        ],
      ),
    );
  }

  groupclassEntries() {
    List<Map<String, Object>> entries = [
      {
        'className': 'HIIT Training',
        'schedue': 'Mon, Wed, Fri • 9:00 AM',
        'trainerName': 'John Smith',
        'totalspots': 12,
        'takenSpot': 8,
      },
      {
        'className': 'Yoga Flow',
        'schedue': 'Tue, Thu • 10:30 AM',
        'trainerName': 'Sarah Chen',
        'totalspots': 20,
        'takenSpot': 15,
      },
    ];
    return entries.map(
      (entry) => SizedBox(
        width: double.infinity,
        height: 165,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 12.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry['className'] as String,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          entry['schedue'] as String,
                          style: GoogleFonts.inter(
                            color: colorgrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircleAvatar(
                            child: Text((entry['trainerName'] as String)[0]),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          entry['trainerName'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: colorblack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //2nd row
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 90,
                      child: Stack(
                        //scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircleAvatar(child: Text("A")),
                          ),
                          Positioned(
                            left: 1 * 30 * 0.6,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircleAvatar(child: Text("A")),
                            ),
                          ),
                          Positioned(
                            left: 2 * 30 * 0.6,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircleAvatar(child: Text("A")),
                            ),
                          ),
                          Positioned(
                            left: 3 * 30 * 0.6,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircleAvatar(
                                backgroundColor: Color(0xffF3F4F6),
                                child: Text(
                                  "+ ${(entry['takenSpot'] as int) - 3}",
                                  style: GoogleFonts.inter(
                                    color: Color(0xff4B5563),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${entry['takenSpot']}/${entry['totalspots']} spots',
                      style: GoogleFonts.inter(
                        color: colorgrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  child: ProgressBar(
                    progress:
                        (entry['takenSpot'] as int) /
                        (entry['totalspots'] as int),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
