import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

import '../../../bloc/Super Saver Page Bloc/supersaver_model1_bloc/supersaver_model1_bloc.dart';
import '../../../repositories/offerzone_cat1_repo.dart';
import '../../Category_page/Categories Page Widgets/categories_page_model2.dart';

class SupersaverModel1 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String subcatcolor1;
  final String subcatcolor2;
  final String titleColor;
  final String priceColor;
  final String vegOrNonIcon;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  const SupersaverModel1(
      {super.key,
      required this.categoryId,
      required this.bgcolor,
      required this.subcatcolor1,
      required this.subcatcolor2,
      required this.titleColor,
      required this.priceColor,
      required this.vegOrNonIcon,
      required this.seeAllButtonBG,
      required this.seeAllButtontext});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (context) =>
          SupersaverModel1BlocBloc(offerzoneCat1Repo: OfferzoneCat1Repo())
            ..add(FetchCategoryDetailsSuperSave1(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<SupersaverModel1BlocBloc,
              SupersaverModel1BlocState>(
            builder: (context, state) {
              if (state is SupersaverModel1Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SupersaverModel1Loaded) {
                return Container(
                  color: parseColor(bgcolor),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Daily Essentials",
                        //state.category.name,
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: StaggeredGrid.count(
                              axisDirection: AxisDirection.right,
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              children: List.generate(
                                state.subCategories.length,
                                (index) {
                                  return InkWell(
                                    onTap: () => context.push(
                                        "/allsubcategorypage?categoryId=$categoryId&selectedsubcategory=${state.subCategories[index]}"),
                                    child: subcategoryItemOffer(
                                      theme: theme,
                                      titleColor: titleColor,
                                      name: state.subCategories[index].name,
                                      bgcolor: state.category.color,
                                      textcolor: titleColor,
                                      imageurl:
                                          state.subCategories[index].imageUrl,
                                      subcatcolor1: subcatcolor1,
                                      subcatcolor2: subcatcolor2,
                                      priceColor: priceColor,
                                      vegOrNonIcon: vegOrNonIcon,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )),
                      const SizedBox(height: 15),
                      // InkWell(
                      //   onTap: () => context.push(
                      //       "/allsubcategorypage?categoryId=$categoryId&selectedsubcategory=${maincategories.first}"),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: 45,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       color: parseColor(subcatcolor1),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Expanded(
                      //           flex: 5,
                      //           child: Align(
                      //             alignment: Alignment.centerRight,
                      //             child: Text('See all Categories',
                      //                 style: TextStyle(
                      //                     color: parseColor(priceColor),
                      //                     fontSize: 18)),
                      //           ),
                      //         ),
                      //         Expanded(
                      //           flex: 2,
                      //           child: Align(
                      //             alignment: Alignment.centerRight,
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(right: 14.0),
                      //               child: Icon(
                      //                 Icons.arrow_forward,
                      //                 color: parseColor(priceColor),
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              } else if (state is SupersaverModel1Error) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget subcategoryItemOffer(
      {required ThemeData theme,
      required String name,
      required String bgcolor,
      required String textcolor,
      required String subcatcolor1,
      required String subcatcolor2,
      required String priceColor,
      required String titleColor,
      required String vegOrNonIcon,
      required String imageurl}) {
    return Container(
      width: 165,
      height: 73,
      padding: const EdgeInsets.only(left: 8, top: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              parseColor(subcatcolor1),
              parseColor(subcatcolor2),
              parseColor(subcatcolor1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                vegOrNonIcon,
                height: 15,
                width: 15,
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 90,
                child: Text(name,
                    maxLines: 2,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: parseColor(titleColor))),
              ),
              const SizedBox(height: 5),
              const Text(
                "Starts at",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  text: "₹",
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: parseColor(priceColor)),
                  children: [
                    TextSpan(
                      text: "330",
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: parseColor(priceColor)),
                    ),
                    TextSpan(
                      text: "/kg",
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: parseColor(priceColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(12)),
            child: Image.network(
              imageurl,
              width: 60,
              height: 260,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 5)
        ],
      ),
    );
  }
}
