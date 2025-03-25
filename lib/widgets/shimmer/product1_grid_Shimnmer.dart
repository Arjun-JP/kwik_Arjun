import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model_1_shimmer.dart';

class ProductModel1GridShimmer extends StatelessWidget {
  const ProductModel1GridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            ProductModel1Shimmer(),
            ProductModel1Shimmer(),
            ProductModel1Shimmer(),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            ProductModel1Shimmer(),
            ProductModel1Shimmer(),
            ProductModel1Shimmer(),
          ],
        )
      ],
    );
  }
}
