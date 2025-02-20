import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/category_model_7_bloc/category_model_7_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import '../../../bloc/category_model_7_bloc/category_model_7_bloc.dart';
import '../../../bloc/category_model_7_bloc/category_model_7_state.dart';
import '../../../repositories/sub_category_product_repository.dart';

class CategoryModel7 extends StatelessWidget {
  final String subcategoryid;
  final String bgcolor;
  final String titleColor;
  final String prodoductbgcolor;
  final String productTextColor;
  final String mrpcolor;
  final String sellingpricecolor;
  final String cartbuttontextcolor;
  final String offerTextcolor;
  final String offerBGcolor;
  final String seeAllButtonBG;
  final String seeAllButtontext;

  const CategoryModel7({
    super.key,
    required this.bgcolor,
    required this.titleColor,
    required this.prodoductbgcolor,
    required this.productTextColor,
    required this.mrpcolor,
    required this.sellingpricecolor,
    required this.cartbuttontextcolor,
    required this.offerTextcolor,
    required this.offerBGcolor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
    required this.subcategoryid,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryModel7Bloc(repository: SubcategoryProductRepository())
            ..add(FetchSubCategoryProducts(subCategoryId: subcategoryid)),
      child: BlocBuilder<CategoryModel7Bloc, CategoryModel7State>(
        builder: (context, state) {
          if (state is CategoryModel7Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryModel7Loaded) {
            return _buildCategoryModel7(state.products, context);
          } else if (state is CategoryModel7Error) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildCategoryModel7(
      List<ProductModel> products, BuildContext context) {
    return Container(
      color: parseColor(bgcolor),
      height: 363,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Explore Dairy Products",
            style: TextStyle(
                color: parseColor(titleColor),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 243,
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
                    offerTextColor: offerTextcolor,
                    offerBgColor: offerBGcolor,
                    mrpColor: mrpcolor,
                    sellingPriceColor: sellingpricecolor,
                    cartButtontextColor: cartbuttontextcolor);
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFEEF3F2)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('See all products',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 14.0),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                )
              ],
            ),
          ),
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
    required String offerTextColor,
    required String offerBgColor,
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
          height: 243,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: parseColor(bgColor),
                  ),
                  child: Image.network(
                    product.productImages.first,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        product.productName,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: parseColor(producttextcolor),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "180",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: parseColor(mrpColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '500g',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: parseColor(producttextcolor),
                      ),
                    ),
                    Text(
                      "120",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: parseColor(sellingPriceColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: 140,
                  height: 40,
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
                      'Add to Cart',
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
        ),
        Positioned(
          top: 0, // Make the offer container come out of the product container
          right: -6, // Position it on the top right
          child: ClipPath(
            clipper: SmoothWavyCircleClipper(
              waveCount: 18,
              waveDepth: 0,
            ),
            child: Container(
              width: 40, // Adjust the size as needed
              height: 40,
              decoration: BoxDecoration(
                color: Colors.amber,
                // border: Border.all(
                //   // color: Colors.green,
                //   width: 3, // Adjust the width of the border
                // ),
                borderRadius: BorderRadius.circular(20), // Circular shape
              ),
              child: const Center(
                child: Text(
                  "50%", // Offer percentage
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class SmoothWavyCircleClipper extends CustomClipper<Path> {
  final int waveCount;
  final double waveDepth;

  SmoothWavyCircleClipper({this.waveCount = 8, this.waveDepth = 3});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double angleStep = (8 * pi) / waveCount;

    for (int i = 0; i <= waveCount; i++) {
      double angle = i * angleStep;
      double waveRadius =
          radius + waveDepth * sin(angle * 2); // Smooth wave effect

      double x = centerX + waveRadius * cos(angle);
      double y = centerY + waveRadius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        double prevAngle = (i - 1) * angleStep;
        double prevX = centerX + waveRadius * cos(prevAngle);
        double prevY = centerY + waveRadius * sin(prevAngle);

        path.quadraticBezierTo(
          (prevX + x) / 2, (prevY + y) / 2, // Smooth transition
          x, y,
        );
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
