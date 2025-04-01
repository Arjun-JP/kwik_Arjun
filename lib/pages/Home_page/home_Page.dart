import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Search_bloc/Search_bloc.dart';
import 'package:kwik/bloc/Search_bloc/search_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_18_bloc/category_model_18_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_18_bloc/category_model_18_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_4_bloc/category_model_4_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_bloc.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_event.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_10.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_12.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_14.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_15.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_16.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_17.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_18.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_19.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_2.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_3.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_4.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_9.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/widgets/navbar/navbar.dart';
import '../../bloc/home_page_bloc/category_model_1_bloc/category_model1_event.dart';
import '../../bloc/home_page_bloc/category_model_2_bloc/category_model2_event.dart';
import '../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_bloc.dart';
import '../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_event.dart';
import '../../bloc/home_page_bloc/category_model_12_bloc/category_model_12_event.dart';
import '../../bloc/home_page_bloc/category_model_4_bloc/category_model_4_event.dart';
import '../../bloc/home_page_bloc/category_model_7_bloc/category_model_7_bloc.dart';
import '../../bloc/home_page_bloc/category_model_7_bloc/category_model_7_event.dart';
import '../../bloc/home_page_bloc/category_model_9_bloc/category_model_9_event.dart';
import '../../bloc/navbar_bloc/navbar_event.dart';
import '../../constants/colors.dart';
import 'widgets/category_model_1.dart';
import 'widgets/category_model_5.dart';
import 'widgets/category_model_6.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _onRefresh() async {
    context.read<HomeUiBloc>().add(ClearUiCacheEvent());
    BlocProvider.of<CategoryBlocModel1>(context).add(ClearCache());
    BlocProvider.of<CategoryBlocModel2>(context).add(ClearCacheCM2());
    BlocProvider.of<CategoryModel4Bloc>(context)
        .add(Clearsubcatproduct1Cache());
    BlocProvider.of<CategoryBloc5>(context).add(ClearCacheEventCM5());
    BlocProvider.of<CategoryBlocModel6>(context).add(ClearCacheCM6());
    BlocProvider.of<CategoryModel7Bloc>(context)
        .add(Clearsubcatproduct7Cache());
    BlocProvider.of<CategoryBloc9>(context).add(ClearCacheEventCM9());
    BlocProvider.of<CategoryModel10Bloc>(context)
        .add(Clearsubcatproduct10Cache());
    BlocProvider.of<CategoryBloc12>(context).add(ClearCacheEventCM12());
    context.read<HomeUiBloc>().add(FetchUiDataEvent());
    BlocProvider.of<CategoryBloc13>(context).add(ClearCacheEventCM13());
    BlocProvider.of<CategoryBlocModel16>(context).add(ClearCacheCM16());

    BlocProvider.of<CategoryBloc18>(context).add(ClearCacheEventCM18());
    BlocProvider.of<CategoryBloc19>(context).add(ClearCacheEventCM19());
    BlocProvider.of<SubcategoryProductBloc>(context).add(ClearSimilarCache());
    BlocProvider.of<SearchBloc>(context).add(ClearCachesearch());
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeUiBloc>().add(FetchUiDataEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
              Color(0xFFfecc6c),
              Color(0xFFfecc6c),
              Color(0xFFFFFFFff),
              Color(0xFFFFFFFff),
              Color(0xFFFFFFFff),
              Color(0xFFFFFFFff)
            ])),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 193, 7),
          body: BlocBuilder<HomeUiBloc, HomeUiState>(
            builder: (context, state) {
              if (state is UiInitial) {
                context.read<HomeUiBloc>().add(FetchUiDataEvent());
                return const Center(child: CircularProgressIndicator());
              } else if (state is UiLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UiLoaded) {
                final uiData = state.uiData;

                final categoryRef =
                    List<String>.from(uiData["categorylist"]["category_ref"]);
                final categorymodel8Categories =
                    List<String>.from(uiData["template11"]["subcategories"]);

                final templates = [
                  // All banners in the home page
                  {
                    'template': BannerModel1(
                      titlecolor: uiData["template2"]["title_color"],
                      bgColor: uiData["template2"]["background_color"],
                      bannerId: 1,
                      height: 100,
                      horizontalpadding: 10,
                      borderradious: 20,
                      showbanner: uiData["template2"]["show_Category"],
                    ),
                    'order': uiData["template2"]["ui_order_number"]
                  },
                  {
                    'template': BannerModel1(
                      titlecolor: uiData["template5"]["title_color"],
                      bgColor: uiData["template5"]["background_color"],
                      bannerId: 3,
                      height: 300,
                      borderradious: 0,
                      showbanner: uiData["template5"]["show_Category"],
                    ),
                    'order': uiData["template5"]["ui_order_number"]
                  },

                  {
                    'template': BannerModel1(
                      titlecolor: uiData["template5"]["title_color"],
                      bgColor: uiData["template5"]["background_color"],
                      bannerId: 4,
                      height: 210,
                      viewportFraction: .8,
                      verticalpadding: 10,
                      borderradious: 20,
                      showbanner: uiData["template5"]["show_Category"],
                    ),
                    'order': "9"
                  },

                  // Home page dynamic widgets in the created order

                  {
                    'template': CategoryModel1(
                      title: uiData["categorylist"]["title"],
                      bgColor: uiData["categorylist"]["background_color"],
                      categories: categoryRef,
                      titlecolor: uiData["categorylist"]["title_color"],
                      textcolor: uiData["categorylist"]["subcategory_color"],
                      showcategory: uiData["categorylist"]["show_Category"],
                    ),
                    'order': uiData["categorylist"]["ui_order_number"]
                  },

                  {
                    'template': CategoryModel2(
                      categoryId: uiData["template7"]["category_ref"],
                      bgcolor: uiData["template7"]["background_color"],
                      titleColor: uiData["template7"]["title_color"],
                      subcatColor: uiData["template7"]["subcat_color"],
                      showcategory: uiData["template7"]["show_Category"],
                      title: uiData["template7"]["title"],
                    ),
                    'order': uiData["template7"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel3(
                      maincategories: List<String>.from(
                          uiData["template3"]["main_sub_category"]),
                      secondarycategories: List<String>.from(
                          uiData["template3"]["secondary_sub_category"]),
                      categoryId: uiData["template3"]["category_ref"],
                      bgcolor: uiData["template3"]["background_color"],
                      titleColor: uiData["template3"]["title_color"],
                      subcatColor: uiData["template3"]["subcat_color"],
                      showcategory: uiData["template3"]["show_Category"],
                      title: uiData["template3"]["title"],
                    ),
                    'order': uiData["template3"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel3(
                      maincategories: List<String>.from(
                          uiData["template4"]["main_sub_category"]),
                      secondarycategories: List<String>.from(
                          uiData["template4"]["secondary_sub_category"]),
                      categoryId: uiData["template4"]["category_ref"],
                      bgcolor: uiData["template4"]["background_color"],
                      titleColor: uiData["template4"]["title_color"],
                      subcatColor: uiData["template4"]["subcat_color"],
                      showcategory: uiData["template4"]["show_Category"],
                      title: uiData["template4"]["title"],
                    ),
                    'order': uiData["template4"]["ui_order_number"]
                  },

                  {
                    'template': CategoryModel4(
                      buttonbgcolor: uiData["template6"]["buttonbgcolor"],
                      buttontextcolor: uiData["template6"]["buttontextcolor"],
                      offerbgcolor: uiData["template6"]["offerbgcolor"],
                      offertextcolor: uiData["template6"]["offertextcolor"],
                      offertext2: uiData["template6"]["offertext2"],
                      offerborder: uiData["template6"]["offerborder"],
                      unitcolor: uiData["template6"]["unitcolor"],
                      seeAllButtonBG: uiData["template6"]["seeAllButtonBG"],
                      seeAllButtontext: uiData["template6"]["seeAllButtontext"],
                      mrpColor: uiData["template6"]["mrp_color"],
                      sellingpricecolor: uiData["template6"]
                          ["selling_price_color"],
                      title: uiData["template6"]["title"],
                      subtitle: uiData["template6"]["subtitle"],
                      subCategoryId: uiData["template6"]["sub_category_ref"],
                      bgcolor: uiData["template6"]["background_color"],
                      titleColor: uiData["template6"]["title_color"],
                      productColor: uiData["template6"]["subcat_color"],
                      showcategory: uiData["template6"]["show_Category"],
                    ),
                    'order': uiData["template6"]["ui_order_number"]
                  },

                  {
                    'template': CategoryModel5(
                      producttextcolor: uiData["template8"]["producttextcolor"],
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
                      showcategory: uiData["template8"]["show_Category"],
                      buttonbgcolor: uiData["template8"]["buttonbgcolor"],
                      buttontextcolor: uiData["template8"]["buttontextcolor"],
                      indicatercolor: uiData["template8"]["indicatercolor"],
                      offertextcolor: uiData["template8"]["offertextcolor"],
                      unitcolor: uiData["template8"]["unitcolor"],
                      unitbgcolor: uiData["template8"]["unitbgcolor"],
                      seeallbuttonbg: uiData["template8"]["seeallbuttonbg"],
                      seeallbuttontext: uiData["template8"]["seeallbuttontext"],
                    ),
                    'order': uiData["template8"]["ui_order_number"]
                  },

                  {
                    'template': CategoryModel6(
                      title: uiData["template9"]["title"],
                      subcategories: List<String>.from(
                          uiData["template9"]["sub_categories"]),
                      bgcolor: uiData["template9"]["background_color"],
                      titleColor: uiData["template9"]["title_color"],
                      catnamecolor: uiData["template9"]["subcat_color"],
                      offertextcolor: uiData["template9"]["offer_text_color"],
                      offerbgcolor: uiData["template9"]["offer_bg_color"],
                      catnamebgcolor: uiData["template9"]["subcatbg_color"],
                      showcategory: uiData["template9"]["show_Category"],
                    ),
                    'order': uiData["template9"]["ui_order_number"]
                  },

                  {
                    'template': CategoryModel9(
                      seeAllButtonBG: uiData["template12"]["seeAllButtonBG"],
                      seeAllButtontext: uiData["template12"]
                          ["seeAllButtontext"],
                      maincategories: List<String>.from(
                          uiData["template12"]["maincategories"]),
                      categoryId: uiData["template12"]["categoryId"],
                      bgcolor: uiData["template12"]["bgcolor"],
                      titleColor: uiData["template12"]["titleColor"],
                      subcatColor: uiData["template12"]["offerBGcolor"],
                      offerBGcolor: uiData["template12"]["offerBGcolor"],
                      mrpColor: uiData["template12"]["mrpColor"],
                      productBgColor: uiData["template12"]["productBgColor"],
                      sellingPriceColor: uiData["template12"]
                          ["sellingPriceColor"],
                      buttontextcolor: uiData["template12"]["buttontextcolor"],
                      offerTextcolor: uiData["template12"]["offerTextcolor"],
                      title: uiData["template12"]["title"],
                      unitTextcolor: uiData["template12"]["unitTextcolor"],
                      unitbgcolor: uiData["template12"]["unitbgcolor"],
                      showcategory: uiData["template12"]["show_Category"],
                    ),
                    'order': uiData["template12"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel10(
                      title: uiData["template13"]["title"],
                      titleColor: uiData["template13"]["titleColor"],
                      bgcolor: uiData["template13"]["background_color"],
                      image: uiData["template13"]["image"],
                      cartbuttontextcolor: uiData["template13"]
                          ["cartbuttontextcolor"],
                      mrpcolor: uiData["template13"]["mrpcolor"],
                      crosscolor: uiData["template13"]["crosscolor"],
                      prodoductbgcolor: uiData["template13"]
                          ["prodoductbgcolor"],
                      productTextColor: uiData["template13"]
                          ["productTextColor"],
                      sellingpricecolor: uiData["template13"]
                          ["sellingpricecolor"],
                      seeAllButtonBG: uiData["template13"]["seeAllButtonBG"],
                      seeAllButtontext: uiData["template13"]
                          ["seeAllButtontext"],
                      showcategory: uiData["template13"]["show_Category"],
                    ),
                    'order': uiData["template13"]["ui_order_number"]
                  },

                  {
                    'template': CategoryModel12(
                      producttextcolor: uiData["template14"]
                          ["producttextcolor"],
                      topimage: uiData["template14"]["top_image"],
                      seeAllButtonBG: uiData["template14"]["seeAllButtonBG"],
                      seeAllButtontext: uiData["template14"]
                          ["seeAllButtontext"],
                      maincategories: List<String>.from(
                          uiData["template14"]["maincategories"]),
                      categoryId: uiData["template14"]["category_ref"],
                      bgcolor: uiData["template14"]["bgcolor"],
                      subcatColor: uiData["template14"]["bgcolor"],
                      mrpColor: uiData["template14"]["mrpColor"],
                      productBgColor: uiData["template14"]["productBgColor"],
                      sellingPriceColor: uiData["template14"]
                          ["sellingPriceColor"],
                      buttontextcolor: uiData["template14"]["buttontextcolor"],
                      offerTextcolor: uiData["template14"]["offerTextcolor"],
                      offerbgcolor: uiData["template14"]["offerBGcolor"],
                      unitTextcolor: uiData["template14"]["unitTextcolor"],
                      unitbgcolor: uiData["template14"]["unitbgcolor"],
                      showcategory: uiData["template14"]["show_Category"],
                    ),
                    'order': uiData["template14"]["ui_order_number"]
                  },

                  {
                    'template': CategoryModel14(
                      producttextcolor: uiData["template15"]
                          ["producttextcolor"],
                      maincategories: List<String>.from(
                          uiData["template15"]["sub_categories"]),
                      categoryId: uiData["template15"]["category_ref"],
                      bgcolor: uiData["template15"]["background_color"],
                      titleColor: uiData["template15"]["titleColor"],
                      subcatColor: uiData["template15"]["subcat_color"],
                      offerBGcolor: uiData["template15"]["offer_bg_color"],
                      mrpColor: uiData["template15"]["mrp_color"],
                      productBgColor: uiData["template15"]
                          ["product_background_color"],
                      sellingPriceColor: uiData["template15"]
                          ["saleprice_color"],
                      categoryName: uiData["template15"]["category_name"],
                      brandImage: uiData["template15"]["brand_image"],
                      indicatercolor: uiData["template15"]["indicatercolor"],
                    ),
                    'order': uiData["template15"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel15(
                      topimage: uiData["template16"]["top_image"],
                      seeAllButtonBG: uiData["template16"]["seeAllButtonBG"],
                      seeAllButtontext: uiData["template16"]
                          ["seeAllButtontext"],
                      productnamecolor: uiData["template16"]
                          ["producttitlecolor"],
                      offerbgcolor: uiData["template16"]["offerbgcolor"],
                      maincategories: List<String>.from(
                          uiData["template16"]["maincategories"]),
                      categoryId: uiData["template16"]["category_ref"],
                      bgcolor: uiData["template16"]["bgcolor"],
                      subcatColor: uiData["template16"]["bgcolor"],
                      mrpColor: uiData["template16"]["mrpColor"],
                      productBgColor: uiData["template16"]["productBgColor"],
                      sellingPriceColor: uiData["template16"]
                          ["sellingPriceColor"],
                      buttontextcolor: uiData["template16"]["buttontextcolor"],
                      offerTextcolor: uiData["template16"]["offerTextcolor"],
                      unitTextcolor: uiData["template16"]["unitTextcolor"],
                      unitbgcolor: uiData["template16"]["unitbgcolor"],
                      showcategory: uiData["template16"]["show_Category"],
                    ),
                    'order': uiData["template16"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel16(
                      subcategroylist: List<String>.from(
                          uiData["template17"]["subcategorylist"]),
                      categorybgcolor: uiData["template17"]["categorybgcolor"],
                      offerbgcolor: uiData["template17"]["offerbgcolor"],
                      offertext1: uiData["template17"]["offertext1"],
                      offertext2: uiData["template17"]["offertext2"],
                      title: uiData["template17"]["title"],
                      categoryId: uiData["template17"]["category"],
                      bgcolor: uiData["template17"]["background_color"],
                      titleColor: uiData["template17"]["titleColor"],
                      showcategory: uiData["template17"]["show_Category"],
                    ),
                    'order': uiData["template17"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel17(
                      category: uiData["template18"]["categoryid"],
                      categoryId1: uiData["template18"]["categoryId1"],
                      categoryId2: uiData["template18"]["categoryId2"],
                      categoryId3: uiData["template18"]["categoryId3"],
                      image1: uiData["template18"]["image1"],
                      image2: uiData["template18"]["image2"],
                      image3: uiData["template18"]["image3"],
                      title: uiData["template18"]["title"],
                      bgcolor: uiData["template18"]["background_color"],
                      titleColor: uiData["template18"]["title_color"],
                      showcategory: uiData["template18"]["show_Category"],
                    ),
                    'order': uiData["template18"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel18(
                      maincategories: List<String>.from(
                          uiData["template19"]["maincategories"]),
                      categoryId: uiData["template19"]["category_ref"],
                      bgcolor: uiData["template19"]["background_color"],
                      offerBGcolor: uiData["template19"]["offer_bg_color"],
                      showcategory: uiData["template19"]["show_Category"],
                      bannerimageurl: uiData["template19"]["bannerimageurl"],
                      categoryBgColor: uiData["template19"]["categoryBgColor"],
                      categorytitlecolor: uiData["template19"]
                          ["categorytitlecolor"],
                      offertextcolor1: uiData["template19"]["offertextcolor1"],
                      offertextcolor2: uiData["template19"]["offertextcolor2"],
                      seeallbuttonbgcolor: "000000",
                      seeallbuttontextcolor: "FFFFFF",
                    ),
                    'order': uiData["template19"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel19(
                      producttextcolor: uiData["template20"]
                          ["producttextcolor"],
                      topimage: uiData["template20"]["topimage"],
                      maincategories: List<String>.from(
                          uiData["template20"]["sub_categories"]),
                      categoryId: uiData["template20"]["category_ref"],
                      bgcolor: uiData["template20"]["background_color"],
                      subcatColor: uiData["template20"]["subcat_color"],
                      offerBGcolor1: uiData["template20"]["offer_bg_color"],
                      mrpColor: uiData["template20"]["mrp_color"],
                      productBgColor: uiData["template20"]
                          ["product_background_color"],
                      sellingPriceColor: uiData["template20"]
                          ["saleprice_color"],
                      showcategory: uiData["template20"]["show_Category"],
                      buttonbgcolor: uiData["template20"]["buttonbgcolor"],
                      buttontextcolor: uiData["template20"]["buttontextcolor"],
                      indicatercolor: uiData["template20"]["indicatercolor"],
                      offertextcolor1: uiData["template20"]["offertextcolor"],
                      unitcolor: uiData["template20"]["unitcolor"],
                      unitbgcolor: uiData["template20"]["unitbgcolor"],
                      seeallbgcolorl: uiData["template20"]["seeallbgcolor"],
                      seealltextcolor: uiData["template20"]["seealltextcolor"],
                      offerBGcolor2: uiData["template20"]["offerBGcolor2"],
                      offerBordercolor: uiData["template20"]
                          ["offerBordercolor"],
                      offertextcolor2: uiData["template20"]["offertextcolor2"],
                    ),
                    'order': uiData["template20"]["ui_order_number"]
                  },
                  {
                    'template': const DescriptiveWidget(
                      textColor: '989898',
                      info: 'Delivery',
                      title: "Always on Your Time",
                      logo:
                          "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                      showcategory: true,
                    ),
                    'order': "88888"
                  },
                  // {'template': const SizedBox(height: 50), 'order': "500"}
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
                            backgroundColor: const Color(0xFFfecc6c),
                            foregroundColor: const Color(0xFFfecc6c),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFfecc6c),
                                      Color(0xFFfecc6c)
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
                                            color: const Color(0xFFCC9320),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          "Less then",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textColorWhite),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("30 min delivery",
                                              style: theme.textTheme.titleLarge!
                                                  .copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .textColorblack)),
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
                                              "assets/images/addresshome_icon.svg"),
                                          Text(
                                              " J236, Kadampukur village, Newtown...",
                                              maxLines: 1,
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: AppColors
                                                          .textColorblack)),
                                        ],
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
                            delegate: SearchBarDelegate(state.searchterm),
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
          color: const Color(0xFFfecc6c),
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





/// Removed home page widgets 


 // {
                  //   'template': CategoryModel13(
                  //     maincategories: List<String>.from(
                  //         uiData["template15"]["sub_categories"]),
                  //     categoryId: uiData["template15"]["category_ref"],
                  //     bgcolor: uiData["template15"]["bgcolor"],
                  //     titleColor: uiData["template15"]["titleColor"],
                  //     subcatColor: uiData["template15"]["subcat_color"],
                  //     offerBGcolor: uiData["template15"]["offer_bg_color"],
                  //     mrpColor: uiData["template15"]["mrp_color"],
                  //     productBgColor: uiData["template15"]
                  //         ["product_background_color"],
                  //     sellingPriceColor: uiData["template15"]
                  //         ["saleprice_color"],
                  //     categoryName: uiData["template15"]["category_name"],
                  //     brandImage: uiData["template15"]["brand_image"],
                  //   ),
                  //   'order': uiData["template15"]["ui_order_number"]
                  // },
                   // {
                  //   'template': CategoryModel11(
                  //     percentBgColor: 'B8E1FF',
                  //     descriptionTextColor: '',
                  //     percentDisplayPosition: 30,
                  //     titleTopDisplayPosition: false,
                  //     description: "",
                  //     categoryId: uiData["template7"]["category_ref"],
                  //     bgcolor: "D5E9FF",
                  //     titleColor: uiData["template7"]["title_color"],
                  //     subcatColor: uiData["template7"]["subcat_color"],
                  //     seeContainColor: "B8E1FF",
                  //     brandIcon:
                  //         "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/bxs_offer.png?alt=media&token=f6cd9a07-d6f5-4f40-84cb-4748769a0ed9",
                  //   ),
                  //   'order': uiData["template14"]["ui_order_number"]
                  // },
                   // {
                  //   'template': CategoryModel7(
                  //     subcategoryid: uiData["template10"]["category_ref"],
                  //     titleColor: uiData["template10"]["title_color"],
                  //     bgcolor: uiData["template10"]["background_color"],
                  //     cartbuttontextcolor: uiData["template10"]
                  //         ["cartbuttontextcolor"],
                  //     mrpcolor: uiData["template10"]["mrpcolor"],
                  //     offerBGcolor: uiData["template10"]["offerBGcolor"],
                  //     offerTextcolor: uiData["template10"]["offerTextcolor"],
                  //     prodoductbgcolor: uiData["template10"]
                  //         ["prodoductbgcolor"],
                  //     productTextColor: uiData["template10"]
                  //         ["productTextColor"],
                  //     sellingpricecolor: uiData["template10"]
                  //         ["sellingpricecolor"],
                  //     seeAllButtonBG: uiData["template10"]["seeAllButtonBG"],
                  //     seeAllButtontext: uiData["template10"]
                  //         ["seeAllButtontext"],
                  //   ),
                  //   'order': uiData["template10"]["ui_order_number"]
                  // },
                  // {
                  //   'template': CategoryModel8(
                  //     bgColor: uiData["template11"]["background_color"],
                  //     categoryBG: uiData["template11"]["subcategorybg"],
                  //     iconBGcolor: uiData["template11"]["icon_bg_color"],
                  //     iconcolor: uiData["template11"]["icon_color"],
                  //     title: uiData["template11"]["title"],
                  //     categories: categorymodel8Categories,
                  //     titlecolor: uiData["template11"]["title_color"],
                  //     categorytitlecolor: uiData["template11"]
                  //         ["subcat_title_color"],
                  //   ),
                  //   'order': uiData["template11"]["ui_order_number"]
                  // },
