import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class Categorymodel2Shimmer extends StatelessWidget {
  const Categorymodel2Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const SizedBox(height: 10),
        Shimmer(width: MediaQuery.of(context).size.width * .4, height: 16),
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 20),
                width: 100,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Shimmer(width: 100, height: 100),
                    SizedBox(height: 7),
                    Shimmer(width: 60, height: 12)
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 20),
                width: 100,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Shimmer(width: 100, height: 100),
                    SizedBox(height: 7),
                    Shimmer(width: 60, height: 12)
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}
