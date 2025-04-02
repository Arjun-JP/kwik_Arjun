import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class CategoryModel18Shimmer extends StatelessWidget {
  const CategoryModel18Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Column(
        spacing: 15,
        children: [
          Row(
            spacing: 15,
            children: List.generate(
              3,
              (index) => const Expanded(
                  child: Shimmer(width: double.infinity, height: 150)),
            ),
          ),
          const Shimmer(width: double.infinity, height: 40)
        ],
      ),
    );
  }
}
