import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_state.dart';
import 'package:kwik/repositories/category_model_12_repo.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';

import '../../../bloc/home_page_bloc/category_model_12_bloc/category_model_12_bloc.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_model9_repo.dart';

class CategoryModel12 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String subcatColor;
  final String offerbgcolor;
  final List<String> maincategories;
  final String offerTextcolor;
  final String producttextcolor;
  final String productBgColor;
  final String mrpColor;
  final String sellingPriceColor;
  final String buttontextcolor;
  final String unitbgcolor;
  final String unitTextcolor;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  final String topimage;
  final bool showcategory;
  const CategoryModel12({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.subcatColor,
    required this.maincategories,
    required this.productBgColor,
    required this.mrpColor,
    required this.sellingPriceColor,
    required this.offerTextcolor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
    required this.buttontextcolor,
    required this.unitbgcolor,
    required this.unitTextcolor,
    required this.topimage,
    required this.showcategory,
    required this.producttextcolor,
    required this.offerbgcolor,
  });

  @override
  Widget build(BuildContext context) {
    return showcategory
        ? BlocProvider(
            create: (_) =>
                CategoryBloc12(categoryRepository: Categorymodel12Repository())
                  ..add(FetchCategoryAndProductsEvent(
                    subCategoryIds:
                        maincategories, // Dispatch event to fetch category and products
                  )),
            child: Container(
              color: parseColor(bgcolor),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    topimage,
                    fit: BoxFit.fill,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CategoryBloc12, CategoryModel12State>(
                    builder: (context, state) {
                      if (state is SubCategoriesLoading) {
                        return const Center(child: ProductModel1ListShimmer());
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is CategoryLoadedState) {
                        return Column(
                          children: [
                            state.products.isNotEmpty
                                ? StaggeredGrid.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    children: List.generate(
                                        state.products.length <= 6
                                            ? state.products.length
                                            : 6, (index) {
                                      return StaggeredGridTile.extent(
                                          crossAxisCellCount: 1,
                                          mainAxisExtent: 285,
                                          child: ProductItem(
                                            subcategoryRef: maincategories[0],
                                            productnamecolor: producttextcolor,
                                            product: state.products[index],
                                            context: context,
                                            mrpColor: mrpColor,
                                            offertextcolor: offerTextcolor,
                                            buttontextcolor: buttontextcolor,
                                            productBgColor: productBgColor,
                                            sellingPriceColor:
                                                sellingPriceColor,
                                            unitTextcolor: unitTextcolor,
                                            unitbgcolor: unitbgcolor,
                                            buttonBgColor: seeAllButtonBG,
                                            offerbgcolor: offerbgcolor,
                                          ));
                                    }),
                                  )
                                : const SizedBox(
                                    child: Text("No data"),
                                  ),
                          ],
                        );
                      }
                      return const Center(child: Text('No Data Available'));
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      context.push(
                          "/allsubcategorypage?categoryId=$categoryId&selectedsubcategory=${maincategories.first}");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightenColor(parseColor("E23338"), .8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('See all products',
                                  style: TextStyle(
                                      color: parseColor("#E23338"),
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
                                  color: parseColor("#E23338"),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
