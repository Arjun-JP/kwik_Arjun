import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_7.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';
import 'package:kwik/widgets/produc_model_1.dart';

import '../../../bloc/Super Saver Page Bloc/supersaver_model2_bloc/supersaver_model2_bloc.dart';

class SupersaverModel2 extends StatelessWidget {
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
  const SupersaverModel2({
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
          SupersaverModel2Bloc(repository: SubcategoryProductRepository())
            ..add(FetchSubCategoryProductsSS(subCategoryId: subcategoryid)),
      child: BlocBuilder<SupersaverModel2Bloc, SupersaverModel2State>(
        builder: (context, state) {
          if (state is SupersaverModel2Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SupersaverModel2Loaded) {
            return _buildCategoryModel7(state.products, context);
          } else if (state is SupersaverModel2Error) {
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
      height: 390,
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
          const SizedBox(height: 10),
          SizedBox(
            height: 253,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length > 5 ? 5 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ProductItem(
                    product: product,
                    productBgColor: prodoductbgcolor,
                    buttontextcolor: "000000",
                    context: context,
                    imageurl: product.productImages.first,
                    name: product.productName,
                    offertextcolor: "000000",
                    price: 200,
                    buttonBgColor: "FFFFFF",
                    offerbgcolor: "FFFFFF",
                    unitTextcolor: "000000",
                    mrpColor: mrpcolor,
                    sellingPriceColor: sellingpricecolor,
                  ),
                );
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
