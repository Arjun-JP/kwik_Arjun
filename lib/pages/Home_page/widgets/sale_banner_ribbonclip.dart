import 'dart:ui';

import 'package:flutter/material.dart';

class RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double notchSize = size.height / 2;

    Path path = Path()
      ..moveTo(0, 0) // Top-left corner
      ..lineTo(size.width, 0) // Top-right corner
      ..lineTo(size.width - notchSize, size.height / 2) // Right inward notch
      ..lineTo(size.width, size.height) // Bottom-right corner
      ..lineTo(0, size.height) // Bottom-left corner
      ..lineTo(notchSize, size.height / 2) // Left inward notch
      ..close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
