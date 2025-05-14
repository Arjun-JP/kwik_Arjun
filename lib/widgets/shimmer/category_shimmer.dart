import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: parseColor("FFFFFF"),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Shimmer(width: 100, height: 16),
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(2, (index) {
                      return const Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Shimmer(width: 400, height: 98),
                                Shimmer(width: 80, height: 12),
                              ],
                            ),
                          ));
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(4, (index) {
                      return const Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Shimmer(width: 200, height: 88),
                            Shimmer(width: 60, height: 12),
                          ],
                        ),
                      ));
                    }),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
