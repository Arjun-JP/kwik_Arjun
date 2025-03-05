import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';

import 'package:kwik/pages/Home_page/widgets/banner_model.dart';

import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';

import 'package:kwik/widgets/navbar/navbar.dart';
import '../../bloc/Categories Page Bloc/categories_UI_bloc/categories_ui_bloc.dart';
import '../../bloc/Categories Page Bloc/categories_page_model1/categories_page_model1_bloc.dart';
import '../../bloc/Categories Page Bloc/categories_page_model2/categories_page_model2_bloc.dart';
import '../../bloc/Categories Page Bloc/categories_page_model3/categories_page_model3_bloc.dart';
import '../../bloc/Categories Page Bloc/categories_page_model4/categories_page_model4_bloc.dart';

import '../../bloc/navbar_bloc/navbar_event.dart';
import '../../constants/colors.dart';

import 'Categories Page Widgets/categories_page_model1.dart';

import 'Categories Page Widgets/categories_page_model2.dart';
import 'Categories Page Widgets/categories_page_model3.dart';
import 'Categories Page Widgets/categories_page_model4.dart';
import 'Categories Page Widgets/categories_page_model5.dart';
import 'Categories Page Widgets/categories_page_model6.dart';
import 'Categories Page Widgets/categories_page_model7.dart';
import 'Categories Page Widgets/categories_page_model8.dart';
import 'Categories Page Widgets/categories_page_model9.dart';
import 'Categories Page Widgets/categories_page_model10.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<void> _onRefresh() async {
    context.read<CategoriesUiBloc>().add(ClearCatUiCacheEvent());
    BlocProvider.of<CategoriesPageModel1Bloc>(context)
        .add(ClearCacheCatPage1());

    BlocProvider.of<CategoriesPageModel2Bloc>(context)
        .add(ClearCacheCatPage2());

    BlocProvider.of<CategoriesPageModel3Bloc>(context)
        .add(ClearCacheCatPage3());

    BlocProvider.of<CategoriesPageModel4Bloc>(context)
        .add(Clearsubcatproduct1Cache4());

    context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
  }

  @override
  void initState() {
    super.initState();
    context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          double position = scrollNotification.metrics.pixels;
          double maxScroll = scrollNotification.metrics.maxScrollExtent;

          if (scrollNotification.scrollDelta! > 0) {
            // Scrolling down: Hide navbar, but keep it visible at top/bottom
            if (position > 100 && position < maxScroll - 100) {
              context
                  .read<NavbarBloc>()
                  .add(const UpdateNavBarVisibility(false));
            }
          } else if (scrollNotification.scrollDelta! < 0) {
            // Scrolling up: Show navbar when within 100 pixels from top OR at bottom
            if (position < 100 || position >= maxScroll - 100) {
              context
                  .read<NavbarBloc>()
                  .add(const UpdateNavBarVisibility(true));
            }
          }
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: BlocBuilder<CategoriesUiBloc, CategoriesUiState>(
          builder: (context, state) {
            if (state is CatUiLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CatUiLoaded) {
              final uiData = state.uiData;

              final categoryRef =
                  List<String>.from(uiData["categorylist"]["category_ref"]);
              final categorymodel8Categories =
                  List<String>.from(uiData["template11"]["subcategories"]);
              print(categorymodel8Categories);
              print(uiData["template11"]["subcategories"]);
              final templates = [
                {
                  'template': CategoriesPageModel1(
                    categoryId: uiData["template7"]["category_ref"],
                    bgcolor: "FFFFFF",
                    titleColor: uiData["template7"]["title_color"],
                    subcatColor: uiData["template7"]["subcat_color"],
                  ),
                  'order': "1"
                },

                {
                  'template': CategoriesPageModel2(
                    categoryId: uiData["template7"]["category_ref"],
                    bgcolor: "FFFFFF",
                    titleColor: uiData["template7"]["title_color"],
                    priceColor: "841F4A",
                    subcatcolor1: "EDDDE4",
                    subcatcolor2: "FFFFFF",
                    vegOrNonIcon: 'assets/images/vegicon.png',
                    seeAllButtonBG: "EDDDE4",
                    seeAllButtontext: "841F4A",
                  ),
                  'order': "2"
                },
                {
                  'template': CategoriesPageModel3(
                    descriptionTextColor: '',
                    percentBgColor: 'B8E1FF',
                    percentDisplayPosition: 30,
                    titleTopDisplayPosition: false,
                    categoryId: uiData["template7"]["category_ref"],
                    bgcolor: "D5E9FF",
                    titleColor: uiData["template7"]["title_color"],
                    subcatColor: uiData["template7"]["subcat_color"],
                    description: '',
                    seeAllButtonBG: "B8E1FF",
                    seeAllButtontext: "005EA2",
                    brandIcon:
                        "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/bxs_offer.png?alt=media&token=f6cd9a07-d6f5-4f40-84cb-4748769a0ed9",
                  ),
                  'order': "3"
                },
                {
                  'template': CategoriesPageModel4(
                    subCategoryId: uiData["template6"]["sub_category_ref"],
                    bgColor: "FFFFF3",
                    productColor: "FFE8DE",
                    titleColor: "FF3B30",
                    mrpBgColor: "FFFA76",
                    sellTextColor: "FFFFFF",
                    mrpTextColor: "000000",
                    sellPriceBgColor: "FF3B30",
                  ),
                  'order': "4"
                },
                {
                  'template': CategoriesPageModel5(
                    maincategories: List<String>.from(
                        uiData["template8"]["sub_categories"]),
                    categoryId: uiData["template8"]["category_ref"],
                    bgcolor: uiData["template8"]["background_color"],
                    titleColor: uiData["template8"]["title_color"],
                    subcatColor: uiData["template8"]["subcat_color"],
                    offerBGcolor: uiData["template8"]["offer_bg_color"],
                    mrpColor: uiData["template8"]["mrp_color"],
                    productBgColor: uiData["template8"]
                        ["product_background_color"],
                    sellingPriceColor: uiData["template8"]["saleprice_color"],
                    categoryName: uiData["template8"]["category_name"],
                    brandImage: uiData["template8"]["brand_image"],
                  ),
                  'order': "5"
                },
                {
                  'template': CategoriesPageModel6(
                    bgColor: uiData["template11"]["background_color"],
                    categoryBG: uiData["template11"]["subcategorybg"],
                    iconBGcolor: uiData["template11"]["icon_bg_color"],
                    iconcolor: uiData["template11"]["icon_color"],
                    title: uiData["template11"]["title"],
                    categories: categorymodel8Categories,
                    titlecolor: uiData["template11"]["title_color"],
                    categorytitlecolor: uiData["template11"]
                        ["subcat_title_color"],
                    seeAllButtonBG: "FFFFFF",
                    seeAllButtontext: "619B8A",
                  ),
                  'order': "6"
                },
                {
                  'template': CategoriesPageModel7(
                    title: uiData["template13"]["title"],
                    titleColor: uiData["template13"]["titleColor"],
                    bgcolor: uiData["template13"]["background_color"],
                    image: uiData["template13"]["image"],
                    cartbuttontextcolor: uiData["template13"]
                        ["cartbuttontextcolor"],
                    mrpcolor: uiData["template13"]["mrpcolor"],
                    crosscolor: uiData["template13"]["crosscolor"],
                    prodoductbgcolor: uiData["template13"]["prodoductbgcolor"],
                    productTextColor: uiData["template13"]["productTextColor"],
                    sellingpricecolor: uiData["template13"]
                        ["sellingpricecolor"],
                    seeAllButtonBG: uiData["template13"]["seeAllButtonBG"],
                    seeAllButtontext: uiData["template13"]["seeAllButtontext"],
                  ),
                  'order': "7"
                },
                {
                  'template': BannerModel1(
                    titlecolor: uiData["template5"]["title_color"],
                    bgColor: uiData["template5"]["background_color"],
                    bannerId: 3,
                    height: 300,
                    borderradious: 0,
                  ),
                  'order': "8"
                },
                {
                  'template': CategoriesPageModel8(
                    productColor: "EBDFD7",
                    saleBanner:
                        "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/image%2027.png?alt=media&token=2cad63df-ba3d-41be-a8f8-fc54af8ae1d1",
                    maincategories: List<String>.from(
                        uiData["template4"]["main_sub_category"]),
                    secondarycategories: List<String>.from(
                        uiData["template4"]["secondary_sub_category"]),
                    categoryId: uiData["template4"]["category_ref"],
                    bgcolor: "916E55",
                    titleColor: "ffffff",
                    subcatColor: "000000",
                  ),
                  'order': "9"
                },
                {
                  'template': CategoriesPageModel9(
                    flashBgColor: 'AFE569',
                    flashTextColor: '7B009A',
                    subcategoryid: uiData["template10"]["category_ref"],
                    titleColor: uiData["template10"]["title_color"],
                    bgcolor: uiData["template10"]["background_color"],
                    cartbuttontextcolor: uiData["template10"]
                        ["cartbuttontextcolor"],
                    mrpcolor: uiData["template10"]["mrpcolor"],
                    offerBGcolor: uiData["template10"]["offerBGcolor"],
                    offerTextcolor: uiData["template10"]["offerTextcolor"],
                    prodoductbgcolor: uiData["template10"]["prodoductbgcolor"],
                    productTextColor: uiData["template10"]["productTextColor"],
                    sellingpricecolor: uiData["template10"]
                        ["sellingpricecolor"],
                    seeAllButtonBG: uiData["template10"]["seeAllButtonBG"],
                    seeAllButtontext: uiData["template10"]["seeAllButtontext"],
                  ),
                  'order': "10"
                },
                {
                  'template': CategoriesPageModel3(
                    percentBgColor: 'FFFA76',
                    descriptionTextColor: "727272",
                    percentDisplayPosition: 70,
                    titleTopDisplayPosition: true,
                    brandIcon:
                        "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/image%2023.png?alt=media&token=9925215f-e0eb-4a12-8431-281cea504c44",
                    categoryId: uiData["template7"]["category_ref"],
                    bgcolor: "FEEBC8",
                    titleColor: "E23338",
                    subcatColor: uiData["template7"]["subcat_color"],
                    description:
                        'Taste the Authenticity with Amul – India\'s Favorite Dairy Brand',
                    seeAllButtonBG: "E23338",
                    seeAllButtontext: "ffffff",
                  ),
                  'order': "11"
                },
                {
                  'template': CategoriesPageModel10(
                    productColor: "F1F7FE",
                    categoryId: uiData["template3"]["category_ref"],
                    maincategories: List<String>.from(
                        uiData["template3"]["main_sub_category"]),
                    titleColor: "1E7098",
                    bgcolor: "DDEDFC",
                    offerPercent: "85%",
                  ),
                  'order': "12"
                },

                {
                  'template': const DescriptiveWidget(
                    textColor: '989898',
                    info: 'Delivery\nAlways on Your Time',
                    title: "Kwik Delivery",
                    logo:
                        "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                  ),
                  'order': uiData["template12"]["ui_order_number"]
                }

                // {
                //   'template': CategoryModel9(
                //     maincategories: List<String>.from(
                //         uiData["template12"]["maincategories"]),
                //     categoryId: uiData["template12"]["categoryId"],
                //     bgcolor: uiData["template12"]["bgcolor"],
                //     titleColor: uiData["template12"]["titleColor"],
                //     subcatColor: uiData["template12"]["offerBGcolor"],
                //     offerBGcolor: uiData["template12"]["offerBGcolor"],
                //     mrpColor: uiData["template12"]["mrpColor"],
                //     productBgColor: uiData["template12"]["productBgColor"],
                //     sellingPriceColor: uiData["template12"]
                //         ["sellingPriceColor"],
                //     buttontextcolor: uiData["template12"]["buttontextcolor"],
                //     offerTextcolor: uiData["template12"]["offerTextcolor"],
                //     title: uiData["template12"]["title"],
                //     unitTextcolor: uiData["template12"]["unitTextcolor"],
                //     unitbgcolor: uiData["template12"]["unitbgcolor"],
                //   ),
                //   'order': uiData["template12"]["ui_order_number"]
                // },

                //  {'template': const SizedBox(height: 40), 'order': "500"}
              ];

              templates.sort((a, b) =>
                  int.parse(a['order']).compareTo(int.parse(b['order'])));

              return InkWell(
                onTap: () {
                  context
                      .read<NavbarBloc>()
                      .add(const UpdateNavBarVisibility(true));
                },
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh:
                        _onRefresh, // The method to trigger on pull to refresh
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: false,
                          expandedHeight: 80,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFFFD8C6),
                                    const Color(0xFFFFFFFF).withOpacity(0.0),
                                  ],
                                  stops: const [0.01, 2],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "All Categories",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColorblack,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: false,
                          delegate: _SearchBarDelegate(),
                        ),
                        ...templates.map((template) {
                          return SliverToBoxAdapter(
                            child: template['template'],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is CatUiError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            return const Text('Unexpected state');
          },
        ),
        bottomNavigationBar:
            context.watch<NavbarBloc>().state.isBottomNavBarVisible
                ? const Navbar()
                : const SizedBox(),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.dotColorUnSelected),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: "   Search...",
            filled: true,
            fillColor: AppColors.backgroundColorWhite,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/images/search.svg",
                fit: BoxFit.contain,
                width: 30,
                height: 20,
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.dotColorUnSelected),
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: const TextStyle(
                fontSize: 16,
                color: AppColors.textColorGrey,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
