import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model2_repository.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';

import '../../../bloc/home_page_bloc/category_model_2_bloc/category_model2_bloc.dart';

class CategoryModel11 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  final String? seeContainColor;
  final String description;
  final String brandIcon;
  final double percentDisplayPosition;
  final bool titleTopDisplayPosition;
  final String descriptionTextColor;
  final String percentBgColor;

  const CategoryModel11({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    this.seeContainColor,
    required this.description,
    required this.brandIcon,
    required this.subcatColor,
    required this.percentDisplayPosition,
    required this.titleTopDisplayPosition,
    required this.descriptionTextColor,
    required this.percentBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBlocModel2(
          categoryRepositoryModel2: CategoryRepositoryModel2())
        ..add(FetchCategoryDetails(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoryBlocModel2, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: ProductModel1ListShimmer());
              } else if (state is CategoryLoaded) {
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
                          color: parseColor(seeContainColor),
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
                                        color: parseColor("000000"),
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
              } else if (state is CategoryError) {
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

Widget subcategoryItem({
  required String name,
  required String bgcolor,
  required String textcolor,
  required String imageurl,
  required bool titleTopDisplayPosition,
  required double percentDisplayPosition,
  required String percentBgColor,
}) {
  return Column(
    children: [
      if (titleTopDisplayPosition)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      Stack(
        children: [
          Container(
            height: 120,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: parseColor(bgcolor),
                image: DecorationImage(
                    image: NetworkImage(imageurl), fit: BoxFit.fill)),
          ),

          Positioned(
            top: percentDisplayPosition,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              decoration: BoxDecoration(
                  color: parseColor(percentBgColor),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upto",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "20% OFF",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          // Text(
          //   name,
          //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          // ),
        ],
      ),
      if (!titleTopDisplayPosition)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            name,
            maxLines: 2,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
    ],
  );
}
