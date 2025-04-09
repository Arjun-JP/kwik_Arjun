import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

class OrderdetailsPageShimmer extends StatelessWidget {
  const OrderdetailsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Shimmer(width: 150, height: 40),
          Shimmer(width: 250, height: 10),
          Row(
            spacing: 15,
            children: [
              Expanded(flex: 1, child: Shimmer(width: 60, height: 60)),
              Expanded(
                flex: 3,
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer(width: 300, height: 16),
                    Shimmer(width: 300, height: 16),
                    Shimmer(width: 300, height: 10),
                    Shimmer(width: 300, height: 10),
                    Shimmer(width: 100, height: 10),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  spacing: 5,
                  children: [
                    Shimmer(width: 90, height: 16),
                    Shimmer(width: 90, height: 12),
                  ],
                ),
              )
            ],
          ),
          Shimmer(width: 150, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 180, height: 14),
              Shimmer(width: 40, height: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 180, height: 14),
              Shimmer(width: 40, height: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 180, height: 14),
              Shimmer(width: 40, height: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 180, height: 14),
              Shimmer(width: 40, height: 12),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 180, height: 14),
              Shimmer(width: 40, height: 12),
            ],
          ),
          Shimmer(width: 150, height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 80, height: 14),
              Shimmer(width: 140, height: 12),
            ],
          ),
          SizedBox(height: 20),
          Shimmer(width: 80, height: 14),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer(width: 30, height: 10),
              Shimmer(width: 80, height: 10),
              Shimmer(width: 100, height: 10),
              Shimmer(width: 100, height: 10),
              Shimmer(width: 80, height: 10),
              Shimmer(width: 60, height: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 80, height: 12),
              Shimmer(width: 140, height: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(width: 80, height: 12),
              Shimmer(width: 140, height: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              Expanded(child: Shimmer(width: 80, height: 35)),
              Expanded(child: Shimmer(width: 140, height: 35)),
            ],
          ),
        ],
      ),
    );
  }
}
