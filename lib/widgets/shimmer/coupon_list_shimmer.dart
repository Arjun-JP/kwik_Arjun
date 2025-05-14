// couponWidgetshimmer
import 'package:flutter/material.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class CouponWidgetshimmer extends StatelessWidget {
  const CouponWidgetshimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15,
        ),
        color: Colors.white,
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          ListTile(
            leading: const Shimmer(
              height: 50,
              width: 50,
            ),
            title: const Shimmer(
              height: 16,
              width: 120,
            ),
            subtitle: const Shimmer(
              height: 12,
              width: 150,
            ),
            trailing: ElevatedButton.icon(
              onPressed: () {},
              label: const Text(
                "",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 18.0, left: 12),
            child: DottedDivider(
              color: Color.fromARGB(255, 207, 207, 207),
            ),
          ),
          const Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.arrow_right_rounded,
                    color: Color.fromARGB(255, 207, 207, 207),
                  )),
              Expanded(
                  flex: 5,
                  child: Shimmer(
                    height: 14,
                    width: double.infinity,
                  ))
            ],
          ),
          const Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.arrow_right_rounded,
                    color: Color.fromARGB(255, 207, 207, 207),
                  )),
              Expanded(
                  flex: 5,
                  child: Shimmer(
                    height: 14,
                    width: double.infinity,
                  ))
            ],
          ),
          const Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.arrow_right_rounded,
                    color: Color.fromARGB(255, 207, 207, 207),
                  )),
              Expanded(
                  flex: 5,
                  child: Shimmer(
                    height: 14,
                    width: double.infinity,
                  ))
            ],
          ),
          const Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.arrow_right_rounded,
                    color: Color.fromARGB(255, 207, 207, 207),
                  )),
              Expanded(
                  flex: 5,
                  child: Shimmer(
                    height: 14,
                    width: double.infinity,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
