import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model1_repository.dart';

import '../../../bloc/Categories Page Bloc/categories_page_model8/categories_page_model8_bloc.dart';

class CategoriesPageModel8 extends StatelessWidget {
  final String categoryId;
  final String saleBanner;
  final String bgcolor;
  final String titleColor;
  final String productColor;

  final String subcatColor;
  final List<String> maincategories;
  final List<String> secondarycategories;

  const CategoriesPageModel8({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.subcatColor,
    required this.maincategories,
    required this.secondarycategories,
    required this.saleBanner,
    required this.productColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesPageModel8Bloc(
          categoryRepositoryModel1: CategoryRepositoryModel1())
        ..add(FetchCategoryDetails(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoriesPageModel8Bloc,
              CategoriesPageModel8State>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                var filteredSubCategories = state.subCategories
                    .where((subCategory) =>
                        maincategories.contains(subCategory.id))
                    .toList();
                var filteredSecondarySubCategories = state.subCategories
                    .where((subCategory) =>
                        secondarycategories.contains(subCategory.id))
                    .toList();
                return Container(
                  color: parseColor(bgcolor),
                  width: double.infinity,
                  height: 574,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     const SizedBox(
                        height: 8,
                      ),
                      Text(
                        state.category.name, // Display main category name
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.network(saleBanner, height: 102),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 50,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredSubCategories.length,
                        itemBuilder: (context, index) {
                          final subCategory = filteredSubCategories[index];
                          return mainsubcategoryItem(
                              name: subCategory.name,
                              bgcolor: state.category.color,
                              textcolor: subcatColor,
                              imageurl: subCategory.imageUrl,
                              productColor: productColor,
                              subcategory: filteredSecondarySubCategories);
                        },
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
  required String productColor,
  required List<SubCategoryModel> subcategory,
}) {
  return Container(
    height: 195,
    width: 154,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: parseColor(productColor),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: subcategory.length,
        itemBuilder: (context, index) {
          final subCategory = subcategory[index];
          return subcategoryItem(
            name: subCategory.name,
            bgcolor: bgcolor,
            textcolor: textcolor,
            imageurl: subCategory.imageUrl,
          );
        },
      ),
      Text(
        name,
        style: TextStyle(
            fontSize: 14,
            color: parseColor(textcolor),
            fontWeight: FontWeight.bold),
      ),
      Text(
        '${subcategory.length} products',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.kgreyColorlite,
        ),
      ),
    ]),
  );
}

Widget subcategoryItem(
    {required String name,
    required String bgcolor,
    required String textcolor,
    required String imageurl}) {
  return Container(
    height: 64,
    width: 70,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: parseColor(bgcolor),
        image:
            DecorationImage(image: NetworkImage(imageurl), fit: BoxFit.fill)),
  );
}
