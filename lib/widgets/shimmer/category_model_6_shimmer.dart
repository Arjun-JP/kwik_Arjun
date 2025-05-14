import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class CategoryModel6Shimmer extends StatefulWidget {
  const CategoryModel6Shimmer({super.key});

  @override
  State<CategoryModel6Shimmer> createState() => _CategoryModel6ShimmerState();
}

class _CategoryModel6ShimmerState extends State<CategoryModel6Shimmer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          const SizedBox(height: 15),
          Shimmer(width: MediaQuery.of(context).size.width * .45, height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              children: List.generate(
                5,
                (index) => const Shimmer(
                  height: 170,
                  width: 140,
                  borderRadius: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
