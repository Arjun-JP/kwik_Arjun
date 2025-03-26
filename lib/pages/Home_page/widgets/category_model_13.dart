import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_state.dart';
import 'package:kwik/repositories/category_model_13_repo.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
import '../../../constants/colors.dart';

class CategoryModel13 extends StatelessWidget {
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
  final String producttextcolor;

  const CategoryModel13({
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
    required this.producttextcolor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoryBloc13(categoryRepository: Categorymodel13Repository())
            ..add(FetchCategoryAndProductsEvent(
              categoryId: categoryId,
              subCategoryIds:
                  maincategories, // Dispatch event to fetch category and products
            )),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      style: TextStyle(
                        color: parseColor(titleColor),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
              BlocBuilder<CategoryBloc13, CategoryModel13State>(
                builder: (context, state) {
                  if (state is SubCategoriesLoading) {
                    return const Center(child: ProductModel1ListShimmer());
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
                                        context.read<CategoryBloc13>().add(
                                            UpdateSelectedCategoryModel13Event(
                                                selectedCategoryId: state
                                                    .subCategories[index].id));
                                      },
                                      child: subcategoryItem(
                                          name: state.subCategories[index].name,
                                          bgcolor: "ffffff",
                                          textcolor: "FFFFFF",
                                          imageurl: state
                                              .subCategories[index].imageUrl,
                                          context: context,
                                          subcatId:
                                              state.subCategories[index].id,
                                          selectedId: state.selectedCategoryId),
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
                                                .where((product) => product
                                                    .subCategoryRef
                                                    .any((subCategory) =>
                                                        subCategory.id ==
                                                        state
                                                            .selectedCategoryId))
                                                .toList()
                                                .length <=
                                            6
                                        ? state.products
                                            .where((product) => product
                                                .subCategoryRef
                                                .any((subCategory) =>
                                                    subCategory.id ==
                                                    state.selectedCategoryId))
                                            .length
                                        : 6, (index) {
                                  return StaggeredGridTile.extent(
                                    crossAxisCellCount: 1,
                                    mainAxisExtent: 216,
                                    child: ProductItem(
                                      subcategoryRef: categoryId,
                                      productnamecolor: producttextcolor,
                                      product: state.products
                                          .where((product) => product
                                              .subCategoryRef
                                              .any((subCategory) =>
                                                  subCategory.id ==
                                                  state.selectedCategoryId))
                                          .toList()[index],
                                      buttontextcolor: "000000",
                                      context: context,
                                      offertextcolor: "FFFFFF",
                                      productBgColor: "FFFFFF",
                                      buttonBgColor: "FFFFFF",
                                      sellingPriceColor: "000000",
                                      unitTextcolor: "000000",
                                      unitbgcolor: "FFFFFF",
                                      offerbgcolor: "FFFFFF",
                                      imageurl: state.products
                                          .where((product) => product
                                              .subCategoryRef
                                              .any((subCategory) =>
                                                  subCategory.id ==
                                                  state.selectedCategoryId))
                                          .toList()[index]
                                          .productImages
                                          .first,
                                      mrpColor: "FFFFFF",
                                      name: state.products
                                          .where((product) => product
                                              .subCategoryRef
                                              .any((subCategory) =>
                                                  subCategory.id ==
                                                  state.selectedCategoryId))
                                          .toList()[index]
                                          .productName,
                                      price: 85,
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
            const SizedBox(height: 5),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    subcatId == selectedId ? FontWeight.w800 : FontWeight.w500,
                color: parseColor(textcolor),
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
