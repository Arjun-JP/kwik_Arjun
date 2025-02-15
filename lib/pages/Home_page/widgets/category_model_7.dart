import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class CategoryModel7 extends StatelessWidget {
  final String bgcolor;
  final String titleColor;

  const CategoryModel7({
    super.key,
    required this.bgcolor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: parseColor(bgcolor),
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            "Explore Dairy Products",
            style: TextStyle(
                color: parseColor(titleColor),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            height: 305,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return products(
                      name: 'Product1',
                      product_background_color: bgcolor,
                      productname: 'Chocolate',
                      bgColor: 'bgcolor',
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/97d9/b90b/6c819e2b55d2579e34734826318ccf17?Expires=1740355200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=she8zDkqO~QqUXIY0c87BokjzF6xTIDpNDFLgytwdmAXtmApze425ZuQxbs4Ak-H9xy~W7CJW-ZL2iwBU5afKgqLmgnjhkTf5j41f52mlgw4777uAXAlcvEMbG1T-uSFwqVZKNQt95yi1hXMvLBHHKdc3u6GUO9gonSZTQ5~F5oDjVqIV4EbssQl8ob7k43TQVCxe5MrhFj9Lhn-RwWgIEOuNOH803Xo1uMrkdrgzRhpt063~W960aUU1laiKi7Clv2GwQiq~DlQefimA50oJvt84rc5VeyyV9GLFZoe~opyrZCJpUHgyvoZScteLpn1wAzyvaliOkgejI8-l32Yyg__',
                      offer_text_color: 'green',
                      MRP: '200',
                      offer_bg_color: 'yellow',
                      mrp_color: 'black',
                      selling_price_color: '199');
                }),
          ),
          Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('See all products',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Icon(Icons.arrow_forward),
                  )
                ],
              )),
        ],
      ),
    );
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
  return Padding(
    padding: const EdgeInsets.only(left: 4.0, right: 5, top: 13),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 167,
          height: 273,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 140,
                  width: 170,
                  child: Image.network(
                    imageUrl,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: parseColor(bgColor)),
                ),
                const SizedBox(height: 8),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product1',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text('25',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.grey))
                    ]),
                const SizedBox(height: 5),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('500g',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.grey)),
                      Text('200',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black))
                    ]),
                const SizedBox(height: 6),
                SizedBox(
                  width: 140,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Add to Cart',
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        //minimumSize: Size(86, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
