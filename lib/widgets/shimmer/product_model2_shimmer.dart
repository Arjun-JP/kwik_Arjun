import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class ProductModel2Shimmer extends StatelessWidget {
  // final ProductModel product;

  const ProductModel2Shimmer({super.key, f});

  @override
  build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        width: 154,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shadowColor: const Color.fromARGB(255, 233, 233, 233),
              elevation: .1,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Container(
                      height: 58,
                      width: 154,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey, // Change color as needed
                            width: 2.0, // Change width as needed
                          ),
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.grey,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Shimmer(width: double.infinity, height: 15),
                            SizedBox(height: 5),
                            Shimmer(width: double.infinity, height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: SizedBox(
                      height: 164,
                      width: 143,
                      child: Stack(
                        children: [
                          const Shimmer(width: 143, height: 164),
                          Align(
                            alignment: const Alignment(-.8, .9),
                            child: ClipPath(
                              clipper: SmoothJaggedCircleClipper(),
                              child: Container(
                                width: 55,
                                height: 55,
                                color: Colors.grey,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Shimmer(width: 30, height: 12),
                                    SizedBox(height: 5),
                                    Shimmer(width: 30, height: 12),
                                  ],
                                ), // Match the color in your image
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10,
              ),
              child: SizedBox(
                  width: 154,
                  height: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer(width: double.infinity, height: 12),
                      SizedBox(height: 3),
                      Shimmer(width: double.infinity, height: 12),
                    ],
                  )),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10,
              ),
              child: Shimmer(width: 50, height: 12),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5,
              ),
              child: Shimmer(
                width: double.infinity,
                height: 30,
                borderRadius: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 10);

    double x = 0;
    double y = size.height - 10;
    double step = size.width / 10;

    for (int i = 0; i < 10; i++) {
      x += step;
      y = (i % 2 == 0) ? size.height : size.height - 10;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(ZigZagClipper oldClipper) => false;
}

class SmoothJaggedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double outerRadius = size.width / 2;
    double innerRadius = outerRadius * 0.85; // Adjust for smoothness
    int points = 20; // Number of spikes
    double angle = (2 * pi) / points;

    for (int i = 0; i < points; i++) {
      double startRadius = (i % 2 == 0) ? outerRadius : innerRadius;
      double endRadius = (i % 2 == 0) ? innerRadius : outerRadius;

      double startX = centerX + startRadius * cos(i * angle);
      double startY = centerY + startRadius * sin(i * angle);

      double endX = centerX + endRadius * cos((i + 1) * angle);
      double endY = centerY + endRadius * sin((i + 1) * angle);

      double controlX =
          centerX + (startRadius + endRadius) / 2 * cos((i + 0.5) * angle);
      double controlY =
          centerY + (startRadius + endRadius) / 2 * sin((i + 0.5) * angle);

      if (i == 0) {
        path.moveTo(startX, startY);
      }

      path.quadraticBezierTo(controlX, controlY, endX, endY);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(SmoothJaggedCircleClipper oldClipper) => false;
}
