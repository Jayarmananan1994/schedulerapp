import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/progress_bar.dart';
import 'package:schedulerapp/constant.dart';

class NewDashboardScreen extends StatelessWidget {
  const NewDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Dashboard',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: colorblack,
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.notifications_outlined, size: 24),
          onPressed: () {},
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
          slivers: [SliverFillRemaining(child: contentIos())],
        ),
      ),
    );
  }

  contentIos() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            clientNotificationList(),
            upcomingSessions(),
            groupclass(),
          ],
        ),
      ),
    );
  }

  dashboardTitle() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dashboard',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colorblack,
          ),
        ),
        IconButton(icon: Icon(Icons.notifications_outlined), onPressed: () {}),
      ],
    );
  }

  content() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              clientNotificationList(),
              upcomingSessions(),
              groupclass(),
            ],
          ),
        ),
      ),
    );
  }

  clientNotificationList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expiring Soon',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: colorblack,
                ),
              ),
              Text(
                '7 members',
                style: GoogleFonts.inter(fontSize: 14, color: colorgrey),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...clientList(),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See more',
                  style: GoogleFonts.inter(
                    color: colorBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: colorBlue,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> clientList() {
    return ["Andrew", "Yin", "Mahat", "Fiona"]
        .map(
          (client) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((255.0 * 0.5).round()),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: CupertinoListTile(
                leadingSize: 48,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/trainee1.png'),
                  // backgroundColor: colorBlueTwo,
                  // child: Text(
                  //   client[0],
                  //   style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
                  // ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    client,
                    style: GoogleFonts.inter(
                      color: colorblack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Personal training',
                    style: GoogleFonts.inter(color: colorgrey, fontSize: 14),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _warningText(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Notify',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  _warningText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0XFFF59E0B)),
          Text(
            '1s',
            style: GoogleFonts.inter(color: Color(0XFFF59E0B), fontSize: 14),
          ),
        ],
      ),
    );
  }

  upcomingSessions() {
    var sessions = [
      {
        'time': '10:00 AM',
        "sessionTitle": 'Group Session',
        "sessionSubtitle": 'with Alex Foster',
      },
      {
        'time': '12:00 PM',
        "sessionTitle": 'Group Session',
        "sessionSubtitle": 'with Maria H',
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Sessions',
          style: GoogleFonts.inter(
            color: colorblack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 168,

          child: ListView.separated(
            itemCount: sessions.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 280,
                height: 166,
                // padding: EdgeInsets.all(16),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.schedule_outlined, color: colorBlue),
                                SizedBox(width: 5),
                                Text(
                                  sessions[index]['time']!,
                                  style: GoogleFonts.inter(
                                    color: colorblack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: colorGreenLight,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Confirmed',
                                style: GoogleFonts.inter(
                                  color: colorgreen,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sessions[index]['sessionTitle']!,
                              style: GoogleFonts.inter(
                                color: colorblack,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              sessions[index]['sessionSubtitle']!,
                              style: GoogleFonts.inter(
                                color: colorgrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

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
                                          "+2",
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
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_horiz_outlined,
                                color: colorBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 16),
          ),
        ),
      ],
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
