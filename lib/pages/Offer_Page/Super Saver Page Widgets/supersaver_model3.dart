import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/category_model_10_bloc/category_model_10_event.dart';
import 'package:kwik/bloc/category_model_10_bloc/category_model_10_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_10.dart';
import 'package:kwik/repositories/category_model_10_repo.dart';

import '../../../bloc/category_model_10_bloc/category_model_10_bloc.dart';

class SupersaverModel3 extends StatelessWidget {
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
  const SupersaverModel3({super.key,
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
    required this.image,});

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

