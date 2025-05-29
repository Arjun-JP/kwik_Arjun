import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class CategoryLandingPageShimmmer extends StatefulWidget {
  const CategoryLandingPageShimmmer({
    super.key,
  });

  @override
  State<CategoryLandingPageShimmmer> createState() =>
      _CategoryLandingPageShimmmerState();
}

class _CategoryLandingPageShimmmerState
    extends State<CategoryLandingPageShimmmer> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 255, 252, 230),
                child: Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                context.pop();
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 25,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.push('/searchpage');
                              },
                              child: SvgPicture.asset(
                                "assets/images/search.svg",
                                width: 25,
                                height: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 130),
                    const SubcategoryList(),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                      (index) => const SizedBox(
                        width: double.infinity,
                        child: Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1),
                            Shimmer(
                              width: 200,
                              height: 16,
                              borderRadius: 5,
                            ),
                            ProductModel1ListShimmer()
                          ],
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              const DescriptiveWidget(
                title: "Skip the store, we're at your door!",
                logo: "assets/images/kwiklogo.png",
                showcategory: true,
              ),
            ],
          ),
        ));
  }
}

class SubcategoryList extends StatelessWidget {
  const SubcategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: StaggeredGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
          6,
          (index) => InkWell(
            onTap: () {},
            child: SizedBox(
              height: 130,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      height: 90,
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFFFFF),
                            lightenColor(parseColor("FFFFFF"), .9),
                            lightenColor(parseColor("FFFFFF"), .8),
                            lightenColor(parseColor("FFFFFF"), .7),
                            lightenColor(parseColor("FFFFFF"), .6),
                            lightenColor(parseColor("FFFFFF"), .5),
                            lightenColor(parseColor("FFFFFF"), .4),
                            lightenColor(parseColor("FFFFFF"), .3),
                            lightenColor(parseColor("FFFFFF"), .2),
                            lightenColor(parseColor("FFFFFF"), .1),
                            parseColor("FFFFFF"),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 230, 230, 230),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer(
                            width: double.infinity,
                            height: 16,
                            borderRadius: 5,
                          ),
                          SizedBox(height: 8),
                          Expanded(
                              child: Shimmer(
                                  width: double.infinity,
                                  height: double.infinity)),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
