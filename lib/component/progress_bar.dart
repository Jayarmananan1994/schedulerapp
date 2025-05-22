import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final BorderRadius borderRadius;
  const ProgressBar({
    super.key,
    required this.progress,
    this.height = 10.0,
    this.backgroundColor = const Color(0xFFE0E0E0), // Default grey
    this.progressColor = Colors.blue,
    this.borderRadius = BorderRadius.zero, // No border radius by default
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: height,
                width: width * safeProgress,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: borderRadius,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
