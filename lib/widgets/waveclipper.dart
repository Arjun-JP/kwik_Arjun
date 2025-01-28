import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class WaveclipperWidget extends StatelessWidget {
  const WaveclipperWidget({super.key, required this.image});

  final String image;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradient1black, AppColors.gradient2orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // color: Colors.red,
        width: devicewidth,
        height: deviceheight * 0.7,
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);

    path.quadraticBezierTo(
      size.width * 0.25, size.height - 50, // First control point
      size.width * 0.5, size.height - 80, // First end point
    );

    path.quadraticBezierTo(
      size.width * 0.75, size.height - 110, // Second control point
      size.width, size.height - 80, // Second end point
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
