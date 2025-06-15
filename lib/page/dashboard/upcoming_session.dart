import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/gogym_avatar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/entity/upcoming_session.dart';
import 'package:schedulerapp/service/storage_service.dart';

class UpcomingSessionsWidget extends StatelessWidget {
  final StorageService _storageService = GetIt.I<StorageService>();
  UpcomingSessionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<UpcomingSession> sessions = _storageService.getAllUpcomingSchedule();
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
                                  sessions[index].scheduleTime,
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
                              sessions[index].title,
                              style: GoogleFonts.inter(
                                color: colorblack,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              sessions[index].subTitle,
                              style: GoogleFonts.inter(
                                color: colorgrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        _participantsAvartar(sessions[index].participants),
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

  _participantsAvartar(List<String> participantsName) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 30,
          width: 90,
          child: Stack(
            children:
                participantsName.length > 3
                    ? _participantAvatarWithPlus(participantsName)
                    : _participantAvatarWithOutPlus(participantsName),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz_outlined, color: colorBlue),
        ),
      ],
    );
  }

  List<Widget> _participantAvatarWithOutPlus(List<String> particpants) {
    return particpants.mapIndexed((index, particpant) {
      return index == 0
          ? SizedBox(
            height: 30,
            width: 30,
            child: GoGymAvatar(
              imageUrl: particpants[0].length > 2 ? particpants[0] : null,
              text: particpant[0],
            ),
          )
          : Positioned(
            left: index * 30 * 0.6,
            child: SizedBox(
              height: 30,
              width: 30,
              child: GoGymAvatar(
                imageUrl: particpant.length > 2 ? particpant : null,
                text: particpant[0],
              ),
            ),
          );
    }).toList();
  }

  List<Widget> _participantAvatarWithPlus(List<String> particpants) {
    return [
      SizedBox(
        height: 30,
        width: 30,
        child: GoGymAvatar(
          imageUrl: particpants[0].length > 2 ? particpants[0] : null,
          text: particpants[0][0],
        ),
      ),
      Positioned(
        left: 1 * 30 * 0.6,
        child: SizedBox(
          height: 30,
          width: 30,
          child: GoGymAvatar(
            imageUrl: particpants[1].length > 2 ? particpants[1] : null,
            text: particpants[1][0],
          ),
        ),
      ),
      Positioned(
        left: 2 * 30 * 0.6,
        child: SizedBox(
          height: 30,
          width: 30,
          child: GoGymAvatar(
            imageUrl: particpants[2].length > 2 ? particpants[2] : null,
            text: particpants[2][0],
          ),
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
              "+${particpants.length - 3}",
              style: GoogleFonts.inter(
                color: Color(0xff4B5563),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
