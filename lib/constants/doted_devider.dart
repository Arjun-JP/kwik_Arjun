import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DottedDivider({
    Key? key,
    this.height = 1,
    this.color = Colors.blueGrey,
    this.dashWidth = 5,
    this.dashSpace = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter:
          DashPainter(color: color, dashWidth: dashWidth, dashSpace: dashSpace),
    );
  }
}

class DashPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashPainter({required this.color, this.dashWidth = 5, this.dashSpace = 3});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
