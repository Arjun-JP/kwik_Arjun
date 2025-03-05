import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_4.dart';
import 'package:kwik/pages/Home_page/widgets/sale_banner_ribbonclip.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

import '../../../bloc/Super Saver Page Bloc/supersaver_model6_bloc/supersaver_model6_bloc.dart';

class SupersaverModel6 extends StatelessWidget {
  final String subCategoryId;
  final String bgcolor;
  final String titleColor;
  final String productColor;
  final String sellingpricecolor;
  final String mrpColor;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  final String flashTextColor;
  final String flashBgColor;
  const SupersaverModel6({
    super.key,
    required this.subCategoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.productColor,
    required this.sellingpricecolor,
    required this.mrpColor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
    required this.flashTextColor,
    required this.flashBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SupersaverModel6Bloc(repository: SubcategoryProductRepository())
            ..add(FetchSubCategoryProductsSS6(subCategoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<SupersaverModel6Bloc, SupersaverModel6State>(
            builder: (context, state) {
              if (state is SupersaverModel6Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SupersaverModel6Loaded) {
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
                      Center(
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
                                children: const [
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
                      ),
                      const SizedBox(height: 10),
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
                                context: context);
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
              } else if (state is SupersaverModel6Error) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
