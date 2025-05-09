import 'package:flutter/material.dart';

class ModalAppBar extends StatelessWidget {
  final String title;
  const ModalAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.only(top: 52),
        padding: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 50),
            const Text(
              'Trainer Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
