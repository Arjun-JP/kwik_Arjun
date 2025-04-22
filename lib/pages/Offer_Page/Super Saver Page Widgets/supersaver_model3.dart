import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_10_bloc/category_model_10_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_10_bloc/category_model_10_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/category_model_10_repo.dart';
import 'package:kwik/widgets/product_model_2.dart';
import 'package:kwik/widgets/shimmer/supersaver_model3_shimmer.dart';

import '../../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_bloc.dart';

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
  final String categoryID;
  final bool showCategory;
  final String offertextcolor;
  final String offerbgcolor;
  final String cartbuttonbg;
  final String producttextcolor;
  final String unitcolor;
  final String offerbordercolor;
  final String offerbgcolor2;
  final String offertextcolor2;

  const SupersaverModel3({
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
    required this.categoryID,
    required this.showCategory,
    required this.offertextcolor,
    required this.offerbgcolor,
    required this.cartbuttonbg,
    required this.producttextcolor,
    required this.unitcolor,
    required this.offerbordercolor,
    required this.offerbgcolor2,
    required this.offertextcolor2,
  });

  @override
  Widget build(BuildContext context) {
    return showCategory
        ? BlocProvider(
            create: (context) =>
                CategoryModel10Bloc(repository: CategoryModel10Repo())
                  ..add(FetchSubCategoryProducts(subCategoryId: categoryID)),
            child: BlocBuilder<CategoryModel10Bloc, CategoryModel10State>(
              builder: (context, state) {
                if (state is CategoryModel10Loading) {
                  return const Center(child: SupersaverModel3Shimmer());
                } else if (state is CategoryModel10Loaded) {
                  return _buildCategoryModel10(
                      state.products, context, categoryID);
                } else if (state is CategoryModel10Error) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('No data available'));
              },
            ),
          )
        : const SizedBox();
  }

  Widget _buildCategoryModel10(
      List<ProductModel> products, BuildContext context, String subcategoryid) {
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
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.network(image, width: 51, height: 51),
              )
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 355,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length > 5 ? 5 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductModel2(
                    product: product,
                    subcategoryref: product.subCategoryRef.first.id,
                    productcolor: producttextcolor,
                    sellingpricecolor: sellingpricecolor,
                    mrpColor: mrpcolor,
                    offertextcolor: offertextcolor,
                    productBgColor: prodoductbgcolor,
                    buttontextcolor: cartbuttontextcolor,
                    unitbgcolor: unitcolor,
                    unitTextcolor: unitcolor,
                    context: context,
                    offertextcolor2: offertextcolor2,
                    offerbordercolor: offerbordercolor,
                    buttonbgcolor: cartbuttonbg,
                    offerbgcolor1: offerbgcolor,
                    offerbgcolor2: offerbgcolor2);
              },
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => context.push(
                "/allsubcategorypage?categoryId=${products.first.categoryRef.catref}&selectedsubcategory=$subcategoryid"),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: lightenColor(parseColor(seeAllButtonBG), .8),
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
                              color: parseColor(seeAllButtontext),
                              fontSize: 18)),
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
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
