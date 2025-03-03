import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../bloc/category_model_9_bloc/category_model_9_bloc.dart';
import '../../../bloc/category_model_9_bloc/category_model_9_event.dart';
import '../../../bloc/category_model_9_bloc/category_model_9_state.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_model9_repo.dart';

class CategoryModel12 extends StatelessWidget {
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
  final String topimage;

  const CategoryModel12({
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
    required this.topimage,
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
            Image.network(
              topimage,
              fit: BoxFit.fill,
              height: 200,
              width: MediaQuery.of(context).size.width,
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
                                  mainAxisExtent: 255,
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
                                      seeAllButtonBG: seeAllButtonBG,
                                      seeAllButtontext: seeAllButtontext),
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
                  color: const Color.fromARGB(255, 246, 191, 187)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('See all products',
                          style: TextStyle(
                              color: parseColor("#E23338"), fontSize: 18)),
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
  required String seeAllButtonBG,
  required String seeAllButtontext,
}) {
  return SizedBox(
    child: Stack(
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
                height: 147,
                decoration: BoxDecoration(
                  color: parseColor("F9F9F9"),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(image: NetworkImage(imageurl))),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "100 g",
                      style: TextStyle(
                          fontSize: 12, color: parseColor(unitTextcolor)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 120,
                child: Text(
                  "Lays Water ChipsSalt N Pepper Fl...",
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    children: [
                      Text(
                        "₹ 45",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12),
                      ),
                      Text(
                        "₹ 85",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: parseColor("#FFFFFF"),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: parseColor("#E23338")),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(0)),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: parseColor("#E23338"),
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: 40,
          height: 55,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/offer_bg.png",
                ),
                fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "30%",
                style: TextStyle(
                    color: parseColor("233D4D"),
                    fontSize: 12,
                    fontWeight: FontWeight.w800),
              ),
              Text("OFF",
                  style: TextStyle(
                      color: parseColor("233D4D"),
                      fontSize: 12,
                      fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ],
    ),
  );
}
