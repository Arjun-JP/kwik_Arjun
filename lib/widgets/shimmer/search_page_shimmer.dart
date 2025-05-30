import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class SearchPageShimmer extends StatelessWidget {
  const SearchPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Shimmer(
              //         width: MediaQuery.of(context).size.width * .3,
              //         height: 12),
              //     Shimmer(
              //         width: MediaQuery.of(context).size.width * .1,
              //         height: 10),
              //   ],
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // const Wrap(
              //   spacing: 5,
              //   runSpacing: 5,
              //   children: [
              //     Shimmer(width: 100, height: 25),
              //     Shimmer(width: 80, height: 25),
              //     Shimmer(width: 120, height: 25),
              //     Shimmer(width: 40, height: 25),
              //     Shimmer(width: 100, height: 25),
              //     Shimmer(width: 100, height: 25),
              //     Shimmer(width: 80, height: 25),
              //     Shimmer(width: 40, height: 25),
              //     Shimmer(width: 120, height: 25),
              //     Shimmer(width: 80, height: 25),
              //     Shimmer(width: 120, height: 25),
              //   ],
              // ),
              const SizedBox(
                height: 20,
              ),
              Shimmer(
                  width: MediaQuery.of(context).size.width * .4, height: 18),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StaggeredGrid.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  children: List.generate(
                    3,
                    (index) => const ProductModel1ListShimmer(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
