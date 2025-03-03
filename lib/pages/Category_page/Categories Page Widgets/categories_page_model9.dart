import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_7.dart';
import 'package:kwik/pages/Home_page/widgets/sale_banner_ribbonclip.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

import '../../../bloc/Categories Page Bloc/categories_page_model9/categories_page_model9_bloc.dart';
import '../../../constants/colors.dart';

class CategoriesPageModel9 extends StatelessWidget {
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


  final String flashBgColor;
  final String flashTextColor;
  const CategoriesPageModel9(
      {super.key,
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
      required this.flashBgColor,
      required this.flashTextColor,
   });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoriesPageModel9Bloc(repository: SubcategoryProductRepository())
            ..add(FetchSubCategoryProducts(subCategoryId: subcategoryid)),
      child: BlocBuilder<CategoriesPageModel9Bloc, CategoriesPageModel9State>(
        builder: (context, state) {
          if (state is CategoriesPageModel9Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriesPageModel9Loaded) {
            return _buildCategoryModel7(state.products, context);
          } else if (state is CategoriesPageModel9Error) {
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
      height: 420,
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
          Center(
            child: Stack(clipBehavior: Clip.none, children: [
              ClipPath(
                clipper: RibbonClipper(),
                child: Container(
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: parseColor(flashBgColor),
                  child: RichText(
                    text: TextSpan(
                      text: "FLASH SALE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: parseColor(flashTextColor)),
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.flash_on,
                          color: parseColor(flashTextColor),
                        ))
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: -5,
                right: -12,
                child: ClipPath(
                  clipper: SmoothWavyCircleClipper(
                    waveCount: 18,
                    waveDepth: 0,
                  ),
                  child: Container(
                    width: 50, // Adjust the size as needed
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.amber,

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
            ]),
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
                color: parseColor(seeAllButtonBG)),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
