import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/widgets/shimmer/product_model_1_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class AllsubcategoryPageshimmer extends StatelessWidget {
  const AllsubcategoryPageshimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: List.generate(
              7,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 5,
                    children: [
                      Shimmer(width: 100, height: 80),
                      Shimmer(width: 100, height: 14)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 25,
              children:
                  List.generate(14, (index) => const ProductModel1Shimmer()),
            ),
          ),
        )
      ],
    );
  }
}
