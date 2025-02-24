import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__state.dart';

import '../../../bloc/category_model_5__Bloc/category_model5__event.dart';
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
    return BlocProvider(
      create: (_) =>
          CategoryBloc5(categoryRepository: Categorymodel5Repository())
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
                                    mainAxisExtent: 216,
                                    child: productItem(
                                      bgcolor: "FFFFFF",
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

Widget productItem({
  required String name,
  required double price,
  required String imageurl,
  required String bgcolor,
  required String productcolor,
  required String sellingpricecolor,
  required String mrpColor,
}) {
  return SizedBox(
    width: 132,
    height: 216,
    child: Stack(
      children: [
        Container(
          height: 216,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: lightenColor(parseColor(bgcolor), .6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: NetworkImage(imageurl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Container(
                height: 35,
                margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: lightenColor(parseColor(productcolor), .8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
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
              Expanded(
                flex: 3,
                child: Center(
                  child: Text("₹$price",
                      style: TextStyle(
                          fontSize: 20,
                          color: parseColor(sellingpricecolor),
                          fontWeight: FontWeight.w800)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text("MRP",
                        style: TextStyle(
                            fontSize: 12, color: parseColor(mrpColor))),
                    Text("₹$price",
                        style: TextStyle(
                            fontSize: 12, color: parseColor(mrpColor))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
