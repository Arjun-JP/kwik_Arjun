import 'package:flutter/material.dart';

import 'package:kwik/constants/colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kwik/repositories/category_model2_repository.dart';

import '../../../../bloc/Categories Page Bloc/categories_page_model2/categories_page_model2_bloc.dart';

class CategoriesPageModel2 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String subcatcolor1;
  final String subcatcolor2;
  final String titleColor;
  final String priceColor;
  final String vegOrNonIcon;
  final String seeAllButtonBG;
  final String seeAllButtontext;

  const CategoriesPageModel2(
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
    return BlocProvider(
      create: (context) => CategoriesPageModel2Bloc(
          categoryRepositoryModel2: CategoryRepositoryModel2())
        ..add(FetchCategoryDetailsModel2(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoriesPageModel2Bloc,
              CategoriesPageModel2State>(
            builder: (context, state) {
              if (state is CategoriesPageModel2Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesPageModel2Loaded) {
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
                        "Nuts, Seeds & Berries",
                        //state.category.name,
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 294,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          itemCount: state.subCategories.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return subcategoryItem(
                                name: state.subCategories[index].name,
                                bgcolor: state.category.color,
                                textcolor: titleColor,
                                imageurl: state.subCategories[index].imageUrl);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: parseColor(subcatcolor1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('See all Categories',
                                    style: TextStyle(
                                        color: parseColor(priceColor),
                                        fontSize: 18)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: parseColor(priceColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              } else if (state is CategoriesPageModel2Error) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget subcategoryItem(
      {required String name,
      required String bgcolor,
      required String textcolor,
      required String imageurl}) {
    return Container(
      width: 100,
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
                height: 20,
                width: 20,
              ),
              const SizedBox(height: 5),
              Text(
                "Seeds &\nBerries",
                style: TextStyle(
                  fontSize: 16,
                  color: parseColor(titleColor),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Starts at",
                style: TextStyle(fontSize: 12, color: AppColors.kgreyColorlite),
              ),
              const SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  text: "₹",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: parseColor(priceColor)),
                  children: [
                    TextSpan(
                      text: "330",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: parseColor(priceColor)),
                    ),
                    TextSpan(
                      text: "/kg",
                      style: TextStyle(
                          fontSize: 12, color: parseColor(priceColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Transform.rotate(
              angle: -0.2,
              child: Image.network(
                imageurl,
                width: 50,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
