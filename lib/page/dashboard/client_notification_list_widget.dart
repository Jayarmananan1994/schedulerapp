import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/gogym_avatar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/dto/expiring_client_session.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ClientNotificationListWidget extends StatelessWidget {
  final StorageService _storageService = GetIt.instance<StorageService>();
  ClientNotificationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<ExpiringClientSession> clientEntries =
        _storageService.fetchClientsWithExpiringSessions();
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
              clientEntries.isEmpty
                  ? Container()
                  : Text(
                    '${clientEntries.length} members',
                    style: GoogleFonts.inter(fontSize: 14, color: colorgrey),
                  ),
            ],
          ),
          SizedBox(height: 20),
          ...clientList(clientEntries),
          clientEntries.isEmpty
              ? Container()
              : TextButton(
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

  List<Widget> clientList(List<ExpiringClientSession> clientEntries) {
    // List<ExpiringClientSession> trainees =
    //     _storageService.fetchClientsWithExpiringSessions();
    if (clientEntries.isEmpty) {
      return [
        Text(
          textAlign: TextAlign.center,
          'Great news! No customer sessions are ending soon. Enjoy the calm!',
          style: GoogleFonts.inter(
            color: colorGreyTwo,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Image.asset('assets/images/chill_guy.png', height: 200, width: 150),
      ];
    }
    return clientEntries
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
                leading: GoGymAvatar(
                  imageUrl: client.trainee.imageUrl,
                  text: client.trainee.name[0],
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    client.trainee.name,
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
                    _warningText(client.gympackage.noOfSessionsAvailable),
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

  _warningText(noOfSession) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0XFFF59E0B)),
          Text(
            '${noOfSession}s',
            style: GoogleFonts.inter(color: Color(0XFFF59E0B), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
