import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model2_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class SupersaverModel4Shimmer extends StatelessWidget {
  const SupersaverModel4Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.all(10.0),
            child: Shimmer(width: 180, height: 18)),
        const Shimmer(height: 250, width: double.infinity),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
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
        ),
        const SizedBox(height: 20),
        Shimmer(width: MediaQuery.of(context).size.width, height: 48),
        const SizedBox(height: 10)
      ],
    );
  }
}
