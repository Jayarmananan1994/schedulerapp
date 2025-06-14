import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';

class GoGymAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? text;
  const GoGymAvatar({super.key, this.imageUrl, this.text});

  @override
  Widget build(BuildContext context) {
    return (imageUrl != null)
        ? CircleAvatar(radius: 24, backgroundImage: AssetImage(imageUrl!))
        : CircleAvatar(
          radius: 24,
          backgroundColor: colorBlueTwo,
          child: Text(
            text!,
            style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
          ),
        );
  }
}
