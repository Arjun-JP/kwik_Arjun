import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Home_page/widgets/sale_banner_ribbonclip.dart';

import '../../../bloc/category_model_4_bloc/category_model_4_bloc.dart';
import '../../../bloc/category_model_4_bloc/category_model_4_event.dart';
import '../../../bloc/category_model_4_bloc/category_model_4_state.dart';
import '../../../repositories/sub_category_product_repository.dart';

class CategoryModel4 extends StatelessWidget {
  final String subCategoryId;
  final String bgcolor;
  final String titleColor;
  final String productColor;
  final String sellingpricecolor;
  final String mrpColor;
  final bool flashSaleBanner;
  final String flashBgColor;
  final String flashTextColor;
  final String seeAllButtonBG;
  final String seeAllButtontext;

  const CategoryModel4({
    super.key,
    required this.subCategoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.productColor,
    required this.sellingpricecolor,
    required this.mrpColor,
    required this.flashSaleBanner,
    required this.flashBgColor,
    required this.flashTextColor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
                print(state.products.length);
                return Container(
                  color: parseColor(bgcolor),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      flashSaleBanner
                          ? Center(
                              child: ClipPath(
                                clipper: RibbonClipper(),
                                child: Container(
                                  width: 300,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  color: parseColor(flashBgColor),
                                  child: Text.rich(
                                    TextSpan(
                                      text: "SAVE BIG! ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: parseColor(flashTextColor)),
                                      children: [
                                        TextSpan(
                                          text: "MIN ORDER ₹999",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        state.products.first.subCategoryRef
                            .name, // Display section title
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 215,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.products.length <= 5
                              ? state.products.length
                              : 5,
                          itemBuilder: (context, index) {
                            return productItem(
                              mrpColor: mrpColor,
                              sellingpricecolor: sellingpricecolor,
                              productcolor: productColor,
                              name: state.products[index].productName,
                              price: 200,
                              bgcolor: state.products.first.categoryRef.color,
                              imageurl:
                                  state.products[index].productImages.first,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: parseColor(seeAllButtonBG)),
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
                            )
                          ],
                        ),
                      ),
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
    );
  }

  Widget productItem(
      {required String name,
      required double price,
      required String imageurl,
      required String bgcolor,
      required String productcolor,
      required String sellingpricecolor,
      required String mrpColor}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 132,
        height: 221,
        child: Stack(
          children: [
            Container(
              width: 132,
              height: 221,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: lightenColor(parseColor(bgcolor), .6)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 49),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(imageurl), fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 121,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: lightenColor(parseColor(productcolor), .8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: parseColor(productcolor)),
                    ),
                    child: Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 14,
                          color: parseColor(productcolor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 42,
              width: 132,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: parseColor(productcolor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("₹85",
                      style: TextStyle(
                          fontSize: 24,
                          color: parseColor(sellingpricecolor),
                          fontWeight: FontWeight.w800)),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "MRP",
                        style: TextStyle(
                            fontSize: 12, color: parseColor(mrpColor)),
                      ),
                      Text("₹85",
                          style: TextStyle(
                              fontSize: 12, color: parseColor(mrpColor))),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
