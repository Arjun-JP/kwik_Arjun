import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/category_model_1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/category_model_1_bloc/category_model1_event.dart';
import 'package:kwik/bloc/category_model_1_bloc/category_model1_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model1_repository.dart';

class CategoriesPageModel10 extends StatelessWidget {
  final String bgcolor;
  final String productColor;

  final String offerPercent;
  final String titleColor;
  final String categoryId;
  final List<String> maincategories;
  const CategoriesPageModel10({
    super.key,
    required this.bgcolor,
    required this.productColor,
    required this.offerPercent,
    required this.titleColor,
    required this.maincategories,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBlocModel1(
          categoryRepositoryModel1: CategoryRepositoryModel1())
        ..add(FetchCategoryDetails(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoryBlocModel1, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                var filteredSubCategories = state.subCategories
                    .where((subCategory) =>
                        maincategories.contains(subCategory.id))
                    .toList();

                return Container(
                  height: 430,
                  color: parseColor(bgcolor),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Unbelievable',
                        style: TextStyle(
                          color: parseColor(titleColor),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.category.name, // Display main category name
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          spacing: 15,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(filteredSubCategories.length,
                              (index) {
                            final subCategory = filteredSubCategories[index];
                            return mainsubcategoryItem(
                                name: subCategory.name,
                                bgcolor: state.category.color,
                                textcolor: titleColor,
                                imageurl: subCategory.imageUrl,
                                offerPercent: offerPercent,
                                productColor: productColor);
                          }),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Upto $offerPercent off',
                        style: TextStyle(
                          color: parseColor(titleColor),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Lowest Price Ever',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: parseColor(titleColor)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 200,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: parseColor(productColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Shop Now',
                                    style: TextStyle(
                                        color: parseColor(titleColor),
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
                                    color: parseColor(titleColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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

Widget mainsubcategoryItem({
  required String name,
  required String bgcolor,
  required String textcolor,
  required String imageurl,
  required String offerPercent,
  required String productColor,
}) {
  return Container(
    width: 100,
    height: 171,
    decoration: BoxDecoration(
      color: AppColors.kwhiteColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text(
          'Upto \n$offerPercent off',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: parseColor(textcolor),
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: parseColor(productColor),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageurl,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: parseColor(textcolor), // Ensure text is readable
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
