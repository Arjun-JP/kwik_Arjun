import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model2_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class SupersaverModel3Shimmer extends StatelessWidget {
  const SupersaverModel3Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(flex: 5, child: Shimmer(width: 200, height: 18)),
            Expanded(
              flex: 1,
              child: Shimmer(width: 51, height: 51),
            )
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 355,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return const ProductModel2Shimmer();
            },
          ),
        ),
        const SizedBox(height: 20),
        Shimmer(
          width: MediaQuery.of(context).size.width,
          height: 48,
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
