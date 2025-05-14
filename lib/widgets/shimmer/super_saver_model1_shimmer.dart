import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class SuperSaverModel1Shimmer extends StatelessWidget {
  const SuperSaverModel1Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.all(10.0),
            child: Shimmer(width: 230, height: 18)),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 256,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StaggeredGrid.count(
                  axisDirection: AxisDirection.right,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: List.generate(
                    6,
                    (index) {
                      return const Shimmer(width: 175, height: 78);
                    },
                  ),
                ),
              )),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
