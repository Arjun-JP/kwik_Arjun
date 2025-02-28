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
      height: 250,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: parseColor(textColor)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              logo,
              height: 80,
            ),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: parseColor(textColor)),
          )
        ],
      ),
    );
  }
}
