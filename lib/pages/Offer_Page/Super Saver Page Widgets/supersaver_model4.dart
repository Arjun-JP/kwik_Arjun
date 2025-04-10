import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/product_model_2.dart';
import 'package:kwik/widgets/shimmer/supersaver_model4_shimmer.dart';

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
  final bool showCategory;
  final String bannerimage;
  final String title;
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
      required this.ratingTextColor,
      required this.showCategory,
      required this.title,
      required this.bannerimage});

  @override
  Widget build(BuildContext context) {
    return showCategory
        ? Container(
            height: 752,
            width: double.infinity,
            color: Colors.amber,
            child: BlocProvider(
              create: (context) => SupersaverModel4Bloc(
                  repository: SubcategoryProductRepository())
                ..add(FetchSubCategoryProductsSS4(subCategoryId)),
              child: BlocBuilder<SupersaverModel4Bloc, SupersaverModel4State>(
                builder: (context, state) {
                  if (state is SupersaverModel4Loading) {
                    return const Center(child: SupersaverModel4Shimmer());
                  } else if (state is SupersaverModel4Loaded) {
                    return Container(
                      color: parseColor(bgColor),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              title,
                              maxLines: 1,
                              style: TextStyle(
                                  color: parseColor(titleColor),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Image.network(
                            bannerimage,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: 355,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.products.length > 5
                                    ? 5
                                    : state.products.length,
                                itemBuilder: (context, index) {
                                  final product = state.products[index];
                                  return ProductModel2(
                                      product: product,
                                      subcategoryref:
                                          product.subCategoryRef.first.id,
                                      productcolor: "000000",
                                      sellingpricecolor: "FFFFFF",
                                      mrpColor: "FFFFFF",
                                      offertextcolor: "FFFFFF",
                                      productBgColor: "DF2401",
                                      buttontextcolor: "E23338",
                                      unitbgcolor: "FFFFFF",
                                      unitTextcolor: "A19DA3",
                                      context: context,
                                      offertextcolor2: "FFFFFF",
                                      offerbordercolor: "FCFF3B",
                                      buttonbgcolor: "FFFFFF",
                                      offerbgcolor1: "DF2401",
                                      offerbgcolor2: "2DB164");
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () => context.push(
                                "/allsubcategorypage?categoryId=${state.products.first.categoryRef.catref}&selectedsubcategory=$subCategoryId"),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.of(context).size.width,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: lightenColor(
                                    parseColor(seeAllButtonBG), .8),
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
                                              color:
                                                  parseColor(seeAllButtontext),
                                              fontSize: 18)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 14.0),
                                        child: Icon(Icons.arrow_forward,
                                            color:
                                                parseColor(seeAllButtontext)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    );
                  } else if (state is SupersaverModel4Error) {
                    return Center(child: Text(state.message));
                  }
                  return Container(
                    height: 199,
                    width: 200,
                    color: Colors.black,
                  );
                },
              ),
            ),
          )
        : const SizedBox();
  }
}
