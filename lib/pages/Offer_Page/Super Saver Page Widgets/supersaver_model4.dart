import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/produc_model_1.dart';

import '../../../bloc/Super Saver Page Bloc/supersaver_model4_bloc/supersaver_model4_bloc.dart';
import '../../../repositories/sub_category_product_repository.dart';

class SupersaverModel4 extends StatelessWidget {
  final String subCategoryId;
  final String titleColor;
  final String productColor;
  final String mrpBgColor;
  final String mrpTextColor;
  final String sellTextColor;
  final String sellPriceBgColor;
  final String bgColor;
  final String offerbgcolor;
  final String offertextcolor;
  final String addButtonColor;
  final String ratingBgColor;
  final String ratingTextColor;

  final String seeAllButtonBG;
  final String seeAllButtontext;
  const SupersaverModel4(
      {super.key,
      required this.subCategoryId,
      required this.titleColor,
      required this.productColor,
      required this.mrpBgColor,
      required this.mrpTextColor,
      required this.sellTextColor,
      required this.sellPriceBgColor,
      required this.bgColor,
      required this.offerbgcolor,
      required this.addButtonColor,
      required this.offertextcolor,
      required this.ratingBgColor,
      required this.seeAllButtonBG,
      required this.seeAllButtontext,
      required this.ratingTextColor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SupersaverModel4Bloc(repository: SubcategoryProductRepository())
            ..add(FetchSubCategoryProductsSS4(subCategoryId)),
      child: BlocBuilder<SupersaverModel4Bloc, SupersaverModel4State>(
        builder: (context, state) {
          if (state is SupersaverModel4Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SupersaverModel4Loaded) {
            return Container(
              color: parseColor(bgColor),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SUPER SAVER",
                    style: TextStyle(
                      color: parseColor(titleColor),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "SPECIAL TODAY OFFER",
                    style: TextStyle(
                      color: parseColor(titleColor),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 12,
                    children: List.generate(
                      state.products.length > 6 ? 6 : state.products.length,
                      (index) {
                        return ProductItem(
                          subcategoryRef: subCategoryId,
                          productnamecolor: "000000",
                          product: state.products[index],
                          imageurl: state.products[index].productImages.first,
                          buttontextcolor: ratingBgColor,
                          context: context,
                          mrpColor: mrpTextColor,
                          name: state.products[index].productName,
                          productBgColor: mrpBgColor,
                          buttonBgColor: productColor,
                          offerbgcolor: ratingBgColor,
                          sellingPriceColor: sellTextColor,
                          unitTextcolor: offertextcolor,
                          unitbgcolor: "FFFFFF",
                          offertextcolor: "000000",
                          price: 278,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: parseColor(seeAllButtonBG),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('See all products',
                                style: TextStyle(
                                    color: parseColor(seeAllButtontext),
                                    fontSize: 18)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14.0),
                              child: Icon(Icons.arrow_forward,
                                  color: parseColor(seeAllButtontext)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SupersaverModel4Error) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

Widget productItem({
  required String imageurl,
  required String price,
  required String mrp,
  required String productColor,
  required String mrpTextColor,
  required String mrpBgColor,
  required String sellPriceBgColor,
  required String sellTextColor,
  required String offerbgcolor,
  required String offertextcolor,
  required String addButtonColor,
  required String ratingBgColor,
  required String ratingTextColor,
  required String title,
}) {
  return Stack(children: [
    Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: parseColor(productColor),
      ),
      child: Column(
        children: [
          Image.network(
            imageurl,
            fit: BoxFit.cover,
            height: 80,
          ),
          Container(
            padding: EdgeInsets.all(5),
            width: double.infinity,
            color: parseColor('ffffff'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: parseColor(addButtonColor).withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(
                    '1L',
                    style: TextStyle(
                      color: parseColor(mrpTextColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: parseColor(ratingBgColor),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.star,
                              color: parseColor(ratingTextColor)),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: parseColor(ratingTextColor)),
                        ),
                        TextSpan(
                          text: "4.2",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: parseColor(ratingTextColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: parseColor('ffffff'),
            width: double.infinity,
            height: 40,
            child: Text(
              title,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.visible,
              softWrap: true,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: parseColor('000000')),
            ),
          ),
          Container(
            width: double.infinity,
            color: parseColor(sellPriceBgColor),
            child: Text(
              textAlign: TextAlign.center,
              price,
              style: TextStyle(
                  color: parseColor(sellTextColor),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            color: parseColor(mrpBgColor),
            child: Text(
              mrp,
              style: TextStyle(
                color: parseColor(mrpTextColor),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    Positioned(
      top: 10,
      right: 10,
      child: Image.asset(
        'assets/images/vegicon.png',
        height: 20,
        width: 20,
      ),
    ),
    Positioned(
      left: 10,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: parseColor(offerbgcolor),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              "17% \nOFF",
              style: TextStyle(
                  color: parseColor(offertextcolor),
                  fontSize: 12,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    ),
    Positioned(
      top: 50,
      right: 8,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: lightenColor(parseColor(addButtonColor), .8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: parseColor(addButtonColor)),
          boxShadow: [
            BoxShadow(
              color: parseColor(addButtonColor).withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 2,
              offset: const Offset(2, 2), // Adds a floating effect
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Add",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: parseColor(addButtonColor),
            ),
          ),
        ),
      ),
    ),
  ]);
}
