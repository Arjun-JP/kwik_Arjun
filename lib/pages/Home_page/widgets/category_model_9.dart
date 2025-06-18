import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/widgets/product_model_3.dart';
import 'package:kwik/widgets/shimmer/category_model_9_shimmer.dart';
import '../../../bloc/home_page_bloc/category_model_9_bloc/category_model_9_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_9_bloc/category_model_9_event.dart';
import '../../../bloc/home_page_bloc/category_model_9_bloc/category_model_9_state.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_model9_repo.dart';

class CategoryModel9 extends StatelessWidget {
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
  final String buttonbgcolor;
  final String unitbgcolor;
  final String unitTextcolor;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  final bool showcategory;

  const CategoryModel9({
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
    required this.showcategory,
    required this.buttonbgcolor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (_) =>
                CategoryBloc9(categoryRepository: Categorymodel9Repository())
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
                  Text(
                    title,
                    style: TextStyle(
                      color: parseColor(titleColor),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CategoryBloc9, CategoryModel9State>(
                    builder: (context, state) {
                      if (state is SubCategoriesLoading) {
                        return const Center(child: CategoryModel9Shimmer());
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is CategoryLoadedState) {
                        return Column(
                          children: [
                            state.products.isNotEmpty
                                ? StaggeredGrid.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 25,
                                    crossAxisSpacing: 25,
                                    children: List.generate(
                                        state.products.length <= 6
                                            ? state.products.length
                                            : 6, (index) {
                                      return StaggeredGridTile.extent(
                                        crossAxisCellCount: 1,
                                        mainAxisExtent: 260,
                                        child: InkWell(
                                          onTap: () => context.push(
                                            '/productdetails',
                                            extra: {
                                              'product': state.products[index],
                                              'subcategoryref':
                                                  maincategories.first,
                                            },
                                          ),
                                          child: productModel3(
                                              // bgcolor: "FFFFFF",
                                              product: state.products[index],
                                              mrpColor: mrpColor,
                                              offertextcolor: offerTextcolor,
                                              productcolor: productBgColor,
                                              sellingpricecolor:
                                                  sellingPriceColor,
                                              context: context,
                                              buttontextcolor: buttontextcolor,
                                              offerBGcolor: offerBGcolor,
                                              productBgColor: productBgColor,
                                              sellingPriceColor:
                                                  sellingPriceColor,
                                              unitTextcolor: unitTextcolor,
                                              unitbgcolor: unitbgcolor,
                                              buttonBG: buttonbgcolor,
                                              buttontext: buttontextcolor,
                                              theme: theme),
                                        ),
                                      );
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
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => context.push(
                        "/allsubcategorypage?categoryId=$categoryId&selectedsubcategory=${maincategories.first}"),
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
