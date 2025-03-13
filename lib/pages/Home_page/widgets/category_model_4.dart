import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/constants/colors.dart';
import '../../../bloc/home_page_bloc/category_model_4_bloc/category_model_4_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_4_bloc/category_model_4_event.dart';
import '../../../bloc/home_page_bloc/category_model_4_bloc/category_model_4_state.dart';
import '../../../repositories/sub_category_product_repository.dart';

class CategoryModel4 extends StatelessWidget {
  final String title;
  final String subtitle;
  final String subCategoryId;
  final String bgcolor;
  final String titleColor;
  final String productColor;
  final String sellingpricecolor;
  final String mrpColor;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  final bool showcategory;
  final String buttonbgcolor;
  final String buttontextcolor;
  final String offertextcolor;
  final String offerbgcolor;
  final String unitcolor;
  final String offertext2;
  final String offerborder;

  const CategoryModel4({
    super.key,
    required this.subCategoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.productColor,
    required this.sellingpricecolor,
    required this.mrpColor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
    required this.showcategory,
    required this.buttonbgcolor,
    required this.buttontextcolor,
    required this.offertextcolor,
    required this.offerbgcolor,
    required this.unitcolor,
    required this.offertext2,
    required this.offerborder,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (context) =>
                CategoryModel4Bloc(repository: SubcategoryProductRepository())
                  ..add(FetchSubCategoryProducts(subCategoryId)),
            child: Builder(
              builder: (context) {
                return BlocBuilder<CategoryModel4Bloc, CategoryModel4State>(
                  builder: (context, state) {
                    if (state is CategoryModel4Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CategoryModel4Loaded) {
                      return Container(
                        color: parseColor(bgcolor),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title, // Display section title
                                      style: TextStyle(
                                          color: parseColor("2C8E55"),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      subtitle, // Display section title
                                      style: TextStyle(
                                          color: parseColor(titleColor),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Text(
                                  "See All  >", // Display section title
                                  style: TextStyle(
                                      color: parseColor(seeAllButtontext),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 360,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.products.length <= 5
                                    ? state.products.length
                                    : 5,
                                itemBuilder: (context, index) {
                                  return productItem(
                                      buttonbgcolor: buttonbgcolor,
                                      buttontextcolor: buttontextcolor,
                                      offerTextcolor: offertextcolor,
                                      offerbgcolor: offerbgcolor,
                                      theme: theme,
                                      unitcolor: unitcolor,
                                      mrpColor: mrpColor,
                                      sellingpricecolor: sellingpricecolor,
                                      productcolor: productColor,
                                      name: state.products[index].productName,
                                      price: 200,
                                      offerborder: offerborder,
                                      offertext2: offertext2,
                                      bgcolor: state
                                          .products.first.categoryRef.color,
                                      imageurl: state
                                          .products[index].productImages.first,
                                      context: context);
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 48,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       color: lightenColor(parseColor("#E23338"), .8)),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Expanded(
                            //         flex: 5,
                            //         child: Align(
                            //           alignment: Alignment.centerRight,
                            //           child: Text('See all products',
                            //               style: TextStyle(
                            //                   color: parseColor("E23338"),
                            //                   fontSize: 18)),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         flex: 2,
                            //         child: Align(
                            //           alignment: Alignment.centerRight,
                            //           child: Padding(
                            //             padding: const EdgeInsets.only(right: 14.0),
                            //             child: Icon(Icons.arrow_forward,
                            //                 color: parseColor("E23338")),
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    } else if (state is CategoryModel4Error) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                );
              },
            ),
          )
        : const SizedBox();
  }
}

Widget productItem(
    {required String name,
    required double price,
    required String imageurl,
    required String bgcolor,
    required String productcolor,
    required String sellingpricecolor,
    required String mrpColor,
    required String buttonbgcolor,
    required String buttontextcolor,
    required String offerbgcolor,
    required String offerTextcolor,
    required String unitcolor,
    required String offertext2,
    required String offerborder,
    required ThemeData theme,
    required BuildContext context}) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(right: 5),
    child: SizedBox(
      width: 154,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shadowColor: const Color.fromARGB(255, 233, 233, 233),
            elevation: .1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Container(
                    height: 58,
                    width: 154,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color:
                              parseColor(offerborder), // Change color as needed
                          width: 2.0, // Change width as needed
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: parseColor(productcolor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹126",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: parseColor(mrpColor)),
                        ),
                        Text("MRP ₹150",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: parseColor(sellingpricecolor))),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: SizedBox(
                    height: 164,
                    width: 143,
                    child: Stack(
                      children: [
                        Container(
                          height: 164,
                          width: 143,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(imageurl),
                                  fit: BoxFit.cover)),
                        ),
                        Align(
                          alignment: const Alignment(-.8, .9),
                          child: ClipPath(
                            clipper: SmoothJaggedCircleClipper(),
                            child: Container(
                              width: 55,
                              height: 55,
                              color: parseColor(offerbgcolor),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "30%",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        color: parseColor(offerTextcolor),
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "OFF",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: parseColor(offertext2),
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ],
                              ), // Match the color in your image
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10,
            ),
            child: SizedBox(
              width: 154,
              height: 40,
              child: Text(
                name,
                textAlign: TextAlign.start,
                maxLines: 2,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10,
            ),
            child: Text(
              "500 g",
              textAlign: TextAlign.start,
              maxLines: 2,
              style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  color: parseColor(unitcolor),
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5,
            ),
            child: SizedBox(
              height: 35,
              width: 154,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: parseColor(buttonbgcolor),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: parseColor(buttontextcolor)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: parseColor(buttontextcolor),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class SmoothJaggedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double outerRadius = size.width / 2;
    double innerRadius = outerRadius * 0.85; // Adjust for smoothness
    int points = 20; // Number of spikes
    double angle = (2 * pi) / points;

    for (int i = 0; i < points; i++) {
      double startRadius = (i % 2 == 0) ? outerRadius : innerRadius;
      double endRadius = (i % 2 == 0) ? innerRadius : outerRadius;

      double startX = centerX + startRadius * cos(i * angle);
      double startY = centerY + startRadius * sin(i * angle);

      double endX = centerX + endRadius * cos((i + 1) * angle);
      double endY = centerY + endRadius * sin((i + 1) * angle);

      double controlX =
          centerX + (startRadius + endRadius) / 2 * cos((i + 0.5) * angle);
      double controlY =
          centerY + (startRadius + endRadius) / 2 * sin((i + 0.5) * angle);

      if (i == 0) {
        path.moveTo(startX, startY);
      }

      path.quadraticBezierTo(controlX, controlY, endX, endY);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(SmoothJaggedCircleClipper oldClipper) => false;
}
