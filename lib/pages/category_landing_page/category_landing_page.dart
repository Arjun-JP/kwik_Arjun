import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page__state.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page_bloc.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page_event.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';
import 'package:kwik/repositories/category_landing_page_repo.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/widgets/product_model_2.dart';

class CategoryLandingPage extends StatefulWidget {
  final Category category;
  final List<String> subcategoryIDs;

  const CategoryLandingPage({
    super.key,
    required this.category,
    required this.subcategoryIDs,
  });

  @override
  State<CategoryLandingPage> createState() => _CategoryLandingPageState();
}

class _CategoryLandingPageState extends State<CategoryLandingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryLandingpageBloc(
        categoryRepository: CategoryLandingPageRepo(),
      )..add(FetchCategoryAndProductsEventcategorylandiongpage(
          categoryId: widget.category.catref,
          subCategoryIds: widget.subcategoryIDs,
        )),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              expandedHeight: 350.0,
              collapsedHeight: 56.0,
              pinned: true,
              snap: false,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  height: 350,
                  width: double.infinity,
                  widget.category.bannerImage,
                  fit: BoxFit.fill,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: SvgPicture.asset(
                    "assets/images/search_icon.svg",
                    height: 22,
                  ),
                )
              ],
            ),

            /// Sticky Subcategory List (Remains Fixed After Scrolling)
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverSubcategoryDelegate(
                child: BlocBuilder<CategoryLandingpageBloc,
                    CategorylandingpageState>(
                  builder: (context, state) {
                    if (state is SubCategoriesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CategoryErrorState) {
                      return Center(child: Text(state.message));
                    } else if (state is CategoryLoadedState) {
                      return SubcategoryList(
                        category: widget.category,
                        selectedindex: state.selectedCategoryId,
                        subcategories: state.subCategories,
                      );
                    }
                    return const CircularProgressIndicator(color: Colors.red);
                  },
                ),
              ),
            ),
          ],
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: BlocBuilder<CategoryLandingpageBloc,
                  CategorylandingpageState>(builder: (context, state) {
                if (state is SubCategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryErrorState) {
                  return Center(child: Text(state.message));
                } else if (state is CategoryLoadedState) {
                  List<ProductModel> filteredProducts = state.products
                      .where((product) => product.subCategoryRef.any(
                          (subCategory) =>
                              subCategory.id == state.selectedCategoryId))
                      .toList();
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 25,
                        children: List.generate(
                          filteredProducts.length,
                          (index) {
                            return ProductModel2(
                              buttontextcolor: "000000",
                              context: context,
                              imageurl:
                                  filteredProducts[index].productImages[0],
                              mrpColor: "000000",
                              name: filteredProducts[index].productName,
                              offertextcolor: "000000",
                              price: 6777,
                              unitbgcolor: "FFFFFF",
                              productBgColor: "FFFFFF",
                              productcolor: "000000",
                              seeAllButtonBG: "FFFFFF",
                              seeAllButtontext: "000000",
                              sellingPriceColor: "000000",
                              sellingpricecolor: "000000",
                              unitTextcolor: "000000",
                            );
                          },
                        ),
                      ));
                } else {
                  return const CircularProgressIndicator(color: Colors.red);
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// 📌 SliverPersistentHeader Delegate for Sticky Subcategory List
class _SliverSubcategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverSubcategoryDelegate({required this.child});

  @override
  double get minExtent => 118; // Min height of subcategory list
  @override
  double get maxExtent => 118; // Max height of subcategory list

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // ✅ Ensures it's visible and doesn't overlap
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class SubcategoryList extends StatelessWidget {
  final Category category;
  final String selectedindex;
  final List<SubCategoryModel> subcategories;

  const SubcategoryList({
    super.key,
    required this.category,
    required this.selectedindex,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.read<CategoryLandingpageBloc>().add(
                    UpdateSelectedCategoryLandingpageEvent(
                      selectedCategoryId: subcategories[index].id,
                    ),
                  );
            },
            child: SizedBox(
              width: 90,
              child: Column(
                spacing: 5,
                children: [
                  Container(
                    // padding: const EdgeInsets.all(1),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2,
                          color: selectedindex == subcategories[index].id
                              ? parseColor(category.color)
                              : const Color.fromARGB(255, 230, 230, 230)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        subcategories[index].imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    subcategories[index].name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: selectedindex == subcategories[index].id
                            ? FontWeight.w700
                            : FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
