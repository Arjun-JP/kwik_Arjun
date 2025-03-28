import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/pages/Category_page/Categories%20Page%20Widgets/category_model.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/widgets/navbar/navbar.dart';
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
    context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
  }

  @override
  void initState() {
    super.initState();
    context.read<CategoriesUiBloc>().add(FetchCatUiDataEvent());
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
          backgroundColor: const Color(0xFFFFFF),
          body: BlocBuilder<CategoriesUiBloc, CategoriesUiState>(
            builder: (context, state) {
              if (state is CatUiLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CatUiLoaded) {
                final uiData = state.uiData;

                final templates = [
                  {
                    'template': CategoryModel(
                      maincategories: List<String>.from(
                          uiData["template1"]["main_categories"]),
                      secondarycategories: List<String>.from(
                          uiData["template1"]["Sub_categories"]),
                      categoryId: uiData["template1"]["category"],
                      bgcolor:
                          uiData["template1"]["background_color"] ?? "FFFFFF",
                      title: uiData["template1"]["title"],
                      titleColor:
                          uiData["template1"]["title_color"] ?? "FFFFFF",
                      subcatColor: uiData["template1"]
                              ["subcategory_title_color"] ??
                          "FFFFFF",
                      showcategory: uiData["template1"]["show_Category"],
                    ),
                    'order': uiData["template1"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel(
                      maincategories: List<String>.from(
                          uiData["template2"]["main_categories"]),
                      secondarycategories: List<String>.from(
                          uiData["template2"]["Sub_categories"]),
                      categoryId: uiData["template2"]["category"],
                      bgcolor:
                          uiData["template2"]["background_color"] ?? "FFFFFF",
                      title: uiData["template2"]["title"],
                      titleColor:
                          uiData["template2"]["title_color"] ?? "FFFFFF",
                      subcatColor: uiData["template2"]
                              ["subcategory_title_color"] ??
                          "FFFFFF",
                      showcategory: uiData["template2"]["show_Category"],
                    ),
                    'order': uiData["template2"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel(
                      maincategories: List<String>.from(
                          uiData["template3"]["main_categories"]),
                      secondarycategories: List<String>.from(
                          uiData["template3"]["Sub_categories"]),
                      categoryId: uiData["template3"]["category"],
                      bgcolor:
                          uiData["template3"]["background_color"] ?? "FFFFFF",
                      title: uiData["template3"]["title"],
                      titleColor:
                          uiData["template3"]["title_color"] ?? "FFFFFF",
                      subcatColor: uiData["template3"]
                              ["subcategory_title_color"] ??
                          "FFFFFF",
                      showcategory: uiData["template3"]["show_Category"],
                    ),
                    'order': uiData["template3"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel(
                      maincategories: List<String>.from(
                          uiData["template4"]["main_categories"]),
                      secondarycategories: List<String>.from(
                          uiData["template4"]["Sub_categories"]),
                      categoryId: uiData["template4"]["category"],
                      bgcolor:
                          uiData["template4"]["background_color"] ?? "FFFFFF",
                      title: uiData["template4"]["title"],
                      titleColor:
                          uiData["template4"]["title_color"] ?? "FFFFFF",
                      subcatColor: uiData["template4"]
                              ["subcategory_title_color"] ??
                          "FFFFFF",
                      showcategory: uiData["template4"]["show_Category"],
                    ),
                    'order': uiData["template4"]["ui_order_number"]
                  },
                  {
                    'template': CategoryModel(
                      maincategories: List<String>.from(
                          uiData["template5"]["main_categories"]),
                      secondarycategories: List<String>.from(
                          uiData["template5"]["Sub_categories"]),
                      categoryId: uiData["template5"]["category"],
                      bgcolor:
                          uiData["template5"]["background_color"] ?? "FFFFFF",
                      title: uiData["template5"]["title"],
                      titleColor:
                          uiData["template5"]["title_color"] ?? "FFFFFF",
                      subcatColor: uiData["template5"]
                              ["subcategory_title_color"] ??
                          "FFFFFF",
                      showcategory: uiData["template5"]["show_Category"],
                    ),
                    'order': uiData["template4"]["ui_order_number"]
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
                    'order': "88888"
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
        color: const Color(0xFFfecc6c),
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
