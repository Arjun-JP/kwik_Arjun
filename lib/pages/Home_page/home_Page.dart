import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model1.dart';
import 'package:kwik/pages/Home_page/widgets/category_Tab.dart';

import '../../constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeUiBloc>().add(FetchUiDataEvent()); // Correct Bloc usage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeUiBloc, HomeUiState>(
        builder: (context, state) {
          if (state is UiInitial || state is UiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UiLoaded) {
            final uiData = state.uiData;
            final categoryRef =
                List<String>.from(uiData["categorylist"]["category_ref"]);
            final templates = [
              {
                'template': CategoryTab(
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
            ];

// Sort first by order, then by the secondary key (name)
            templates.sort((a, b) =>
                int.parse(a['order']).compareTo(int.parse(b['order'])));

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // SliverAppBar with Profile Icon (Scrolls away)
                  SliverAppBar(
                    pinned: false, // Not pinned, scrolls away
                    expandedHeight: 80,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFCFB8), Colors.white],
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
                        padding: const EdgeInsets.only(right: 12.0, top: 12),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            "assets/images/User_fill.png",
                          ), // Scrolls away
                        ),
                      ),
                    ],
                  ),

                  // Pinned Search Bar
                  SliverPersistentHeader(
                    pinned: true, // This keeps the search bar visible
                    floating: false,
                    delegate: _SearchBarDelegate(),
                  ),

                  // Dynamically displaying templates based on order
                  ...templates.map((template) {
                    return SliverToBoxAdapter(
                      child: template['template'],
                    );
                  }).toList(),
                ],
              ),
            );
          } else if (state is UiError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else {
            return const Text('Unexpected state');
          }
        },
      ),
    );
  }
}

// Custom Search Bar Delegate to Pin Search Bar
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SafeArea(
      child: Container(
        color: Colors.white, // Background color for search bar
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: TextField(
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.dotColorUnSelected),
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
                borderSide:
                    const BorderSide(color: AppColors.dotColorUnSelected),
                borderRadius: BorderRadius.circular(10),
              ),
              hintStyle: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textColorGrey,
                  fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60; // Search bar height
  @override
  double get minExtent => 60; // Search bar height
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

// Category Widget
Widget categoys({
  required String catRef,
  required String bgcolor,
  required String categoryName,
}) {
  return Container(
    width: 300,
    height: 200,
    color: Colors.red, // Fixed color parsing
    child: Center(
      child: Text(categoryName, style: const TextStyle(color: Colors.white)),
    ),
  );
}
