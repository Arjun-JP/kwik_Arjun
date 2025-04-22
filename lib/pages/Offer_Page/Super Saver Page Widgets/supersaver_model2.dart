import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_7.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/super_saver_model2_shimmer.dart';

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
  final String title;
  final String topbanner;
  final bool showCategory;

  final String buttonbgcolor;
  final String unitTextcolor;
  final String unitbgcolor;
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
    required this.title,
    required this.topbanner,
    required this.showCategory,
    required this.buttonbgcolor,
    required this.unitTextcolor,
    required this.unitbgcolor,
  });

  @override
  Widget build(BuildContext context) {
    return showCategory
        ? BlocProvider(
            create: (context) => SupersaverModel2Bloc(
                repository: SubcategoryProductRepository())
              ..add(FetchSubCategoryProductsSS(subCategoryId: subcategoryid)),
            child: BlocBuilder<SupersaverModel2Bloc, SupersaverModel2State>(
              builder: (context, state) {
                if (state is SupersaverModel2Loading) {
                  return const Center(child: SuperSaverModel2Shimmer());
                } else if (state is SupersaverModel2Loaded) {
                  return _buildCategoryModel7(
                      state.products, context, subcategoryid);
                } else if (state is SupersaverModel2Error) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('No data available'));
              },
            ),
          )
        : const SizedBox();
  }

  Widget _buildCategoryModel7(
      List<ProductModel> products, BuildContext context, String subcategoryid) {
    return Container(
      color: parseColor(bgcolor),
      height: 617,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: TextStyle(
                  color: parseColor(titleColor),
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 10),
          Image.network(
            topbanner,
            width: double.infinity,
            height: 200,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 278,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length > 10 ? 10 : products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ProductItem(
                      subcategoryRef: subcategoryid,
                      productnamecolor: productTextColor,
                      product: product,
                      productBgColor: prodoductbgcolor,
                      buttontextcolor: cartbuttontextcolor,
                      context: context,
                      offertextcolor: offerTextcolor,
                      buttonBgColor: buttonbgcolor,
                      offerbgcolor: offerBGcolor,
                      unitTextcolor: unitTextcolor,
                      unitbgcolor: unitbgcolor,
                      mrpColor: mrpcolor,
                      sellingPriceColor: sellingpricecolor,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => context.push(
                "/allsubcategorypage?categoryId=${products.first.categoryRef.catref}&selectedsubcategory=$subcategoryid"),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightenColor(parseColor(seeAllButtonBG), .8)),
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
