import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/product_model_3.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
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
  final bool showcategory;
  final String subCatID;
  final String offerbgcolor;
  final String offertextcolor;
  final String buttonbgcolor;
  final String buttontextcolor;
  final String unitTextcolor;
  final String unitbgcolor;

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
    required this.showcategory,
    required this.subCatID,
    required this.offerbgcolor,
    required this.offertextcolor,
    required this.buttonbgcolor,
    required this.buttontextcolor,
    required this.unitTextcolor,
    required this.unitbgcolor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (context) =>
                CategoryModel10Bloc(repository: CategoryModel10Repo())
                  ..add(FetchSubCategoryProducts(subCategoryId: subCatID)),
            child: BlocBuilder<CategoryModel10Bloc, CategoryModel10State>(
              builder: (context, state) {
                if (state is CategoryModel10Loading) {
                  return const Center(child: ProductModel1ListShimmer());
                } else if (state is CategoryModel10Loaded) {
                  return _buildCategoryModel10(theme, state.products, context);
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
      ThemeData theme, List<ProductModel> products, BuildContext context) {
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
                      fontWeight: FontWeight.w800),
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
            height: 258,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length > 5 ? 5 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return productModel3(
                  buttontextcolor: seeAllButtontext,
                  buttonBG: buttonbgcolor,
                  buttontext: buttontextcolor,
                  productBgColor: prodoductbgcolor,
                  context: context,
                  offerBGcolor: offerbgcolor,
                  offertextcolor: offertextcolor,
                  productcolor: prodoductbgcolor,
                  sellingpricecolor: sellingpricecolor,
                  theme: theme,
                  product: product,
                  unitTextcolor: unitTextcolor,
                  unitbgcolor: unitbgcolor,
                  mrpColor: mrpcolor,
                  sellingPriceColor: sellingpricecolor,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              context.push(
                  "/allsubcategorypage?=${products.first.subCategoryRef.where((element) => element.id == subCatID).first.categoryRef.catref}&selectedsubcategory=$subCatID");
            },
            child: Container(
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
                            color: parseColor("FFFFFF")),
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

// Widget productsWidget(
//     {required String producttextcolor,
//     required ProductModel product,
//     required String productBackgroundColor,
//     required String bgColor,
//     required String crosscolor,
//     required String mrpColor,
//     required String sellingPriceColor,
//     required String cartButtontextColor}) {
//   return Padding(
//     padding: const EdgeInsets.only(right: 8.0),
//     child: Stack(
//       clipBehavior:
//           Clip.none, // Ensure the offer goes outside the product container
//       children: [
//         Container(
//           width: 150,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: const Color.fromARGB(255, 236, 253, 255),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 height: 190,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: const Color.fromARGB(255, 236, 253, 255),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     product.productImages.first,
//                     fit: BoxFit.contain,
//                     colorBlendMode: BlendMode.color,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 5,
//                       child: Column(
//                         children: [
//                           const Text(
//                             "₹ 50",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.w700),
//                           ),
//                           Text("₹ 75",
//                               style: TextStyle(
//                                   decoration: TextDecoration.lineThrough,
//                                   decorationColor:
//                                       parseColor("A19DA3"), // Change line color
//                                   decorationThickness: 2,
//                                   fontSize: 12,
//                                   color: parseColor("A19DA3"),
//                                   fontWeight: FontWeight.w500))
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 2),
//                     Expanded(
//                       flex: 7,
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: parseColor("E23338"),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           'Add',
//                           style: TextStyle(
//                             color: parseColor("FFFFFF"),
//                             fontWeight: FontWeight.w800,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
