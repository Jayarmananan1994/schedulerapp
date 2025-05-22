import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';

class ModalAppBar extends StatelessWidget {
  final String title;
  const ModalAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 52),
        padding: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: colorBlueTwo, fontSize: 16),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 70),
          ],
        ),
      ),
    );
  }
}
