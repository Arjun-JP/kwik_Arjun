import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class AddressShimmer extends StatelessWidget {
  const AddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => Card(
          color: Colors.white,
          elevation: .5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: ListTile(
              onTap: () async {},
              dense: true,
              leading: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 244, 244, 244)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Icon(
                    index == 0
                        ? Icons.home_outlined
                        : index == 1
                            ? Icons.work_history_outlined
                            : index == 2
                                ? Icons.domain_add
                                : index == 3
                                    ? Icons.location_on_outlined
                                    : Icons.home_outlined,
                    color: const Color.fromARGB(255, 66, 143, 68),
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Color.fromARGB(255, 66, 143, 68),
              ),
              title: const Column(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [Shimmer(width: 80, height: 12)],
                  ),
                  Shimmer(width: double.infinity, height: 12),
                  Shimmer(width: double.infinity, height: 12),
                  Shimmer(width: double.infinity, height: 12)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
