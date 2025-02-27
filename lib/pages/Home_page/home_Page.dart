import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/category_model2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/category_model_4_bloc/category_model_4_bloc.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__event.dart';
import 'package:kwik/bloc/category_model_6_bloc/category_model_6_bloc.dart';
import 'package:kwik/bloc/category_model_6_bloc/category_model_6_event.dart';
import 'package:kwik/bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_10.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_11.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_2.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_3.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_4.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_7.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_8.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_9.dart';
//import 'package:kwik/pages/Home_page/widgets/category_model_8.dart';
import 'package:kwik/widgets/navbar/navbar.dart';
import '../../bloc/category_model1_bloc/category_model1_event.dart';
import '../../bloc/category_model2_bloc/category_model2_event.dart';
import '../../bloc/category_model_10_bloc/category_model_10_bloc.dart';
import '../../bloc/category_model_10_bloc/category_model_10_event.dart';
import '../../bloc/category_model_4_bloc/category_model_4_event.dart';
import '../../bloc/category_model_7_bloc/category_model_7_bloc.dart';
import '../../bloc/category_model_7_bloc/category_model_7_event.dart';
import '../../bloc/category_model_9_bloc/category_model_9_event.dart';
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
                  'template': CategoryModel1(
                    bgColor: uiData["categorylist"]["background_color"],
                    categories: categoryRef,
                    titlecolor: uiData["categorylist"]["title_color"],
                    textcolor: uiData["categorylist"]["subcategory_color"],
                  ),
                  'order': uiData["categorylist"]["ui_order_number"]
                },
                {
                  'template': BannerModel1(
                    titlecolor: uiData["template2"]["title_color"],
                    bgColor: uiData["template2"]["background_color"],
                    bannerId: 1,
                    height: 200,
                  ),
                  'order': uiData["template2"]["ui_order_number"]
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
                  ),
                  'order': uiData["template4"]["ui_order_number"]
                },
                {
                  'template': BannerModel1(
                    titlecolor: uiData["template5"]["title_color"],
                    bgColor: uiData["template5"]["background_color"],
                    bannerId: 3,
                    height: 300,
                    padding: 0,
                    borderradious: 0,
                  ),
                  'order': uiData["template5"]["ui_order_number"]
                },
                {
                  'template': CategoryModel4(
                    seeAllButtonBG: "D5E2C9",
                    seeAllButtontext: "35AB4E",
                    flashBgColor: "",
                    flashTextColor: "",
                    flashSaleBanner: false,
                    mrpColor: uiData["template6"]["mrp_color"],
                    sellingpricecolor: uiData["template6"]
                        ["selling_price_color"],
                    subCategoryId: uiData["template6"]["sub_category_ref"],
                    bgcolor: uiData["template6"]["background_color"],
                    titleColor: uiData["template6"]["title_color"],
                    productColor: uiData["template6"]["subcat_color"],
                  ),
                  'order': uiData["template6"]["ui_order_number"]
                },
                {
                  'template': CategoryModel2(
                    categoryId: uiData["template7"]["category_ref"],
                    bgcolor: uiData["template7"]["background_color"],
                    titleColor: uiData["template7"]["title_color"],
                    subcatColor: uiData["template7"]["subcat_color"],
                  ),
                  'order': uiData["template7"]["ui_order_number"]
                },
                {
                  'template': CategoryModel5(
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
                  ),
                  'order': uiData["template9"]["ui_order_number"]
                },
                {
                  'template': CategoryModel7(
                   
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
                  'order': uiData["template10"]["ui_order_number"]
                },
                {
                  'template': CategoryModel8(
                
                    bgColor: uiData["template11"]["background_color"],
                    categoryBG: uiData["template11"]["subcategorybg"],
                    iconBGcolor: uiData["template11"]["icon_bg_color"],
                    iconcolor: uiData["template11"]["icon_color"],
                    title: uiData["template11"]["title"],
                    categories: categorymodel8Categories,
                    titlecolor: uiData["template11"]["title_color"],
                    categorytitlecolor: uiData["template11"]
                        ["subcat_title_color"],
                  ),
                  'order': uiData["template11"]["ui_order_number"]
                },
                {
                  'template': CategoryModel9(
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
                    prodoductbgcolor: uiData["template13"]["prodoductbgcolor"],
                    productTextColor: uiData["template13"]["productTextColor"],
                    sellingpricecolor: uiData["template13"]
                        ["sellingpricecolor"],
                    seeAllButtonBG: uiData["template13"]["seeAllButtonBG"],
                    seeAllButtontext: uiData["template13"]["seeAllButtontext"],
                  ),
                  'order': uiData["template13"]["ui_order_number"]
                },
                {
                  'template': CategoryModel11(
                    percentBgColor: 'B8E1FF',
                    descriptionTextColor: '',
                    percentDisplayPosition: 30,
                    titleTopDisplayPosition: false,
                    description: "",
                    categoryId: uiData["template7"]["category_ref"],
                    bgcolor: "D5E9FF",
                    titleColor: uiData["template7"]["title_color"],
                    subcatColor: uiData["template7"]["subcat_color"],
                    seeContainColor: "B8E1FF",
                    brandIcon:
                        "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/bxs_offer.png?alt=media&token=f6cd9a07-d6f5-4f40-84cb-4748769a0ed9",
                  ),
                  'order': uiData["template14"]["ui_order_number"]
                },
                {'template': const SizedBox(height: 40), 'order': "500"}
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
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Hi, Arjun ",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColorblack,
                                      ),
                                    ),
                                    Text(
                                      "Find your favorite content",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(179, 92, 92, 92),
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
                                onTap: () => context.go('/onboardingScreen'),
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
        color: Color(0xFFFFFFFF),
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
