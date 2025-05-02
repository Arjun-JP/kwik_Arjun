import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_bloc.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_event.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_state.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/supersaver_model1_bloc/supersaver_model1_bloc.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/supersaver_model2_bloc/supersaver_model2_bloc.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/supersaver_model4_bloc/supersaver_model4_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_10_bloc/category_model_10_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_10_bloc/category_model_10_event.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_event.dart';
import 'package:kwik/pages/Address_management/location_search_page.dart';
import 'package:kwik/pages/Offer_Page/Super%20Saver%20Page%20Widgets/supersaver_model1.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/pages/Offer_Page/Super%20Saver%20Page%20Widgets/supersaver_model4.dart';
import 'package:kwik/widgets/navbar/navbar.dart';
import 'package:kwik/widgets/shimmer/main_loading_indicator.dart';
import 'package:kwik/widgets/shimmer/shimmer.dart';
import '../../bloc/navbar_bloc/navbar_event.dart';
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
    BlocProvider.of<SupersaverModel1BlocBloc>(context)
        .add(ClearCacheSuperSave1());
    BlocProvider.of<SupersaverModel2Bloc>(context).add(ClearsubcatSS());

    BlocProvider.of<CategoryModel10Bloc>(context)
        .add(Clearsubcatproduct10Cache());
    context.read<RecommendedProductsBloc>().add(ClearRecommendedproductCache());
    BlocProvider.of<SupersaverModel4Bloc>(context).add(ClearsubcatCacheSS4());
//,,,,,SupersaverModel5Bloc
    context.read<SuperSaverUiBloc>().add(FetchUiDataEvent());
  }

  @override
  void initState() {
    super.initState();

    context.read<SuperSaverUiBloc>().add(FetchUiDataEvent());
    context.read<AddressBloc>().add(const GetsavedAddressEvent());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<SuperSaverUiBloc, SuperSaverUiState>(
        builder: (context, state) {
      if (state is UiInitial) {
        context.read<SuperSaverUiBloc>().add(FetchUiDataEvent());
      } else if (state is UiLoading) {
        return const Center(child: MainLoadingIndicator());
      } else if (state is UiLoaded) {
        final uiData = state.uiData;

        final templates = [
          {
            'template': BannerModel1(
              titlecolor: uiData["template1"]["title_color"],
              bgColor: uiData["template1"]["background_color"],
              bannerId: uiData["template1"]["bannerId"],
              height: double.parse((uiData["template1"]["height"]).toString()),
              borderradious: double.parse(
                  (uiData["template1"]["borderradious"]).toString()),
              showbanner: uiData["template1"]["showbanner"],
            ),
            'order': uiData["template1"]["ui_order_number"]
          },
          {
            'template': SupersaverModel1(
              showCategory: uiData["template2"]["show_Category"],
              title: uiData["template2"]["title"],
              seeAllButtonBG: uiData["template2"]["seeAllButtonBG"],
              seeAllButtontext: uiData["template2"]["seeAllButtontext"],
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
              showCategory: uiData["template3"]["show_Category"],
              topbanner: uiData["template3"]["topbanner"],
              title: uiData["template3"]["title"],
              subcategoryid: uiData["template3"]["subcategoryid"],
              titleColor: uiData["template3"]["titleColor"],
              bgcolor: uiData["template3"]["bgcolor"],
              cartbuttontextcolor: uiData["template3"]["cartbuttontextcolor"],
              mrpcolor: uiData["template3"]["mrpcolor"],
              offerBGcolor: uiData["template3"]["offerBGcolor"],
              offerTextcolor: uiData["template3"]["offerTextcolor"],
              prodoductbgcolor: uiData["template3"]["prodoductbgcolor"],
              productTextColor: uiData["template3"]["productTextColor"],
              sellingpricecolor: uiData["template3"]["sellingpricecolor"],
              seeAllButtonBG: uiData["template3"]["seeAllButtonBG"],
              seeAllButtontext: uiData["template3"]["seeAllButtontext"],
              buttonbgcolor: uiData["template3"]["buttonbgcolor"],
              unitTextcolor: uiData["template3"]["unitTextcolor"],
              unitbgcolor: uiData["template3"]["unitbgcolor"],
            ),
            'order': uiData["template3"]["ui_order_number"],
          },
          {
            'template': SupersaverModel3(
                showCategory: uiData["template4"]["show_Category"],
                categoryID: uiData["template4"]["categoryID"],
                title: uiData["template4"]["title"],
                titleColor: uiData["template4"]["titleColor"],
                bgcolor: uiData["template4"]["background_color"],
                image: uiData["template4"]["image"],
                cartbuttontextcolor: uiData["template4"]["cartbuttontextcolor"],
                mrpcolor: uiData["template4"]["mrpcolor"],
                crosscolor: uiData["template4"]["crosscolor"],
                prodoductbgcolor: uiData["template4"]["prodoductbgcolor"],
                productTextColor: uiData["template4"]["productTextColor"],
                sellingpricecolor: uiData["template4"]["sellingpricecolor"],
                seeAllButtonBG: uiData["template4"]["seeAllButtonBG"],
                seeAllButtontext: uiData["template4"]["seeAllButtontext"],
                cartbuttonbg: uiData["template4"]["cartbuttonbg"],
                offerbgcolor2: uiData["template4"]["offerbgcolor2"],
                offerbgcolor: uiData["template4"]["offerbgcolor"],
                offerbordercolor: uiData["template4"]["offerbordercolor"],
                offertextcolor: uiData["template4"]["offertextcolor"],
                producttextcolor: uiData["template4"]["producttextcolor"],
                unitcolor: uiData["template4"]["unitcolor"],
                offertextcolor2: uiData["template4"]["offertextcolor2"]),
            'order': uiData["template4"]["ui_order_number"]
          },
          {
            'template': SupersaverModel4(
              title: uiData["template5"]["title"],
              showCategory: uiData["template5"]["show_Category"],
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
              sellPriceBgColor: uiData["template5"]["sellPriceBgColor"],
              ratingTextColor: uiData["template5"]["ratingTextColor"],
              ratingBgColor: uiData["template5"]["ratingBgColor"],
              seeAllButtonBG: uiData["template5"]["seeAllButtonBG"],
              seeAllButtontext: uiData["template5"]["seeAllButtontext"],
              bannerimage: uiData["template5"]["topbanner"],
            ),
            'order': uiData["template5"]["ui_order_number"]
          },
          {
            'template': SupersaverModel5(
              showCategory: uiData["template6"]["show_Category"],
              maincategories:
                  List<String>.from(uiData["template6"]["maincategories"]),
              topbanner: uiData["template6"]["topbanner"],
              categoryId: uiData["template6"]["categoryId"],
              bgcolor: uiData["template6"]["bgcolor"],
              titleColor: uiData["template6"]["titleColor"],
              subcatColor: uiData["template6"]["subcatColor"],
              offerBGcolor: uiData["template6"]["offerBGcolor"],
              mrpColor: uiData["template6"]["mrpColor"],
              productBgColor: uiData["template6"]["productBgColor"],
              sellingPriceColor: uiData["template6"]["sellingPriceColor"],
              buttontextcolor: uiData["template6"]["buttontextcolor"],
              offerTextcolor: uiData["template6"]["offerTextcolor"],
              title: uiData["template6"]["title"],
              unitTextcolor: uiData["template6"]["unitTextcolor"],
              unitbgcolor: uiData["template6"]["unitbgcolor"],
              seeAllButtonBG: uiData["template6"]["seeAllButtonBG"],
              seeAllButtontext: uiData["template6"]["seeAllButtontext"],
            ),
            'order': uiData["template6"]["ui_order_number"],
          },
          {
            'template': const DescriptiveWidget(
              showcategory: true,
              title: "Skip the store, we're at your door!",
              logo: "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
            ),
            'order': "100"
          }
        ];

        templates.sort(
            (a, b) => int.parse(a['order']).compareTo(int.parse(b['order'])));

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                  .08,
                  .1,
                  .2,
                  .5,
                  .7,
                  1.0
                ],
                    colors: [
                  parseColor(uiData["template15"]["appbarcolor"]),
                  parseColor(uiData["template15"]["appbarcolor"]),
                  const Color(0xFFFFFFFff),
                  const Color(0xFFFFFFFff),
                  const Color(0xFFFFFFFff),
                  const Color(0xFFFFFFFff)
                ])),
            child: Scaffold(
                backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                body: InkWell(
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
                            backgroundColor:
                                parseColor(uiData["template15"]["appbarcolor"]),
                            foregroundColor:
                                parseColor(uiData["template15"]["appbarcolor"]),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      parseColor(
                                          uiData["template15"]["appbarcolor"]),
                                      parseColor(
                                          uiData["template15"]["appbarcolor"])
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
                                            color: parseColor(
                                                uiData["template15"]
                                                    ["text1bg"]),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        child: Text(
                                          uiData["template15"]["text1"],
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w900,
                                                  color: parseColor(
                                                      uiData["template15"]
                                                          ["text1clr"])),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const LocationSearchPage(),
                                          ));
                                        },
                                        child: Row(
                                          children: [
                                            Text(uiData["template15"]["text2"],
                                                style: theme
                                                    .textTheme.titleLarge!
                                                    .copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: parseColor(
                                                            uiData["template15"]
                                                                ["text2clr"]))),
                                            IconButton(
                                                onPressed: () {
                                                  HapticFeedback.mediumImpact();
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LocationSearchPage(),
                                                  ));
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .arrow_drop_down_circle_rounded,
                                                  color: parseColor(
                                                      uiData["template15"]
                                                          ["iconcolor"]),
                                                  size: 30,
                                                ))
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const LocationSearchPage(),
                                          ));
                                        },
                                        child: Row(
                                          spacing: 8,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/addresshome_icon.svg",
                                              color: parseColor(
                                                  uiData["template15"]
                                                      ["addressclr"]),
                                            ),
                                            BlocBuilder<AddressBloc,
                                                    AddressState>(
                                                builder: (context, state) {
                                              if (state
                                                  is LocationSearchResults) {
                                                return Text(
                                                    "${state.currentlocationaddress.characters.take(35).string}...",
                                                    maxLines: 1,
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: parseColor(uiData[
                                                                    "template15"]
                                                                [
                                                                "addressclr"])));
                                              } else {
                                                return const Shimmer(
                                                    width: 200, height: 12);
                                              }
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 12.0, top: 12),
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
                ),
                bottomNavigationBar: const Navbar()),
          ),
        );
      } else {
        return const SizedBox();
      }
      return const SizedBox();
    });
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
        child: BlocBuilder<SuperSaverUiBloc, SuperSaverUiState>(
            builder: (context, state) {
          if (state is UiInitial) {
            context.read<SuperSaverUiBloc>().add(FetchUiDataEvent());
          } else if (state is UiLoading) {
            return const Center(child: MainLoadingIndicator());
          } else if (state is UiLoaded) {
            final uiData = state.uiData;
            return Container(
              height: 80,
              color: parseColor(uiData["template15"]["appbarcolor"]),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: parseColor(uiData["template15"]["textfieldbg"]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/search.svg",
                      fit: BoxFit.contain,
                      width: 30,
                      height: 20,
                      color: parseColor(uiData["template15"]["textfieldtext"]),
                    ),
                    const SizedBox(width: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        'Search "$searchText"',
                        key: ValueKey(searchText),
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: parseColor(
                                uiData["template15"]["textfieldtext"]),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
          return const SizedBox();
        }),
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