import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class OrderListPageShimmer extends StatelessWidget {
  const OrderListPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      spacing: 10,
      children: List.generate(
        4,
        (index) => const OrderCardShimmer(),
      ),
    ));
  }
}

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Images
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  4,
                  (index) => const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Shimmer(width: 80, height: 100)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Order Status and Total
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Shimmer(width: 100, height: 12),
                    Shimmer(width: 140, height: 10)
                  ],
                ),
                Column(
                  spacing: 5,
                  children: [
                    Shimmer(width: 90, height: 16),
                    Shimmer(width: 90, height: 14)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer(width: 90, height: 40),
                Shimmer(width: 80, height: 12)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
