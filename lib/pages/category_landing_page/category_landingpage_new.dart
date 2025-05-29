import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page__state.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page_bloc.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/repositories/category_landing_page_repo.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/widgets/product_model_3.dart';
import 'package:kwik/widgets/shimmer/category_landing_shimmer.dart';

class CategoryLandingPageNew extends StatefulWidget {
  final Category category;
  final List<String> subcategoryIDs;

  const CategoryLandingPageNew({
    super.key,
    required this.category,
    required this.subcategoryIDs,
  });

  @override
  State<CategoryLandingPageNew> createState() => _CategoryLandingPageNewState();
}

class _CategoryLandingPageNewState extends State<CategoryLandingPageNew> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (context) => CategoryLandingpageBloc(
        categoryRepository: CategoryLandingPageRepo(),
      )..add(FetchCategoryAndProductsEventcategorylandiongpage(
          categoryId: widget.category.catref,
          subCategoryIds: widget.subcategoryIDs,
        )),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: BlocBuilder<CategoryLandingpageBloc, CategorylandingpageState>(
          builder: (context, state) {
            if (state is SubCategoriesLoading) {
              return const Center(child: CategoryLandingPageShimmmer());
            } else if (state is CategoryErrorState) {
              return Center(child: Text(state.message));
            } else if (state is CategoryLoadedState) {
              // Filter out already shown subcategories (first 6)
              final List<SubCategoryModel> remainingSubcategories = state
                  .subCategories
                  .where((subcat) =>
                      subcat.id != null &&
                      !widget.subcategoryIDs.contains(subcat.id) &&
                      subcat.categoryRef.catref == widget.category.catref)
                  .toList();

              List<String> mainsubcart = widget.category.selectedSubCategoryRef!
                  .map((item) => item.toString())
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // color: const Color.fromARGB(255, 255, 240, 194),
                          image: DecorationImage(
                        image: NetworkImage(widget.category.bannerImage),
                        fit: BoxFit.cover,
                      )),
                      child: Column(
                        children: [
                          SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context.pop();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 25,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.push('/searchpage');
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/search.svg",
                                      width: 25,
                                      height: 25,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 130),
                          SubcategoryList(
                            category: widget.category,
                            subcategories: state.subCategories
                                .where((element) =>
                                    mainsubcart.contains(element.id))
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: remainingSubcategories.map((subcategory) {
                          final List<ProductModel> filteredProducts = state
                              .products
                              .where((product) => product.subCategoryRef
                                  .where(
                                      (element) => element.id == subcategory.id)
                                  .isNotEmpty)
                              .toList();

                          return filteredProducts.isNotEmpty
                              ? InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    height: 320,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(height: 1),
                                        Text(
                                          subcategory.name,
                                          style: theme.textTheme.titleLarge,
                                        ),
                                        SizedBox(
                                          height: 280,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: filteredProducts.length,
                                            itemBuilder: (context, idx) {
                                              ProductModel product =
                                                  filteredProducts[idx];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 130,
                                                  child: productModel3(
                                                    buttontextcolor: "E23338",
                                                    product: product,
                                                    mrpColor: "000000",
                                                    context: context,
                                                    seeAllButtontext: "000000",
                                                    sellingpricecolor: "000000",
                                                    theme: theme,
                                                    offertextcolor: "FFFFFF",
                                                    unitbgcolor: "FFFFFF",
                                                    productBgColor: "FFFFFF",
                                                    productcolor: "000000",
                                                    sellingPriceColor: "000000",
                                                    seeAllButtonBG: "FFFFFF",
                                                    unitTextcolor: "000000",
                                                    offerBGcolor: "E3520D",
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const DescriptiveWidget(
                      title: "Skip the store, we're at your door!",
                      logo: "assets/images/kwiklogo.png",
                      showcategory: true,
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class SubcategoryList extends StatelessWidget {
  final Category category;

  final List<SubCategoryModel> subcategories;

  const SubcategoryList({
    super.key,
    required this.category,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: StaggeredGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
          subcategories.length > 6 ? 6 : subcategories.length,
          (index) => InkWell(
            onTap: () {
              context.push(
                  "/allsubcategorypage?categoryId=${subcategories[index].categoryRef.catref}&selectedsubcategory=${subcategories[index].id}");
            },
            child: SizedBox(
              height: 130,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      height: 90,
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFFFFF),
                            lightenColor(parseColor(category.color), .9),
                            lightenColor(parseColor(category.color), .8),
                            lightenColor(parseColor(category.color), .7),
                            lightenColor(parseColor(category.color), .6),
                            lightenColor(parseColor(category.color), .5),
                            lightenColor(parseColor(category.color), .4),
                            lightenColor(parseColor(category.color), .3),
                            lightenColor(parseColor(category.color), .2),
                            lightenColor(parseColor(category.color), .1),
                            parseColor(category.color),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 230, 230, 230),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subcategories[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                subcategories[index].imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
