import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_14_bloc/category_model_14_state.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/home_model14_shimmer.dart';
import '../../../bloc/home_page_bloc/category_model_14_bloc/category_model_14_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_14_bloc/category_model_14_event.dart';
import '../../../constants/colors.dart';
import '../../../repositories/category_subcategory_product_repo.dart';

class CategoryModel14 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  final String categoryName;
  final List<String> maincategories;
  final String brandImage;
  final String offerBGcolor;
  final String productBgColor;
  final String mrpColor;
  final String producttextcolor;
  final String sellingPriceColor;
  final String indicatercolor;
  final String bgcolor2;
  final String buttontextcolor;
  final String buttonbgcolor;
  final String unitcolor;
  final String unitbgcolor;
  final String offertextcolor;
  final String subcatbgcolor;
  final String seealltextcolor;
  final String seeallbgclr;
  final bool showcategory;

  const CategoryModel14({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.subcatColor,
    required this.categoryName,
    required this.maincategories,
    required this.offerBGcolor,
    required this.productBgColor,
    required this.mrpColor,
    required this.sellingPriceColor,
    required this.brandImage,
    required this.indicatercolor,
    required this.producttextcolor,
    required this.bgcolor2,
    required this.buttontextcolor,
    required this.buttonbgcolor,
    required this.unitcolor,
    required this.unitbgcolor,
    required this.offertextcolor,
    required this.subcatbgcolor,
    required this.seealltextcolor,
    required this.seeallbgclr,
    required this.showcategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (_) =>
                CategoryBloc14(categoryRepository: Categorymodel5Repository())
                  ..add(FetchCategoryAndProductsEvent(
                    categoryId: categoryId,
                    subCategoryIds:
                        maincategories, // Dispatch event to fetch category and products
                  )),
            child: SizedBox(
              // color: parseColor(bgcolor),
              width: double.infinity,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<CategoryBloc14, CategoryModel14State>(
                    builder: (context, state) {
                      if (state is SubCategoriesLoading) {
                        return const Center(child: HomeModel14Shimmer());
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is CategoryLoadedState) {
                        return Column(
                          children: [
                            state.subCategories.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    color: parseColor(subcatbgcolor),
                                    height: 109,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.subCategories
                                          ?.where((element) => maincategories
                                              .contains(element.id))
                                          ?.toList()
                                          .length,
                                      itemBuilder: (context, index) {
                                        List<SubCategoryModel>? filtredsubcat =
                                            state.subCategories
                                                ?.where((element) =>
                                                    maincategories
                                                        .contains(element.id))
                                                ?.toList();
                                        return InkWell(
                                            onTap: () {
                                              context.read<CategoryBloc14>().add(
                                                  UpdateSelectedCategoryModel14Event(
                                                      selectedCategoryId:
                                                          filtredsubcat![index]
                                                              .id));
                                            },
                                            child: filtredsubcat?.length != 0
                                                ? subcategoryItem(
                                                    indicatercolor:
                                                        indicatercolor,
                                                    name: filtredsubcat![index]
                                                        .name,
                                                    bgcolor: "00FFFFFF",
                                                    offer: filtredsubcat![index]
                                                        .offerPercentage,
                                                    textcolor: subcatColor,
                                                    imageurl:
                                                        filtredsubcat[index]
                                                            .imageUrl,
                                                    context: context,
                                                    subcatId:
                                                        filtredsubcat[index].id,
                                                    selectedId: state
                                                        .selectedCategoryId,
                                                    theme: theme)
                                                : const SizedBox());
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    parseColor(bgcolor),
                                    parseColor(bgcolor2),
                                    parseColor(bgcolor2)
                                  ],
                                      stops: const [
                                    .5,
                                    .73,
                                    1
                                  ])),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Image.network(brandImage),
                                  ),
                                  const SizedBox(height: 10),
                                  state.products.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: StaggeredGrid.count(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8,
                                            children: List.generate(
                                                state.products
                                                            .where((product) => product.subCategoryRef.any(
                                                                (subCategory) =>
                                                                    subCategory.id ==
                                                                    state
                                                                        .selectedCategoryId))
                                                            .toList()
                                                            .length <=
                                                        3
                                                    ? state.products
                                                        .where((product) => product
                                                            .subCategoryRef
                                                            .any((subCategory) =>
                                                                subCategory
                                                                    .id ==
                                                                state
                                                                    .selectedCategoryId))
                                                        .toList()
                                                        .length
                                                    : 3, (index) {
                                              return StaggeredGridTile.extent(
                                                crossAxisCellCount: 1,
                                                mainAxisExtent: 278,
                                                child: ProductItem(
                                                  subcategoryRef:
                                                      state.selectedCategoryId,
                                                  productnamecolor:
                                                      producttextcolor,
                                                  product: state.products
                                                      .where((product) => product
                                                          .subCategoryRef
                                                          .any((subCategory) =>
                                                              subCategory.id ==
                                                              state
                                                                  .selectedCategoryId))
                                                      .toList()[index],
                                                  buttontextcolor:
                                                      buttontextcolor,
                                                  context: context,
                                                  offertextcolor:
                                                      offertextcolor,
                                                  productBgColor:
                                                      productBgColor,
                                                  buttonBgColor: buttonbgcolor,
                                                  sellingPriceColor:
                                                      sellingPriceColor,
                                                  unitTextcolor: unitcolor,
                                                  unitbgcolor: unitbgcolor,
                                                  offerbgcolor: offerBGcolor,
                                                  mrpColor: mrpColor,
                                                ),
                                              );
                                            }),
                                          ),
                                        )
                                      : const SizedBox(
                                          child: Text("No data"),
                                        ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      context.push(
                                          "/allsubcategorypage?categoryId=${state.subCategories.where((subcat) => subcat.id == state.selectedCategoryId).first.categoryRef.catref}&selectedsubcategory=${state.selectedCategoryId}");
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: MediaQuery.of(context).size.width,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: parseColor(seeallbgclr),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text('See all products',
                                                  style: TextStyle(
                                                      color: parseColor(
                                                          seealltextcolor),
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
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  color: parseColor(
                                                      seealltextcolor),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
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
    required String offer,
    required String bgcolor,
    required String textcolor,
    required String imageurl,
    required String selectedId,
    required String subcatId,
    required String indicatercolor,
    required ThemeData theme,
    required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: parseColor(bgcolor),
                  image: DecorationImage(
                    image: NetworkImage(imageurl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: parseColor(textcolor),
                  fontWeight: subcatId == selectedId
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            // width: 100,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: subcatId == selectedId
                  ? parseColor(indicatercolor)
                  : Colors.transparent,
            ),
          )
        ],
      ),
    ),
  );
}
