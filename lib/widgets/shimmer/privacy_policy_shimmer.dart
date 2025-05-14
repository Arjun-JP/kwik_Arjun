import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class PrivacyPolicyShimmer extends StatelessWidget {
  const PrivacyPolicyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              "assets/images/kwiklogo.png",
              height: 120,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            spacing: 5,
            children: List.generate(
              40,
              (index) =>
                  Shimmer(width: MediaQuery.of(context).size.width, height: 12),
            ),
          )
        ],
      ),
    );
  }
}
