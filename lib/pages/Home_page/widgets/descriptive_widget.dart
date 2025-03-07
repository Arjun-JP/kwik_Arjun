import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class DescriptiveWidget extends StatelessWidget {
  final String info;
  final String logo;
  final String title;
  final String textColor;
  const DescriptiveWidget(
      {super.key,
      required this.info,
      required this.logo,
      required this.title,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            logo,
            height: 80,
          ),
          Text(
            info,
            style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.w800,
                color: parseColor(textColor)),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: parseColor(textColor)),
          ),
          Text(
            "Kwik Grocery",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: parseColor(textColor)),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
