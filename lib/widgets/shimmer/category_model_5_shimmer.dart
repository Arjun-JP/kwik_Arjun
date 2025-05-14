import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model_1_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class CategoryModel5Shimmer extends StatelessWidget {
  const CategoryModel5Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        spacing: 10,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsetsDirectional.only(end: 20),
                  width: 100,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Shimmer(width: 70, height: 70),
                      SizedBox(height: 7),
                      Shimmer(width: 50, height: 12)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            spacing: 10,
            children: List.generate(
              3,
              (index) => const Expanded(child: ProductModel1Shimmer()),
            ),
          ),
          Row(
            spacing: 10,
            children: List.generate(
              3,
              (index) => const Expanded(child: ProductModel1Shimmer()),
            ),
          ),
          const Shimmer(width: double.infinity, height: 35)
        ],
      ),
    );
  }
}
