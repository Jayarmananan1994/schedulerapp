import 'package:flutter/material.dart';

class TimeStampLabel extends StatefulWidget {
  final String timeLabel;
  const TimeStampLabel({super.key, required this.timeLabel});

  @override
  State<TimeStampLabel> createState() => _TimeStampLabelState();
}

class _TimeStampLabelState extends State<TimeStampLabel> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isSelected = !_isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          decoration: BoxDecoration(
            color:
                _isSelected
                    ? Colors.green[400]?.withOpacity(
                      0.8,
                    ) // Greyish-green when selected
                    : Colors.green[800],
            borderRadius: BorderRadius.circular(5.0),
            border:
                _isSelected
                    ? Border.all(color: Colors.green[700]!, width: 1)
                    : null,
            boxShadow:
                _isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),

          padding: EdgeInsets.all(5),
          child: Center(
            child: Text(
              widget.timeLabel,
              style: TextStyle(
                color: _isSelected ? Colors.grey[200] : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
