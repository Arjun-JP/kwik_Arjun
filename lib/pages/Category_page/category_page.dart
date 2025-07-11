import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_bloc.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_state.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_event.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/pages/Address_management/location_search_page.dart';
import 'package:kwik/pages/Category_page/Categories%20Page%20Widgets/category_model.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/widgets/navbar/navbar.dart';
import 'package:kwik/widgets/shimmer/main_loading_indicator.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';
import '../../bloc/Categories Page Bloc/categories_UI_bloc/categories_ui_bloc.dart';
import '../../bloc/Categories Page Bloc/categories_page_model1/categories_page_model1_bloc.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_event.dart';
import '../../bloc/navbar_bloc/navbar_event.dart';
import '../../constants/colors.dart';

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
    BlocProvider.of<CategoryBlocModel>(context).add(ClearCacheCM());
    context.read<RecommendedProductsBloc>().add(ClearRecommendedproductCache());
    context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NetworkUtils.checkConnection(context);
    });
    super.initState();
    context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
    // context.read<AddressBloc>().add(const GetsavedAddressEvent());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<CategoriesUiBloc, CategoriesUiState>(
        builder: (context, state) {
      if (state is CategoryInitial) {
        context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
      } else if (state is CatUiLoading) {
        return const Center(child: MainLoadingIndicator());
      } else if (state is CatUiLoaded) {
        final uiData = state.uiData;
        final templates = [
          {
            'template': CategoryModel(
              maincategories:
                  List<String>.from(uiData["template1"]["main_categories"]),
              secondarycategories:
                  List<String>.from(uiData["template1"]["Sub_categories"]),
              categoryId: uiData["template1"]["category"],
              bgcolor: uiData["template1"]["background_color"] ?? "FFFFFF",
              title: uiData["template1"]["title"],
              titleColor: uiData["template1"]["title_color"] ?? "FFFFFF",
              subcatColor:
                  uiData["template1"]["subcategory_title_color"] ?? "FFFFFF",
              showcategory: uiData["template1"]["show_Category"],
            ),
            'order': uiData["template1"]["ui_order_number"]
          },
          {
            'template': CategoryModel(
              maincategories:
                  List<String>.from(uiData["template2"]["main_categories"]),
              secondarycategories:
                  List<String>.from(uiData["template2"]["Sub_categories"]),
              categoryId: uiData["template2"]["category"],
              bgcolor: uiData["template2"]["background_color"] ?? "FFFFFF",
              title: uiData["template2"]["title"],
              titleColor: uiData["template2"]["title_color"] ?? "FFFFFF",
              subcatColor:
                  uiData["template2"]["subcategory_title_color"] ?? "FFFFFF",
              showcategory: uiData["template2"]["show_Category"],
            ),
            'order': uiData["template2"]["ui_order_number"]
          },
          {
            'template': CategoryModel(
              maincategories:
                  List<String>.from(uiData["template3"]["main_categories"]),
              secondarycategories:
                  List<String>.from(uiData["template3"]["Sub_categories"]),
              categoryId: uiData["template3"]["category"],
              bgcolor: uiData["template3"]["background_color"] ?? "FFFFFF",
              title: uiData["template3"]["title"],
              titleColor: uiData["template3"]["title_color"] ?? "FFFFFF",
              subcatColor:
                  uiData["template3"]["subcategory_title_color"] ?? "FFFFFF",
              showcategory: uiData["template3"]["show_Category"],
            ),
            'order': uiData["template3"]["ui_order_number"]
          },
          {
            'template': CategoryModel(
              maincategories:
                  List<String>.from(uiData["template4"]["main_categories"]),
              secondarycategories:
                  List<String>.from(uiData["template4"]["Sub_categories"]),
              categoryId: uiData["template4"]["category"],
              bgcolor: uiData["template4"]["background_color"] ?? "FFFFFF",
              title: uiData["template4"]["title"],
              titleColor: uiData["template4"]["title_color"] ?? "FFFFFF",
              subcatColor:
                  uiData["template4"]["subcategory_title_color"] ?? "FFFFFF",
              showcategory: uiData["template4"]["show_Category"],
            ),
            'order': uiData["template4"]["ui_order_number"]
          },
          {
            'template': CategoryModel(
              maincategories:
                  List<String>.from(uiData["template5"]["main_categories"]),
              secondarycategories:
                  List<String>.from(uiData["template5"]["Sub_categories"]),
              categoryId: uiData["template5"]["category"],
              bgcolor: uiData["template5"]["background_color"] ?? "FFFFFF",
              title: uiData["template5"]["title"],
              titleColor: uiData["template5"]["title_color"] ?? "FFFFFF",
              subcatColor:
                  uiData["template5"]["subcategory_title_color"] ?? "FFFFFF",
              showcategory: uiData["template5"]["show_Category"],
            ),
            'order': uiData["template4"]["ui_order_number"]
          },
          {
            'template': const DescriptiveWidget(
              showcategory: true,
              title: "Skip the store, we're at your door!",
              logo: "assets/images/kwiklogo.png",
            ),
            'order': "88888"
          },
          {'template': const SizedBox(height: 40), 'order': "500"}
        ];

        templates.sort(
            (a, b) => int.parse(a['order']).compareTo(int.parse(b['order'])));
        return Container(
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
                parseColor(uiData["template11"]["appbarcolor"] ?? ''),
                parseColor(uiData["template11"]["appbarcolor"] ?? ''),
                const Color(0xFFFFFFFff),
                const Color(0xFFFFFFFff),
                const Color(0xFFFFFFFff),
                const Color(0xFFFFFFFff)
              ])),
          child: Scaffold(
              backgroundColor: const Color(0xFFFFFF),
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
                          backgroundColor: parseColor(
                              uiData["template11"]["appbarcolor"] ?? ''),
                          foregroundColor: parseColor(
                              uiData["template11"]["appbarcolor"] ?? ''),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    parseColor(uiData["template11"]
                                            ["appbarcolor"] ??
                                        ''),
                                    parseColor(uiData["template11"]
                                            ["appbarcolor"] ??
                                        ''),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: parseColor(uiData["template11"]
                                                  ["text1bg"] ??
                                              ''),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        uiData["template11"]["text1"],
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: parseColor(uiData["template11"]
                                                  ["text1clr"] ??
                                              ''),
                                        ),
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
                                          Text(uiData["template11"]["title2"],
                                              style: theme.textTheme.titleLarge!
                                                  .copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: parseColor(uiData[
                                                                  "template11"]
                                                              ["text2clr"] ??
                                                          ''))),
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
                                                    uiData["template11"]
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
                                              "assets/images/addresshome_icon.svg"),
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
                                                                  "template11"]
                                                              ["addressclr"])));
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
                          delegate: SearchBarDelegate("Products"),
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
              ),
              bottomNavigationBar: const Navbar()),
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
        child: BlocBuilder<CategoriesUiBloc, CategoriesUiState>(
            builder: (context, state) {
          if (state is CategoryInitial) {
            context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
          } else if (state is CatUiLoading) {
            return const Center(child: MainLoadingIndicator());
          } else if (state is CatUiLoaded) {
            final uiData = state.uiData;
            return Container(
              height: 80,
              color: parseColor(uiData["template11"]["appbarcolor"]),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: parseColor(uiData["template11"]["textfieldbg"]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/search.svg",
                      fit: BoxFit.contain,
                      width: 30,
                      height: 20,
                      color: parseColor(uiData["template11"]["hintclr"]),
                    ),
                    const SizedBox(width: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        uiData["template11"]["hinttext"],
                        key: ValueKey(searchText),
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: parseColor(uiData["template11"]["hintclr"]),
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
