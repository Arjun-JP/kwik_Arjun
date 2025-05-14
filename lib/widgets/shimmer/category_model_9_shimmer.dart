import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model_3_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class CategoryModel9Shimmer extends StatelessWidget {
  const CategoryModel9Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          // Shimmer(width: MediaQuery.of(context).size.width * .45, height: 16),
          Row(
            spacing: 10,
            children: List.generate(
              3,
              // ignore: prefer_const_constructors
              (index) => Expanded(child: const ProductModel3Shimmer()),
            ),
          ),
          Row(
            spacing: 10,
            children: List.generate(
              3,
              // ignore: prefer_const_constructors
              (index) => Expanded(child: const ProductModel3Shimmer()),
            ),
          ),
          const Shimmer(width: double.infinity, height: 40)
        ],
      ),
    );
  }
}
