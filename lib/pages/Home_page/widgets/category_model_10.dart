import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import '../../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_event.dart';
import '../../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_state.dart';
import '../../../repositories/category_model_10_repo.dart';

class CategoryModel10 extends StatelessWidget {
  final String bgcolor;
  final String titleColor;
  final String prodoductbgcolor;
  final String productTextColor;
  final String mrpcolor;
  final String sellingpricecolor;
  final String crosscolor;
  final String cartbuttontextcolor;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  final String title;
  final String image;
  const CategoryModel10({
    super.key,
    required this.bgcolor,
    required this.titleColor,
    required this.prodoductbgcolor,
    required this.productTextColor,
    required this.mrpcolor,
    required this.sellingpricecolor,
    required this.cartbuttontextcolor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
    required this.crosscolor,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryModel10Bloc(repository: CategoryModel10Repo())
            ..add(FetchSubCategoryProducts(
                subCategoryId: '6780ff720bfef51d79df1a06')),
      child: BlocBuilder<CategoryModel10Bloc, CategoryModel10State>(
        builder: (context, state) {
          if (state is CategoryModel10Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryModel10Loaded) {
            return _buildCategoryModel10(state.products, context);
          } else if (state is CategoryModel10Error) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildCategoryModel10(
      List<ProductModel> products, BuildContext context) {
    return Container(
      color: parseColor(bgcolor),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                      color: parseColor(titleColor),
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.network(image, width: 51, height: 51),
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 248,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length > 5 ? 5 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return productsWidget(
                    bgColor: prodoductbgcolor,
                    product: product,
                    productBackgroundColor: prodoductbgcolor,
                    producttextcolor: productTextColor,
                    crosscolor: crosscolor,
                    mrpColor: mrpcolor,
                    sellingPriceColor: sellingpricecolor,
                    cartButtontextColor: cartbuttontextcolor);
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: parseColor(seeAllButtonBG),
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
                            color: parseColor(seeAllButtontext), fontSize: 18)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Icon(Icons.arrow_forward,
                          color: parseColor(seeAllButtontext)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

Widget productsWidget(
    {required String producttextcolor,
    required ProductModel product,
    required String productBackgroundColor,
    required String bgColor,
    required String crosscolor,
    required String mrpColor,
    required String sellingPriceColor,
    required String cartButtontextColor}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Stack(
      clipBehavior:
          Clip.none, // Ensure the offer goes outside the product container
      children: [
        Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 190,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: parseColor(bgColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/image.png?alt=media&token=b46f34c1-0560-47c3-b611-c0105f96ded2",
                    fit: BoxFit.fill,
                    colorBlendMode: BlendMode.color,
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     vertical: 5,
              //     horizontal: 8.0,
              //   ),
              //   child: Expanded(
              //     child: Text(
              //       product.productName,
              //       textAlign: TextAlign.left,
              //       maxLines: 2,
              //       style: TextStyle(
              //         fontWeight: FontWeight.w500,
              //         color: parseColor(producttextcolor),
              //         fontSize: 12,
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const Text(
                            "₹ 50",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Text("₹ 75",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: parseColor(
                                      crosscolor), // Change line color
                                  decorationThickness: 2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 7,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              lightenColor(parseColor(cartButtontextColor), .8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: parseColor(cartButtontextColor),
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
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
