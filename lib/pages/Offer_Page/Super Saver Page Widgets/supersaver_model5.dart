import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_9.dart';
import 'package:kwik/repositories/category_model9_repo.dart';
import 'package:kwik/widgets/produc_model_1.dart';

import '../../../bloc/Super Saver Page Bloc/supersaver_model5_bloc/supersaver_model5_bloc.dart';

class SupersaverModel5 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  final String title;
  final List<String> maincategories;
  final String offerTextcolor;
  final String offerBGcolor;
  final String productBgColor;
  final String mrpColor;
  final String sellingPriceColor;
  final String buttontextcolor;
  final String unitbgcolor;
  final String unitTextcolor;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  const SupersaverModel5({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.subcatColor,
    required this.title,
    required this.maincategories,
    required this.offerBGcolor,
    required this.productBgColor,
    required this.mrpColor,
    required this.sellingPriceColor,
    required this.offerTextcolor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
    required this.buttontextcolor,
    required this.unitbgcolor,
    required this.unitTextcolor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) =>
          SupersaverModel5Bloc(categoryRepository: Categorymodel9Repository())
            ..add(FetchCategoryAndProductsSS5Event(
              subCategoryIds:
                  maincategories, // Dispatch event to fetch category and products
            )),
      child: Container(
        color: lightenColor(parseColor(bgcolor), .8),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: parseColor(titleColor),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<SupersaverModel5Bloc, SupersaverModel5State>(
              builder: (context, state) {
                if (state is SupersaverModel5Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryErrorState) {
                  return Center(child: Text(state.message));
                } else if (state is SupersaverModel5LoadedState) {
                  return Column(
                    children: [
                      state.products.isNotEmpty
                          ? StaggeredGrid.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 25,
                              crossAxisSpacing: 25,
                              children: List.generate(
                                  state.products.length <= 10
                                      ? state.products.length
                                      : 10, (index) {
                                return StaggeredGridTile.extent(
                                  crossAxisCellCount: 1,
                                  mainAxisExtent: 275,
                                  child: ProductItem(
                                    subcategoryRef: categoryId,
                                    productnamecolor: subcatColor,
                                    // bgcolor: "FFFFFF",
                                    product: state.products[index],

                                    mrpColor: mrpColor,

                                    offertextcolor: offerTextcolor,
                                    buttonBgColor: productBgColor,

                                    buttontextcolor: buttontextcolor,
                                    context: context,
                                    productBgColor: productBgColor,
                                    sellingPriceColor: sellingPriceColor,
                                    unitTextcolor: unitTextcolor,
                                    unitbgcolor: unitbgcolor,
                                    offerbgcolor: unitbgcolor,
                                  ),
                                );
                              }),
                            )
                          : const SizedBox(
                              child: Text("No data"),
                            ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () => context.push(
                            "/allsubcategorypage?categoryId=${state.products.first.categoryRef.catref}&selectedsubcategory=$categoryId"),
                        child: Container(
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
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: parseColor(seeAllButtontext),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: Text('No Data Available'));
              },
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
