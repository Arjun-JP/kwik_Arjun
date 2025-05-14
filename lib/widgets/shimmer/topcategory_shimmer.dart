import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class TopcategoryShimmer extends StatelessWidget {
  final String title;
  final String titlecolor;
  const TopcategoryShimmer(
      {super.key, required this.title, required this.titlecolor});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 7),
        Text(
          title,
          style: theme.textTheme.titleLarge!.copyWith(
              color: parseColor(titlecolor), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
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
            Container(
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
            Container(
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
            Container(
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
            Container(
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
            Container(
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
          ],
        ),
      ],
    );
  }
}
