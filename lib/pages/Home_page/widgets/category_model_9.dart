import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../bloc/category_model_9_bloc/category_model_9_bloc.dart';
import '../../../bloc/category_model_9_bloc/category_model_9_event.dart';
import '../../../bloc/category_model_9_bloc/category_model_9_state.dart';
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
  final String unitbgcolor;
  final String unitTextcolor;

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
    required this.buttontextcolor,
    required this.unitbgcolor,
    required this.unitTextcolor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<CategoryBloc9, CategoryModel9State>(
              builder: (context, state) {
                if (state is SubCategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
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
                                  mainAxisExtent: 205,
                                  child: productItem(
                                    // bgcolor: "FFFFFF",
                                    imageurl: state
                                        .products[index].productImages.first,
                                    mrpColor: mrpColor,
                                    name: state.products[index].productName,
                                    price: 85,
                                    offertextcolor: offerTextcolor,
                                    productcolor: productBgColor,
                                    sellingpricecolor: sellingPriceColor,
                                    buttontextcolor: buttontextcolor,
                                    offerBGcolor: offerBGcolor,
                                    productBgColor: productBgColor,
                                    sellingPriceColor: sellingPriceColor,
                                    unitTextcolor: unitTextcolor,
                                    unitbgcolor: unitbgcolor,
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightenColor(parseColor(buttontextcolor), .9)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('See all products',
                          style: TextStyle(
                              color: parseColor(buttontextcolor),
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
                          color: parseColor("00AE11"),
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
    );
  }
}

Widget productItem({
  required String name,
  required double price,
  required String imageurl,
  required String productcolor,
  required String sellingpricecolor,
  required String mrpColor,
  required String offertextcolor,
  required String offerBGcolor,
  required String productBgColor,
  required String sellingPriceColor,
  required String buttontextcolor,
  required String unitbgcolor,
  required String unitTextcolor,
}) {
  return SizedBox(
    width: 132,
    child: Stack(
      clipBehavior: Clip.none, // Allows elements to overflow
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: const Color.fromARGB(255, 233, 255, 234),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 5,
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageurl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          color: parseColor(unitbgcolor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "100 g",
                          style: TextStyle(
                              fontSize: 12, color: parseColor(unitTextcolor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 120,
                child: Text(
                  "Lay’s American Style Cream & Onion Potato C..",
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: parseColor(offerBGcolor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("Upto",
                      style: TextStyle(
                          fontSize: 10,
                          color: parseColor(offertextcolor),
                          fontWeight: FontWeight.w500)),
                ),
                Column(
                  children: [
                    Text("20% OFF",
                        style: TextStyle(
                            fontSize: 10, color: parseColor(offertextcolor))),
                  ],
                ),
              ],
            ),
          ),
        ),
  
        Positioned(
          top: 85,
          right: -10,
          child:
           Container(
            height: 35,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: lightenColor(parseColor(buttontextcolor), .8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: parseColor(buttontextcolor)),
              boxShadow: [
                BoxShadow(
                  color: parseColor(buttontextcolor),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Add",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: parseColor(buttontextcolor),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
