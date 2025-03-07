import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__state.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import '../../../bloc/home_page_bloc/category_model_5__Bloc/category_model5__event.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_subcategory_product_repo.dart';

class CategoryModel5 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  final String categoryName;
  final List<String> maincategories;
  final String brandImage;
  final String offerBGcolor;
  final String productBgColor;
  final String mrpColor;
  final String sellingPriceColor;

  const CategoryModel5({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.subcatColor,
    required this.categoryName,
    required this.maincategories,
    required this.offerBGcolor,
    required this.productBgColor,
    required this.mrpColor,
    required this.sellingPriceColor,
    required this.brandImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) =>
          CategoryBloc5(categoryRepository: Categorymodel5Repository())
            ..add(FetchCategoryAndProductsEvent(
              categoryId: categoryId,
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
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    categoryName,
                    style: theme.textTheme.titleLarge!.copyWith(
                        color: parseColor(titleColor),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.network(brandImage, height: 60)))
              ],
            ),
            const SizedBox(height: 10),
            BlocBuilder<CategoryBloc5, CategoryState>(
              builder: (context, state) {
                if (state is SubCategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryErrorState) {
                  return Center(child: Text(state.message));
                } else if (state is CategoryLoadedState) {
                  return Column(
                    children: [
                      state.subCategories.isNotEmpty
                          ? SizedBox(
                              height: 128,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.subCategories.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      context.read<CategoryBloc5>().add(
                                          UpdateSelectedCategoryEvent(
                                              selectedCategoryId: state
                                                  .subCategories[index].id));
                                    },
                                    child: subcategoryItem(
                                        name: state.subCategories[index].name,
                                        bgcolor: "ffffff",
                                        textcolor: "000000",
                                        imageurl:
                                            state.subCategories[index].imageUrl,
                                        context: context,
                                        subcatId: state.subCategories[index].id,
                                        selectedId: state.selectedCategoryId,
                                        theme: theme),
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 5),
                      state.products.isNotEmpty
                          ? StaggeredGrid.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              children: List.generate(
                                  state.products
                                              .where((product) =>
                                                  product.subCategoryRef.id ==
                                                  state.selectedCategoryId)
                                              .toList()
                                              .length <=
                                          6
                                      ? state.products
                                          .where((product) =>
                                              product.subCategoryRef.id ==
                                              state.selectedCategoryId)
                                          .toList()
                                          .length
                                      : 6, (index) {
                                return StaggeredGridTile.extent(
                                  crossAxisCellCount: 1,
                                  mainAxisExtent: 266,
                                  child: ProductItem(
                                    buttontextcolor: "E23338",
                                    context: context,
                                    offertextcolor: "FFFFFF",
                                    productBgColor: "FFFFFF",
                                    seeAllButtonBG: "000000",
                                    seeAllButtontext: "FFFFFF",
                                    sellingPriceColor: "000000",
                                    unitTextcolor: "000000",
                                    unitbgcolor: "FFFFFF",
                                    // bgcolor: "FFFFFF",
                                    imageurl: state.products
                                        .where((product) =>
                                            product.subCategoryRef.id ==
                                            state.selectedCategoryId)
                                        .toList()[index]
                                        .productImages
                                        .first,
                                    mrpColor: "FFFFFF",
                                    name: state.products
                                        .where((product) =>
                                            product.subCategoryRef.id ==
                                            state.selectedCategoryId)
                                        .toList()[index]
                                        .productName,
                                    price: 85,
                                    productcolor: "670000",
                                    sellingpricecolor: "00000",
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
          ],
        ),
      ),
    );
  }
}

Widget subcategoryItem(
    {required String name,
    required String bgcolor,
    required String textcolor,
    required String imageurl,
    required String selectedId,
    required String subcatId,
    required ThemeData theme,
    required BuildContext context}) {
  return SizedBox(
    width: 117,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: parseColor(bgcolor),
                image: DecorationImage(
                  image: NetworkImage(imageurl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: parseColor(textcolor),
                fontWeight:
                    subcatId == selectedId ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 3),
          width: 100,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: subcatId == selectedId ? Colors.white : Colors.transparent,
          ),
        )
      ],
    ),
  );
}
