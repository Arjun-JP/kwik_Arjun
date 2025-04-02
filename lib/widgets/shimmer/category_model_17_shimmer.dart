import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class CategoryModel17Shimmer extends StatelessWidget {
  const CategoryModel17Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Shimmer(width: MediaQuery.of(context).size.width * .45, height: 16),
        const Row(
          spacing: 15,
          children: [
            Expanded(
              child: Shimmer(
                width: double.infinity,
                height: 291,
                borderRadius: 15,
              ),
            ),
            Expanded(
              child: Column(
                spacing: 15,
                children: [
                  Shimmer(
                      width: double.infinity, height: 140, borderRadius: 15),
                  Shimmer(width: double.infinity, height: 140, borderRadius: 15)
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
