import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_state.dart';
import 'package:kwik/repositories/category_model_12_repo.dart';
import 'package:kwik/widgets/produc_model_1.dart';

import '../../../bloc/home_page_bloc/category_model_12_bloc/category_model_12_bloc.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_model9_repo.dart';

class CategoryModel15 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;

  final String subcatColor;

  final List<String> maincategories;
  final String offerTextcolor;

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

  const CategoryModel15({
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
              color: parseColor("E9F5B3"),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/Screenshot%202025-03-06%20at%2011.31.11%E2%80%AFAM.jpeg?alt=media&token=b0a04ee2-5572-4678-bf2d-ea53b63fa6a6",
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CategoryBloc12, CategoryModel12State>(
                    builder: (context, state) {
                      if (state is SubCategoriesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is CategoryLoadedState) {
                        return Column(
                          children: [
                            state.products.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: StaggeredGrid.count(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      children: List.generate(
                                          state.products.length <= 3
                                              ? state.products.length
                                              : 3, (index) {
                                        return StaggeredGridTile.extent(
                                            crossAxisCellCount: 1,
                                            mainAxisExtent: 255,
                                            child: ProductItem(
                                              product: state.products[index],
                                              // bgcolor: "FFFFFF",
                                              context: context,
                                              imageurl: state.products[index]
                                                  .productImages.first,
                                              mrpColor: mrpColor,
                                              name: state
                                                  .products[index].productName,
                                              price: 85,
                                              offertextcolor: offerTextcolor,

                                              buttontextcolor: buttontextcolor,
                                              productBgColor: productBgColor,
                                              sellingPriceColor:
                                                  sellingPriceColor,
                                              unitTextcolor: unitTextcolor,
                                              buttonBgColor: "FFFFFF",
                                              offerbgcolor: seeAllButtonBG,
                                            ));
                                      }),
                                    ),
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: parseColor("FFFFFF")),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('See all products',
                                style: TextStyle(
                                    color: parseColor("000000"), fontSize: 18)),
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
                                color: parseColor("000000"),
                              ),
                            ),
                          ),
                        )
                      ],
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
