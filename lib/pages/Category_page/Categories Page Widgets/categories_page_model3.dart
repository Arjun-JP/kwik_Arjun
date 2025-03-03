import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

import '../../../bloc/Categories Page Bloc/categories_page_model3/categories_page_model3_bloc.dart';
import '../../Home_page/widgets/category_model_11.dart';

class CategoriesPageModel3 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;

  final String seeAllButtonBG;
  final String seeAllButtontext;
  final String description;
  final String brandIcon;
  final double percentDisplayPosition;
  final bool titleTopDisplayPosition;
  final String descriptionTextColor;
  final String percentBgColor;
  const CategoriesPageModel3({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.description,
    required this.brandIcon,
    required this.subcatColor,
    required this.percentDisplayPosition,
    required this.titleTopDisplayPosition,
    required this.descriptionTextColor,
    required this.percentBgColor,
    required this.seeAllButtonBG,
    required this.seeAllButtontext,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesPageModel3Bloc(
          categoryRepositoryModel2: CategoryRepositoryModel2())
        ..add(FetchCategoryDetailsModel3(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoriesPageModel3Bloc,
              CategoriesPageModel3State>(
            builder: (context, state) {
              if (state is CategoriesPageModel3Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesPageModel3Loaded) {
                return Container(
                  color: parseColor(bgcolor),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.category
                                            .name, // Display main category name
                                        style: TextStyle(
                                            color: parseColor(titleColor),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        description,
                                        style: TextStyle(
                                            color: parseColor(
                                                descriptionTextColor),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Image.network(
                                brandIcon,
                              ))
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 340,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          itemCount: state.subCategories.length,
                          // scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: .66,
                            crossAxisCount: 3,
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 25,
                          ),
                          itemBuilder: (context, index) {
                            return subcategoryItem(
                                name: state.subCategories[index].name,
                                bgcolor: state.category.color,
                                textcolor: subcatColor,
                                imageurl: state.subCategories[index].imageUrl,
                                titleTopDisplayPosition:
                                    titleTopDisplayPosition,
                                percentBgColor: percentBgColor,
                                percentDisplayPosition: percentDisplayPosition);
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: parseColor(seeAllButtonBG),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('See all products',
                                    style: TextStyle(
                                        color: parseColor(seeAllButtontext),
                                        fontSize: 18)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Icon(Icons.arrow_forward,
                                      color: parseColor("000000")),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                );
              } else if (state is CategoriesPageModel3Error) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
