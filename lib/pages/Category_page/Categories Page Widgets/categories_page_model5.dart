// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:kwik/constants/colors.dart';

// import 'package:kwik/repositories/category_subcategory_product_repo.dart';
// import 'package:kwik/widgets/produc_model_1.dart';

// import '../../../bloc/Categories Page Bloc/categories_page_model5/categories_page_model5_bloc.dart';
// import '../../Home_page/widgets/category_model_13.dart';

// class CategoriesPageModel5 extends StatelessWidget {
//   final String categoryId;
//   final String bgcolor;
//   final String titleColor;
//   final String subcatColor;
//   final String categoryName;
//   final List<String> maincategories;
//   final String brandImage;
//   final String offerBGcolor;
//   final String productBgColor;
//   final String mrpColor;
//   final String sellingPriceColor;
//   const CategoriesPageModel5({
//     super.key,
//     required this.categoryId,
//     required this.bgcolor,
//     required this.titleColor,
//     required this.subcatColor,
//     required this.categoryName,
//     required this.maincategories,
//     required this.offerBGcolor,
//     required this.productBgColor,
//     required this.mrpColor,
//     required this.sellingPriceColor,
//     required this.brandImage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return BlocProvider(
//       create: (_) => CategoriesPageModel5Bloc(
//           categoryRepository: Categorymodel5Repository())
//         ..add(FetchCategoryAndProductsEvent(
//           categoryId: categoryId,
//           subCategoryIds:
//               maincategories, // Dispatch event to fetch category and products
//         )),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//         child: Container(
//           color: parseColor(bgcolor),
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 8,
//                     child: Text(
//                       categoryName,
//                       style: TextStyle(
//                         color: parseColor(titleColor),
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                       flex: 2,
//                       child: Align(
//                           alignment: Alignment.centerRight,
//                           child: Image.network(brandImage, height: 60)))
//                 ],
//               ),
//               const SizedBox(height: 10),
//               BlocBuilder<CategoriesPageModel5Bloc, CategoriesPageModel5State>(
//                 builder: (context, state) {
//                   if (state is SubCategoriesLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is CategoryErrorState) {
//                     return Center(child: Text(state.message));
//                   } else if (state is CategoryLoadedState) {
//                     return Column(
//                       children: [
//                         state.subCategories.isNotEmpty
//                             ? SizedBox(
//                                 height: 128,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: state.subCategories.length,
//                                   itemBuilder: (context, index) {
//                                     return InkWell(
//                                       onTap: () {
//                                         context
//                                             .read<CategoriesPageModel5Bloc>()
//                                             .add(UpdateSelectedCategoryEvent(
//                                                 selectedCategoryId: state
//                                                     .subCategories[index].id));
//                                       },
//                                       child: subcategoryItem(
//                                           name: state.subCategories[index].name,
//                                           bgcolor: "ffffff",
//                                           textcolor: "FFFFFF",
//                                           imageurl: state
//                                               .subCategories[index].imageUrl,
//                                           context: context,
//                                           subcatId:
//                                               state.subCategories[index].id,
//                                           // theme: theme,
//                                           selectedId: state.selectedCategoryId),
//                                     );
//                                   },
//                                 ),
//                               )
//                             : const SizedBox(),
//                         const SizedBox(height: 5),
//                         state.products.isNotEmpty
//                             ? StaggeredGrid.count(
//                                 crossAxisCount: 3,
//                                 mainAxisSpacing: 8,
//                                 crossAxisSpacing: 8,
//                                 children: List.generate(
//                                     state.products
//                                                 .where((product) =>
//                                                     product.subCategoryRef.id ==
//                                                     state.selectedCategoryId)
//                                                 .toList()
//                                                 .length <=
//                                             6
//                                         ? state.products
//                                             .where((product) =>
//                                                 product.subCategoryRef.id ==
//                                                 state.selectedCategoryId)
//                                             .toList()
//                                             .length
//                                         : 6, (index) {
//                                   return StaggeredGridTile.extent(
//                                     crossAxisCellCount: 1,
//                                     mainAxisExtent: 216,
//                                     child: ProductItem(
//                                       product: state.products
//                                           .where((product) =>
//                                               product.subCategoryRef.id ==
//                                               state.selectedCategoryId)
//                                           .toList()[index],
//                                       buttontextcolor: "000000",
//                                       context: context,
//                                       offertextcolor: "FFFFFF",
//                                       productBgColor: "FFFFFF",
//                                       buttonBgColor: "FFFFFF",
//                                       sellingPriceColor: "000000",
//                                       unitTextcolor: "000000",
//                                       offerbgcolor: "FFFFFF",
//                                       imageurl: state.products
//                                           .where((product) =>
//                                               product.subCategoryRef.id ==
//                                               state.selectedCategoryId)
//                                           .toList()[index]
//                                           .productImages
//                                           .first,
//                                       mrpColor: "FFFFFF",
//                                       name: state.products
//                                           .where((product) =>
//                                               product.subCategoryRef.id ==
//                                               state.selectedCategoryId)
//                                           .toList()[index]
//                                           .productName,
//                                       price: 85,
//                                     ),
//                                   );
//                                 }),
//                               )
//                             : const SizedBox(
//                                 child: Text("No data"),
//                               ),
//                       ],
//                     );
//                   }
//                   return const Center(child: Text('No Data Available'));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
