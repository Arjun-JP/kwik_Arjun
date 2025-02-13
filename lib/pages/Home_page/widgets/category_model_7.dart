import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class CategoryModel7 extends StatelessWidget {
  final String bgcolor;
  final String titleColor;
  final List<String> products;
  final String productName;
  final String productBgColor;
  final String offer_text_color;
  final String offer_bg_color;
  final String selling_price_color;
  final String mrp_color;

  const CategoryModel7(
      {super.key,
      required this.bgcolor,
      required this.products,
      required this.productName,
      required this.productBgColor,
      required this.titleColor,
      required this.offer_text_color,
      required this.offer_bg_color,
      required this.selling_price_color,
      required this.mrp_color});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: parseColor(bgcolor),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              "Explore Dairy Products",
              style: TextStyle(
                  color: parseColor(titleColor),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 13),
            SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {}))
          ],
        ));
  }
}

Widget products({
  required String name,
  required String product_background_color,
  required String productname,
  required String bgColor,
  required String imageUrl,
  required String offer_text_color,
  required String offer_bg_color,
  required String MRP,
  required String mrp_color,
  required String selling_price_color,
}) {
  return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SizedBox(
                height: 175,
                width: 150,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 110,
                      child: Image.network(imageUrl),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: parseColor(bgColor),
                      ),
                    )
                  ],
                )))
      ]);
}
