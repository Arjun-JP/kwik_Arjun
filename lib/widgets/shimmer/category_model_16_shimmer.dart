import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class CategoryModel16Shimmer extends StatelessWidget {
  const CategoryModel16Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Shimmer(width: MediaQuery.of(context).size.width * .45, height: 16),
            const SizedBox(height: 5),
            Row(
              spacing: 25,
              children: List.generate(
                3,
                (index) => const Expanded(
                    child: Shimmer(width: double.infinity, height: 146)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              spacing: 25,
              children: List.generate(
                3,
                (index) => const Expanded(
                    child: Shimmer(width: double.infinity, height: 146)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
