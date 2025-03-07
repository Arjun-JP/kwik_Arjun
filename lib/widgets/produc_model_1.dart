import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final double price;
  final String imageurl;
  final String productcolor;
  final String sellingpricecolor;
  final String mrpColor;
  final String offertextcolor;
  final String productBgColor;
  final String sellingPriceColor;
  final String buttontextcolor;
  final String unitbgcolor;
  final String unitTextcolor;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  final BuildContext context;
  const ProductItem(
      {super.key,
      required this.name,
      required this.price,
      required this.imageurl,
      required this.productcolor,
      required this.sellingpricecolor,
      required this.mrpColor,
      required this.offertextcolor,
      required this.productBgColor,
      required this.sellingPriceColor,
      required this.buttontextcolor,
      required this.unitbgcolor,
      required this.unitTextcolor,
      required this.seeAllButtonBG,
      required this.seeAllButtontext,
      required this.context});

  @override
  build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: const Color.fromARGB(255, 233, 255, 234),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 5,
              children: [
                Container(
                  height: 147,
                  decoration: BoxDecoration(
                    color: parseColor("F9F9F9"),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image: NetworkImage(imageurl), fit: BoxFit.fill)),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "100 g",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: parseColor(unitTextcolor),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    "Lays Water ChipsSalt N Pepper Fl...",
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: parseColor(unitTextcolor),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "₹ 45",
                          style: theme.textTheme.bodyMedium!.copyWith(
                              color: parseColor(unitTextcolor),
                              decoration: TextDecoration.lineThrough),
                        ),
                        Text(
                          "₹ 85",
                          style: theme.textTheme.bodyMedium!.copyWith(
                              color: parseColor(unitTextcolor),
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: parseColor("#FFFFFF"),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: parseColor("#E23338")),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(0)),
                        child: Text(
                          'Add',
                          style: theme.textTheme.bodyMedium!.copyWith(
                              color: parseColor("E23338"),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ClipPath(
            clipper: ZigZagClipper(),
            child: Container(
              width: 40,
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "30%",
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: parseColor("233D4D"),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "OFF",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: parseColor("233D4D"),
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 10);

    double x = 0;
    double y = size.height - 10;
    double step = size.width / 10;

    for (int i = 0; i < 10; i++) {
      x += step;
      y = (i % 2 == 0) ? size.height : size.height - 10;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(ZigZagClipper oldClipper) => false;
}
