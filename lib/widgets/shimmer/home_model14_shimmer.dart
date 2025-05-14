import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart'
    show ProductModel1ListShimmer;
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class HomeModel14Shimmer extends StatelessWidget {
  const HomeModel14Shimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                7,
                (index) => Container(
                  margin: const EdgeInsetsDirectional.only(end: 20),
                  width: 100,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Shimmer(width: 100, height: 100),
                      SizedBox(height: 3),
                      Shimmer(width: 60, height: 12),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              )),
            ),
          ),
          Shimmer(width: MediaQuery.of(context).size.width, height: 150),
          const SizedBox(height: 10),
          const SizedBox(
              width: double.infinity,
              height: 250,
              child: ProductModel1ListShimmer()),
          const SizedBox(height: 15),
          Shimmer(width: MediaQuery.of(context).size.width, height: 40),
        ],
      ),
    );
  }
}
