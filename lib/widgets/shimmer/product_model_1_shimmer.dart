import 'package:flutter/material.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class ProductModel1Shimmer extends StatelessWidget {
  const ProductModel1Shimmer({super.key});

  @override
  build(BuildContext context) {
    return Container(
      width: 120,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: const Color.fromARGB(255, 233, 255, 234),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Shimmer(width: 127, height: 147),
          Shimmer(width: 50, height: 12),
          Shimmer(width: 120, height: 12),
          Shimmer(width: 120, height: 12),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: 5,
                  children: [
                    Shimmer(width: 50, height: 14),
                    Shimmer(width: 50, height: 14),
                  ],
                ),
              ),
              Expanded(child: Shimmer(width: 100, height: 30)),
            ],
          )
        ],
      ),
    );
  }
}
