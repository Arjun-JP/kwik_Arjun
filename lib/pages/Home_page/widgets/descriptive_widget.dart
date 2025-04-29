import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class DescriptiveWidget extends StatelessWidget {
  final String logo;
  final String title;

  final bool showcategory;
  const DescriptiveWidget(
      {super.key,
      required this.logo,
      required this.title,
      required this.showcategory});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return showcategory
        ? Container(
            padding:
                const EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 50),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  logo,
                  height: 80,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 40,
                      letterSpacing: .01,
                      wordSpacing: 2,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      color: parseColor("cbced9")),
                ),
                const SizedBox(height: 10),
                Text("Kwik Grocery",
                    style: theme.textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: parseColor("cbced9"))),
                const SizedBox(height: 100)
              ],
            ),
          )
        : const SizedBox();
  }
}
