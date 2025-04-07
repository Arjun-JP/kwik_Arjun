import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_bloc.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_event.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_state.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/pages/Offer_Page/Super%20Saver%20Page%20Widgets/supersaver_model1.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/pages/Offer_Page/Super%20Saver%20Page%20Widgets/supersaver_model4.dart';
import 'package:kwik/widgets/navbar/navbar.dart';
import '../../bloc/home_page_bloc/category_model_1_bloc/category_model1_event.dart';
import '../../bloc/home_page_bloc/category_model_2_bloc/category_model2_event.dart';
import '../../bloc/home_page_bloc/category_model_9_bloc/category_model_9_event.dart';
import '../../bloc/navbar_bloc/navbar_event.dart';
import '../../constants/colors.dart';
import 'Super Saver Page Widgets/supersaver_model2.dart';
import 'Super Saver Page Widgets/supersaver_model3.dart';
import 'Super Saver Page Widgets/supersaver_model5.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  Future<void> _onRefresh() async {
    context.read<SuperSaverUiBloc>().add(ClearUiCacheEvent());
    BlocProvider.of<CategoryBlocModel1>(context).add(ClearCache());
    BlocProvider.of<CategoryBlocModel2>(context).add(ClearCacheCM2());

    BlocProvider.of<CategoryBloc5>(context).add(ClearCacheEventCM5());

    BlocProvider.of<CategoryBloc9>(context).add(ClearCacheEventCM9());

    context.read<SuperSaverUiBloc>().add(FetchUiDataEvent());
  }

  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   context.read<SuperSaverUiBloc>().add(FetchUiDataEvent());
    // });
    context.read<SuperSaverUiBloc>().add(FetchUiDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          final metrics = scrollNotification.metrics;
          final position = metrics.pixels;
          final maxScroll = metrics.maxScrollExtent;
          final scrollDelta = scrollNotification.scrollDelta;

          // Only proceed if we have a valid scroll delta
          if (scrollDelta == null) return true;

          // Define thresholds
          const edgeThreshold = 100.0;
          final nearTop = position <= edgeThreshold;
          final nearBottom = position >= maxScroll - edgeThreshold;

          // Determine if we're in the middle of the list (not near edges)
          final inMiddle = !nearTop && !nearBottom;

          // Handle scroll direction with edge cases
          if (scrollDelta > 0) {
            // Scrolling down - only hide if we're in the middle
            if (inMiddle) {
              context
                  .read<NavbarBloc>()
                  .add(const UpdateNavBarVisibility(false));
            }
          } else if (scrollDelta < 0) {
            // Scrolling up - always show, but especially when near edges
            context.read<NavbarBloc>().add(const UpdateNavBarVisibility(true));
          }

          // Special case: Show navbar when exactly at top or bottom
          if (position == 0 || position == maxScroll) {
            context.read<NavbarBloc>().add(const UpdateNavBarVisibility(true));
          }
        }
        return true;
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                .08,
                .1,
                .2,
                .5,
                .7,
                1.0
              ],
                  colors: [
                Color(0xFF219f52),
                Color(0xFF219f52),
                Color(0xFFFFFFFff),
                Color(0xFFFFFFFff),
                Color(0xFFFFFFFff),
                Color(0xFFFFFFFff)
              ])),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            body: BlocBuilder<SuperSaverUiBloc, SuperSaverUiState>(
              builder: (context, state) {
                if (state is UiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UiLoaded) {
                  final uiData = state.uiData;

                  final templates = [
                    {
                      'template': BannerModel1(
                        titlecolor: uiData["template1"]["title_color"],
                        bgColor: uiData["template1"]["background_color"],
                        bannerId: uiData["template1"]["bannerId"],
                        height: double.parse(
                            (uiData["template1"]["height"]).toString()),
                        borderradious: double.parse(
                            (uiData["template1"]["borderradious"]).toString()),
                        showbanner: uiData["template1"]["showbanner"],
                      ),
                      'order': uiData["template1"]["ui_order_number"]
                    },
                    {
                      'template': SupersaverModel1(
                        seeAllButtonBG: uiData["template2"]["seeAllButtonBG"],
                        seeAllButtontext: uiData["template2"]
                            ["seeAllButtontext"],
                        vegOrNonIcon: 'assets/images/vegicon.png',
                        categoryId: uiData["template2"]["categoryId"],
                        bgcolor: uiData["template2"]["bgcolor"],
                        titleColor: uiData["template2"]["titleColor"],
                        priceColor: uiData["template2"]["priceColor"],
                        subcatcolor1: uiData["template2"]["subcatcolor1"],
                        subcatcolor2: uiData["template2"]["subcatcolor2"],
                      ),
                      'order': uiData["template2"]["ui_order_number"],
                    },
                    {
                      'template': SupersaverModel2(
                        title: uiData["template3"]["title"],
                        subcategoryid: uiData["template3"]["subcategoryid"],
                        titleColor: uiData["template3"]["titleColor"],
                        bgcolor: uiData["template3"]["bgcolor"],
                        cartbuttontextcolor: uiData["template3"]
                            ["cartbuttontextcolor"],
                        mrpcolor: uiData["template3"]["mrpcolor"],
                        offerBGcolor: uiData["template3"]["offerBGcolor"],
                        offerTextcolor: uiData["template3"]["offerTextcolor"],
                        prodoductbgcolor: uiData["template3"]
                            ["prodoductbgcolor"],
                        productTextColor: uiData["template3"]
                            ["productTextColor"],
                        sellingpricecolor: uiData["template3"]
                            ["sellingpricecolor"],
                        seeAllButtonBG: uiData["template3"]["seeAllButtonBG"],
                        seeAllButtontext: uiData["template3"]
                            ["seeAllButtontext"],
                      ),
                      'order': uiData["template3"]["ui_order_number"],
                    },
                    {
                      'template': SupersaverModel3(
                        categoryID: uiData["template4"]["categoryID"],
                        title: uiData["template4"]["title"],
                        titleColor: uiData["template4"]["titleColor"],
                        bgcolor: uiData["template4"]["background_color"],
                        image: uiData["template4"]["image"],
                        cartbuttontextcolor: uiData["template4"]
                            ["cartbuttontextcolor"],
                        mrpcolor: uiData["template4"]["mrpcolor"],
                        crosscolor: uiData["template4"]["crosscolor"],
                        prodoductbgcolor: uiData["template4"]
                            ["prodoductbgcolor"],
                        productTextColor: uiData["template4"]
                            ["productTextColor"],
                        sellingpricecolor: uiData["template4"]
                            ["sellingpricecolor"],
                        seeAllButtonBG: uiData["template4"]["seeAllButtonBG"],
                        seeAllButtontext: uiData["template4"]
                            ["seeAllButtontext"],
                      ),
                      'order': uiData["template4"]["ui_order_number"]
                    },
                    {
                      'template': SupersaverModel4(
                        addButtonColor: uiData["template5"]["addButtonColor"],
                        offertextcolor: uiData["template5"]["offertextcolor"],
                        offerbgcolor: uiData["template5"]["offerbgcolor"],
                        subCategoryId: uiData["template5"]["subCategoryId"],
                        bgColor: uiData["template5"]["bgColor"],
                        productColor: uiData["template5"]["productColor"],
                        titleColor: uiData["template5"]["titleColor"],
                        mrpBgColor: uiData["template5"]["mrpBgColor"],
                        sellTextColor: uiData["template5"]["sellTextColor"],
                        mrpTextColor: uiData["template5"]["mrpTextColor"],
                        sellPriceBgColor: uiData["template5"]
                            ["sellPriceBgColor"],
                        ratingTextColor: uiData["template5"]["ratingTextColor"],
                        ratingBgColor: uiData["template5"]["ratingBgColor"],
                        seeAllButtonBG: uiData["template5"]["seeAllButtonBG"],
                        seeAllButtontext: uiData["template5"]
                            ["seeAllButtontext"],
                      ),
                      'order': uiData["template5"]["ui_order_number"]
                    },
                    {
                      'template': SupersaverModel5(
                        maincategories: List<String>.from(
                            uiData["template6"]["maincategories"]),
                        categoryId: uiData["template6"]["categoryId"],
                        bgcolor: uiData["template6"]["bgcolor"],
                        titleColor: uiData["template6"]["titleColor"],
                        subcatColor: uiData["template6"]["subcatColor"],
                        offerBGcolor: uiData["template6"]["offerBGcolor"],
                        mrpColor: uiData["template6"]["mrpColor"],
                        productBgColor: uiData["template6"]["productBgColor"],
                        sellingPriceColor: uiData["template6"]
                            ["sellingPriceColor"],
                        buttontextcolor: uiData["template6"]["buttontextcolor"],
                        offerTextcolor: uiData["template6"]["offerTextcolor"],
                        title: uiData["template6"]["title"],
                        unitTextcolor: uiData["template6"]["unitTextcolor"],
                        unitbgcolor: uiData["template6"]["unitbgcolor"],
                        seeAllButtonBG: uiData["template6"]["seeAllButtonBG"],
                        seeAllButtontext: uiData["template6"]
                            ["seeAllButtontext"],
                      ),
                      'order': uiData["template6"]["ui_order_number"],
                    },
                    {
                      'template': const DescriptiveWidget(
                        showcategory: true,
                        textColor: '989898',
                        info: 'Delivery',
                        title: "Always on Your Time",
                        logo:
                            "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                      ),
                      'order': "100"
                    }
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
                              expandedHeight: 93,
                              backgroundColor: const Color(0xFF219f52),
                              foregroundColor: const Color(0xFF219f52),
                              flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF219f52),
                                        Color(0xFF219f52)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 2.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          child: Text(
                                            "Less then",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w900,
                                                    color: const Color(
                                                        0xFF219f52)),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text("30 min delivery",
                                                style: theme
                                                    .textTheme.titleLarge!
                                                    .copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .textColorWhite)),
                                            IconButton(
                                                onPressed: () {},
                                                icon: SvgPicture.asset(
                                                  "assets/images/appbar_arrow.svg",
                                                  width: 30,
                                                  height: 30,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/addresshome_icon.svg",
                                              color: Colors.white,
                                            ),
                                            Text(
                                                " J236, Kadampukur village, Newtown...",
                                                maxLines: 1,
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .textColorWhite)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, top: 12),
                                  child: GestureDetector(
                                    onTap: () => context.push('/profile'),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          "assets/images/User_fill.png"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: false,
                              delegate: SearchBarDelegate("apple"),
                            ),
                            ...templates.map((template) {
                              return SliverToBoxAdapter(
                                child: SizedBox(
                                  key: ValueKey(
                                      template['order']), // Add a unique key
                                  child: template['template'] as Widget,
                                ),
                              );
                            }),
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
        ),
      ),
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final String searchText;

  SearchBarDelegate(this.searchText);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.push('/searchpage');
        },
        child: Container(
          height: 80,
          color: const Color(0xFF219f52),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/search.svg",
                  fit: BoxFit.contain,
                  width: 30,
                  height: 20,
                  color: Colors.grey,
                ),
                SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    'Search "$searchText"',
                    key: ValueKey(searchText),
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
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




/// removed widgets


// {
                  //   'template': SupersaverModel6(
                  //     flashBgColor: "FFFA76",
                  //     flashTextColor: "00AE11",
                  //     seeAllButtonBG: "D5E2C9",
                  //     seeAllButtontext: "35AB4E",
                  //     mrpColor: uiData["template6"]["mrp_color"],
                  //     sellingpricecolor: uiData["template6"]
                  //         ["selling_price_color"],
                  //     subCategoryId: uiData["template6"]["sub_category_ref"],
                  //     bgcolor: uiData["template6"]["background_color"],
                  //     titleColor: uiData["template6"]["title_color"],
                  //     productColor: uiData["template6"]["subcat_color"],
                  //   ),
                  //   'order': "7"
                  // },
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