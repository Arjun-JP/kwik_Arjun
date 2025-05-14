import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model2_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class HomeCat4Shimmer extends StatelessWidget {
  const HomeCat4Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer(
                    height: 18,
                    width: MediaQuery.of(context).size.width * .5,
                  ),
                  const SizedBox(height: 5),
                  Shimmer(
                    height: 16,
                    width: MediaQuery.of(context).size.width * .5,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Shimmer(
                height: 16,
                width: MediaQuery.of(context).size.width * .3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  List.generate(7, (index) => const ProductModel2Shimmer()),
            ),
          ),
        ),
        const SizedBox(height: 5)
      ],
    );
  }
}
