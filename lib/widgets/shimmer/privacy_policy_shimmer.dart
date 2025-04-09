import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';

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
              "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
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
