import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model_1_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class SuperSaverModel2Shimmer extends StatelessWidget {
  const SuperSaverModel2Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 617,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.all(10.0),
              child: Shimmer(width: 230, height: 18)),
          const SizedBox(height: 10),
          const Shimmer(width: double.infinity, height: 200),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 278,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: ProductModel1Shimmer());
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          Shimmer(
            width: MediaQuery.of(context).size.width,
            height: 48,
          )
        ],
      ),
    );
    ;
  }
}
