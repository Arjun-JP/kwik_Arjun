import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/widgets/shimmer/product_model_1_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class SupersaverModel5Shimmer extends StatelessWidget {
  const SupersaverModel5Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 13,
          children: List.generate(6, (index) {
            return const StaggeredGridTile.extent(
                crossAxisCellCount: 1,
                mainAxisExtent: 278,
                child: ProductModel1Shimmer());
          }),
        ),
        const SizedBox(height: 15),
        Shimmer(
          width: MediaQuery.of(context).size.width,
          height: 48,
        )
      ],
    );
  }
}
