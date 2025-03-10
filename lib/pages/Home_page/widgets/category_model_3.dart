import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model_3_repo_home.dart';

class CategoryModel3 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  final List<String> maincategories;
  final List<String> secondarycategories;

  const CategoryModel3(
      {super.key,
      required this.categoryId,
      required this.bgcolor,
      required this.titleColor,
      required this.subcatColor,
      required this.maincategories,
      required this.secondarycategories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => CategoryBlocModel1(
          categoryRepositoryModel1: CategoryRepositoryModel3Home())
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
                var filteredSecondarySubCategories = state.subCategories
                    .where((subCategory) =>
                        secondarycategories.contains(subCategory.id))
                    .toList();
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
                        state.category.name,
                        style: theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: parseColor(titleColor)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    filteredSubCategories.length, (index) {
                                  final subCategory =
                                      filteredSubCategories[index];
                                  return Expanded(
                                    flex: 1,
                                    child: mainsubcategoryItem(
                                      name: subCategory.name,
                                      bgcolor: state.category.color,
                                      textcolor: subcatColor,
                                      imageurl: subCategory.imageUrl,
                                      theme: theme,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    filteredSecondarySubCategories.length,
                                    (index) {
                                  final subCategory =
                                      filteredSecondarySubCategories[index];
                                  return Expanded(
                                    child: subcategoryItem(
                                      name: subCategory.name,
                                      bgcolor: state.category.color,
                                      textcolor: subcatColor,
                                      imageurl: subCategory.imageUrl,
                                      theme: theme,
                                    ),
                                  );
                                }),
                              ),
                            )
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

  Widget mainsubcategoryItem(
      {required String name,
      required String bgcolor,
      required String textcolor,
      required ThemeData theme,
      required String imageurl}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: parseColor(bgcolor),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  height: 98,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: parseColor(bgcolor),
                      image: DecorationImage(
                          image: NetworkImage(imageurl), fit: BoxFit.fill)),
                ),
              ),
            ],
          ),
        ),
        Text(name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600, color: parseColor(textcolor)))
      ],
    );
  }
}

Widget subcategoryItem(
    {required String name,
    required String bgcolor,
    required String textcolor,
    required ThemeData theme,
    required String imageurl}) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: parseColor(bgcolor),
            image: DecorationImage(
                image: NetworkImage(imageurl), fit: BoxFit.fill)),
      ),
      Text(
        name,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600, color: parseColor(textcolor)),
      )
    ],
  );
}
