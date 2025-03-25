import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_14_bloc/category_model_14_state.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart'
    show ProductModel1ListShimmer;
import '../../../bloc/home_page_bloc/category_model_14_bloc/category_model_14_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_14_bloc/category_model_14_event.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_subcategory_product_repo.dart';

class CategoryModel14 extends StatelessWidget {
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
  final String producttextcolor;
  final String sellingPriceColor;
  final String indicatercolor;

  const CategoryModel14({
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
    required this.indicatercolor,
    required this.producttextcolor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) =>
          CategoryBloc14(categoryRepository: Categorymodel5Repository())
            ..add(FetchCategoryAndProductsEvent(
              categoryId: categoryId,
              subCategoryIds:
                  maincategories, // Dispatch event to fetch category and products
            )),
      child: SizedBox(
        // color: parseColor(bgcolor),
        width: double.infinity,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            BlocBuilder<CategoryBloc14, CategoryModel14State>(
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
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.subCategories.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      context.read<CategoryBloc14>().add(
                                          UpdateSelectedCategoryModel14Event(
                                              selectedCategoryId: state
                                                  .subCategories[index].id));
                                    },
                                    child: subcategoryItem(
                                        indicatercolor: indicatercolor,
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
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              parseColor("#fcdfbc"),
                              parseColor("#FFFFFF"),
                              parseColor("#FFFFFF")
                            ],
                                stops: const [
                              .5,
                              .73,
                              1
                            ])),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/Screenshot%202025-03-05%20at%206.36.08%E2%80%AFPM.jpeg?alt=media&token=3cf4e8ab-63d4-4e83-b295-13a5b5944b3c"),
                            ),
                            const SizedBox(height: 10),
                            state.products.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: StaggeredGrid.count(
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
                                                  3
                                              ? state.products
                                                  .where((product) => product
                                                      .subCategoryRef
                                                      .any((subCategory) =>
                                                          subCategory.id ==
                                                          state
                                                              .selectedCategoryId))
                                                  .toList()
                                                  .length
                                              : 3, (index) {
                                        return StaggeredGridTile.extent(
                                          crossAxisCellCount: 1,
                                          mainAxisExtent: 266,
                                          child: ProductItem(
                                            productnamecolor: producttextcolor,
                                            product: state.products
                                                .where((product) => product
                                                    .subCategoryRef
                                                    .any((subCategory) =>
                                                        subCategory.id ==
                                                        state
                                                            .selectedCategoryId))
                                                .toList()[index],
                                            buttontextcolor: "E23338",
                                            context: context,
                                            offertextcolor: "000000",
                                            productBgColor: "FFFFFF",

                                            buttonBgColor: "FFFFFF",
                                            sellingPriceColor: "000000",
                                            unitTextcolor: "000000",
                                            unitbgcolor: "FFFFFF",
                                            offerbgcolor: "FFFA76",
                                            // bgcolor: "FFFFFF",
                                            imageurl: state.products
                                                .where((product) => product
                                                    .subCategoryRef
                                                    .any((subCategory) =>
                                                        subCategory.id ==
                                                        state
                                                            .selectedCategoryId))
                                                .toList()[index]
                                                .productImages
                                                .first,
                                            mrpColor: "A19DA3",
                                            name: state.products
                                                .where((product) => product
                                                    .subCategoryRef
                                                    .any((subCategory) =>
                                                        subCategory.id ==
                                                        state
                                                            .selectedCategoryId))
                                                .toList()[index]
                                                .productName,
                                            price: 85,
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                : const SizedBox(
                                    child: Text("No data"),
                                  ),
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.of(context).size.width,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: parseColor("FFF2E2"),
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
                                              color: parseColor("#917337"),
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
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: parseColor("#917337"),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
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
    required String indicatercolor,
    required ThemeData theme,
    required BuildContext context}) {
  return SizedBox(
    width: 120,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              height: 50,
              width: 50,
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
          margin: const EdgeInsets.symmetric(horizontal: 5),
          // width: 100,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: subcatId == selectedId
                ? parseColor(indicatercolor)
                : Colors.transparent,
          ),
        )
      ],
    ),
  );
}
