import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_state.dart';
import 'package:kwik/widgets/product_model_2.dart';
import 'package:kwik/widgets/shimmer/category_model_19_shimmer.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_subcategory_product_repo.dart';

class CategoryModel19 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String subcatColor;
  final List<String> maincategories;
  final String topimage;
  final String offerBGcolor1;
  final String offerBGcolor2;
  final String productBgColor;
  final String mrpColor;
  final String sellingPriceColor;
  final String offerBordercolor;
  final bool showcategory;
  final String indicatercolor;
  final String buttontextcolor;
  final String offertextcolor1;
  final String offertextcolor2;
  final String buttonbgcolor;
  final String unitcolor;
  final String unitbgcolor;
  final String producttextcolor;
  final String seeallbgcolorl;
  final String seealltextcolor;

  const CategoryModel19({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.subcatColor,
    required this.maincategories,
    required this.indicatercolor,
    required this.productBgColor,
    required this.sellingPriceColor,
    required this.mrpColor,
    required this.buttontextcolor,
    required this.buttonbgcolor,
    required this.producttextcolor,
    required this.unitcolor,
    required this.unitbgcolor,
    required this.seeallbgcolorl,
    required this.seealltextcolor,
    required this.showcategory,
    required this.offerBGcolor1,
    required this.offerBGcolor2,
    required this.offerBordercolor,
    required this.offertextcolor1,
    required this.offertextcolor2,
    required this.topimage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (_) =>
                CategoryBloc19(categoryRepository: Categorymodel5Repository())
                  ..add(FetchCategoryAndProductsEventCM19(
                    categoryId: categoryId,
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
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      topimage),
                  const SizedBox(height: 10),
                  BlocBuilder<CategoryBloc19, CategoryModel19State>(
                    builder: (context, state) {
                      if (state is SubCategoriesLoading) {
                        return const Center(child: CategoryModel19Shimmer());
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is CategoryLoadedState) {
                        return Column(
                          children: [
                            state.subCategories.isNotEmpty
                                ? SizedBox(
                                    height: 118,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.subCategories.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            context.read<CategoryBloc19>().add(
                                                UpdateSelectedCategoryModel19Event(
                                                    selectedCategoryId: state
                                                        .subCategories[index]
                                                        .id));
                                          },
                                          child: subcategoryItem(
                                              indicatercolor: indicatercolor,
                                              bgcolor: bgcolor,
                                              name: state
                                                  .subCategories[index].name,
                                              textcolor: subcatColor,
                                              imageurl: state
                                                  .subCategories[index]
                                                  .imageUrl,
                                              context: context,
                                              subcatId:
                                                  state.subCategories[index].id,
                                              selectedId:
                                                  state.selectedCategoryId,
                                              theme: theme),
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 5),
                            state.products.isNotEmpty
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 380,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          state.products
                                                      .where((product) => product
                                                          .subCategoryRef
                                                          .any((subCategory) =>
                                                              subCategory.id ==
                                                              state
                                                                  .selectedCategoryId))
                                                      .length <=
                                                  6
                                              ? state.products
                                                  .where((product) => product
                                                      .subCategoryRef
                                                      .any((subCategory) =>
                                                          subCategory.id ==
                                                          state
                                                              .selectedCategoryId))
                                                  .length
                                              : 6, (index) {
                                        return SizedBox(
                                          width: 154,
                                          child: ProductModel2(
                                            product: state.products
                                                .where((product) => product
                                                    .subCategoryRef
                                                    .any((subCategory) =>
                                                        subCategory.id ==
                                                        state
                                                            .selectedCategoryId))
                                                .toList()[index],
                                            subcategoryref:
                                                maincategories.first,
                                            productcolor: productBgColor,
                                            unitbgcolor: unitbgcolor,
                                            buttonbgcolor: buttonbgcolor,
                                            sellingpricecolor:
                                                sellingPriceColor,
                                            offerbgcolor1: offerBGcolor1,
                                            offerbgcolor2: offerBGcolor2,
                                            offerbordercolor: offerBordercolor,
                                            offertextcolor2: offertextcolor2,
                                            offertextcolor: offertextcolor1,
                                            buttontextcolor: buttontextcolor,
                                            unitTextcolor: unitcolor,
                                            context: context,
                                            productBgColor: productBgColor,
                                            mrpColor: mrpColor,
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                : const SizedBox(
                                    child: Text("No data"),
                                  ),
                            InkWell(
                              onTap: () => context.push(
                                  "/allsubcategorypage?categoryId=${state.subCategories.where((element) => element.id == state.selectedCategoryId).first.categoryRef.catref}&selectedsubcategory=${state.selectedCategoryId}"),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                width: MediaQuery.of(context).size.width,
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: parseColor(seeallbgcolorl)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('See all products',
                                            style: TextStyle(
                                                color:
                                                    parseColor(seealltextcolor),
                                                fontSize: 18)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 14.0),
                                          child: Icon(Icons.arrow_forward,
                                              color:
                                                  parseColor(seealltextcolor)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return const Center(child: Text('No Data Available'));
                    },
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

Widget subcategoryItem(
    {required String name,
    required String bgcolor,
    required String textcolor,
    required String imageurl,
    required String indicatercolor,
    required String selectedId,
    required String subcatId,
    required ThemeData theme,
    required BuildContext context}) {
  return SizedBox(
    width: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              height: 66,
              width: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: subcatId == selectedId
                        ? parseColor(indicatercolor)
                        : Colors.transparent),
                color: lightenColor(parseColor(bgcolor), .9),
                image: DecorationImage(
                  image: NetworkImage(imageurl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 70,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: parseColor(textcolor),
                  fontWeight: subcatId == selectedId
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 3),
          width: 100,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: subcatId == selectedId
                ? parseColor(indicatercolor)
                : Colors.white,
          ),
        )
      ],
    ),
  );
}
