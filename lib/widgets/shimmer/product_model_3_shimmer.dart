import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class ProductModel3Shimmer extends StatelessWidget {
  const ProductModel3Shimmer({super.key});

  @override
  build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            width: 135,
            height: 250,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: const Color.fromARGB(255, 233, 255, 234),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Shimmer(width: 127, height: 147),
                      Shimmer(width: 50, height: 12),
                      Shimmer(width: 120, height: 12),
                      Shimmer(width: 120, height: 12),
                      Shimmer(width: 120, height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Color.fromARGB(255, 192, 192, 192),
                          ),
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Color.fromARGB(255, 192, 192, 192),
                          ),
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Color.fromARGB(255, 192, 192, 192),
                          ),
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Color.fromARGB(255, 192, 192, 192),
                          ),
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Color.fromARGB(255, 192, 192, 192),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Positioned(
                    top: 95,
                    right: -1,
                    child: Shimmer(
                      width: 50,
                      height: 35,
                      borderRadius: 8,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
