import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/bloc/category_model_12_bloc/category_model_12_event.dart';
import 'package:kwik/bloc/category_model_12_bloc/category_model_12_satte.dart';
import 'package:kwik/repositories/category_model_12_repo.dart';

import '../../../bloc/category_model_12_bloc/category_model_12_bloc.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_model9_repo.dart';

class CategoryModel12 extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
                                      context: context,
                                      imageurl: state
                                          .products[index].productImages.first,
                                      mrpColor: mrpColor,
                                      name: state.products[index].productName,
                                      price: 85,
                                      offertextcolor: offerTextcolor,
                                      productcolor: productBgColor,
                                      sellingpricecolor: sellingPriceColor,
                                      buttontextcolor: buttontextcolor,
                                      productBgColor: productBgColor,
                                      sellingPriceColor: sellingPriceColor,
                                      unitTextcolor: unitTextcolor,
                                      unitbgcolor: unitbgcolor,
                                      seeAllButtonBG: seeAllButtonBG,
                                      seeAllButtontext: seeAllButtontext,
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
            Container(
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
  required String productBgColor,
  required String sellingPriceColor,
  required String buttontextcolor,
  required String unitbgcolor,
  required String unitTextcolor,
  required String seeAllButtonBG,
  required String seeAllButtontext,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
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
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(imageurl), fit: BoxFit.fill)),
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
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: parseColor(unitTextcolor),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  "Lays Water ChipsSalt N Pepper Fl...",
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: parseColor(unitTextcolor),
                      fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "₹ 45",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: parseColor(unitTextcolor),
                            decoration: TextDecoration.lineThrough),
                      ),
                      Text(
                        "₹ 85",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: parseColor(unitTextcolor),
                            fontWeight: FontWeight.w600),
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
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: parseColor("E23338"),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        ClipPath(
          clipper: ZigZagClipper(),
          child: Container(
            width: 40,
            height: 50,
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "30%",
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: parseColor("233D4D"),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  "OFF",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: parseColor("233D4D"),
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 10);

    double x = 0;
    double y = size.height - 10;
    double step = size.width / 10;

    for (int i = 0; i < 10; i++) {
      x += step;
      y = (i % 2 == 0) ? size.height : size.height - 10;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(ZigZagClipper oldClipper) => false;
}
