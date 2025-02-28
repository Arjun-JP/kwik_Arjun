import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/category_model2_bloc/category_model2_bloc.dart';

import 'package:kwik/bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__event.dart';

import 'package:kwik/bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/pages/Home_page/widgets/Super%20Saver%20Page%20Widgets/supersaver_model1.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';

import 'package:kwik/pages/Home_page/widgets/category_model_4.dart';

import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/pages/Home_page/widgets/Super%20Saver%20Page%20Widgets/supersaver_model4.dart';

import 'package:kwik/widgets/navbar/navbar.dart';
import '../../bloc/category_model1_bloc/category_model1_event.dart';
import '../../bloc/category_model2_bloc/category_model2_event.dart';

import '../../bloc/category_model_9_bloc/category_model_9_event.dart';
import '../../bloc/navbar_bloc/navbar_event.dart';
import '../../constants/colors.dart';
import '../Home_page/widgets/Super Saver Page Widgets/supersaver_model2.dart';
import '../Home_page/widgets/Super Saver Page Widgets/supersaver_model3.dart';
import '../Home_page/widgets/Super Saver Page Widgets/supersaver_model5.dart';
import '../Home_page/widgets/Super Saver Page Widgets/supersaver_model6.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  Future<void> _onRefresh() async {
    context.read<HomeUiBloc>().add(ClearUiCacheEvent());
    BlocProvider.of<CategoryBlocModel1>(context).add(ClearCache());
    BlocProvider.of<CategoryBlocModel2>(context).add(ClearCacheCM2());

    BlocProvider.of<CategoryBloc5>(context).add(ClearCacheEventCM5());

    BlocProvider.of<CategoryBloc9>(context).add(ClearCacheEventCM9());

    context.read<HomeUiBloc>().add(FetchUiDataEvent());
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeUiBloc>().add(FetchUiDataEvent());
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
        body: BlocBuilder<HomeUiBloc, HomeUiState>(
          builder: (context, state) {
            if (state is UiLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UiLoaded) {
              final uiData = state.uiData;

              final categoryRef =
                  List<String>.from(uiData["categorylist"]["category_ref"]);
              final categorymodel8Categories =
                  List<String>.from(uiData["template11"]["subcategories"]);
              print(categorymodel8Categories);
              print(uiData["template11"]["subcategories"]);
              final templates = [
                {
                  'template': BannerModel1(
                    titlecolor: uiData["template2"]["title_color"],
                    bgColor: uiData["template2"]["background_color"],
                    bannerId: 1,
                    height: 200,
                  ),
                  'order': "1"
                },
                {
                  'template': SupersaverModel1(
                    seeAllButtonBG: "EDDDE4",
                    seeAllButtontext: "841F4A",
                    vegOrNonIcon: 'assets/images/vegicon.png',
                    categoryId: uiData["template7"]["category_ref"],
                    bgcolor: "FFFFFF",
                    titleColor: uiData["template7"]["title_color"],
                    priceColor: "841F4A",
                    subcatcolor1: "EDDDE4",
                    subcatcolor2: "FFFFFF",
                  ),
                  'order': "2"
                },
                {
                  'template': SupersaverModel2(
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
                  'order': "3"
                },
                {
                  'template': SupersaverModel3(
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
                  'order': "4"
                },
                {
                  'template': SupersaverModel4(
                    addButtonColor: "2B5692",
                    offertextcolor: uiData["template9"]["offer_text_color"],
                    offerbgcolor: uiData["template9"]["offer_bg_color"],
                    subCategoryId: uiData["template6"]["sub_category_ref"],
                    bgColor: "FFA8A4",
                    productColor: "FFE8DE",
                    titleColor: "B00000",
                    mrpBgColor: "FFFA76",
                    sellTextColor: "FFFFFF",
                    mrpTextColor: "000000",
                    sellPriceBgColor: "FF3B30",
                    ratingTextColor: 'ffffff',
                    ratingBgColor: "00AE11",
                    seeAllButtonBG: "FFD8C6",
                    seeAllButtontext: "B00000",
                  ),
                  'order': "5"
                },
                {
                  'template': SupersaverModel5(
                    maincategories: List<String>.from(
                        uiData["template12"]["maincategories"]),
                    categoryId: uiData["template12"]["categoryId"],
                    bgcolor: "35AB4E",
                    titleColor: "ffffff",
                    subcatColor: uiData["template12"]["offerBGcolor"],
                    offerBGcolor: uiData["template12"]["offerBGcolor"],
                    mrpColor: uiData["template12"]["mrpColor"],
                    productBgColor: "EEF3F2",
                    sellingPriceColor: uiData["template12"]
                        ["sellingPriceColor"],
                    buttontextcolor: uiData["template12"]["buttontextcolor"],
                    offerTextcolor: uiData["template12"]["offerTextcolor"],
                    title: uiData["template12"]["title"],
                    unitTextcolor: uiData["template12"]["unitTextcolor"],
                    unitbgcolor: uiData["template12"]["unitbgcolor"],
                    seeAllButtonBG: "D5E2C9",
                    seeAllButtontext: "00AE11",
                  ),
                  'order': "6"
                },
                {
                  'template': SupersaverModel6(
                    flashBgColor: "FFFA76",
                    flashTextColor: "00AE11",
                    seeAllButtonBG: "D5E2C9",
                    seeAllButtontext: "35AB4E",
                    mrpColor: uiData["template6"]["mrp_color"],
                    sellingpricecolor: uiData["template6"]
                        ["selling_price_color"],
                    subCategoryId: uiData["template6"]["sub_category_ref"],
                    bgcolor: uiData["template6"]["background_color"],
                    titleColor: uiData["template6"]["title_color"],
                    productColor: uiData["template6"]["subcat_color"],
                  ),
                  'order': "7"
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
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFFFFF),
                                    Color(0xFFFFFFFF)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "SUPER SAVER",
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
            } else if (state is UiError) {
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
