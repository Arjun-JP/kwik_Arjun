import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_bloc.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_state.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model1_repository.dart';
import 'package:kwik/widgets/shimmer/category_shimmer.dart';

class CategoryModel extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  final List<String> maincategories;
  final List<String> secondarycategories;
  final bool showcategory;

  const CategoryModel(
      {super.key,
      required this.categoryId,
      required this.bgcolor,
      required this.titleColor,
      required this.subcatColor,
      required this.maincategories,
      required this.showcategory,
      required this.secondarycategories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (context) => CategoryBlocModel(
                categoryRepositoryModel1: CategoryRepositoryModel1())
              ..add(FetchCategoryDetails()),
            child: Builder(
              builder: (context) {
                return BlocBuilder<CategoryBlocModel, CategoryModelState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CategoryShimmer());
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
                              state.category
                                  .firstWhere(
                                    (category) => category.catref == categoryId,
                                    // Provide a default category
                                  )
                                  .name,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          filteredSubCategories.length,
                                          (index) {
                                        final subCategory =
                                            filteredSubCategories[index];
                                        return Expanded(
                                          flex: 1,
                                          child: mainsubcategoryItem(
                                            name: subCategory.name,
                                            bgcolor: state.category
                                                .firstWhere((category) =>
                                                    category.catref ==
                                                    categoryId)
                                                .color,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          filteredSecondarySubCategories.length,
                                          (index) {
                                        final subCategory =
                                            filteredSecondarySubCategories[
                                                index];
                                        return Expanded(
                                          child: subcategoryItem(
                                            name: subCategory.name,
                                            bgcolor: state.category
                                                .firstWhere((category) =>
                                                    category.catref ==
                                                    categoryId)
                                                .color,
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
          )
        : const SizedBox();
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
              color: lightenColor(parseColor(bgcolor), .9),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  height: 75,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: lightenColor(parseColor(bgcolor), .9),
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
        width: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: lightenColor(parseColor(bgcolor), .9),
            image: DecorationImage(
                image: NetworkImage(imageurl), fit: BoxFit.fill)),
      ),
      const SizedBox(height: 8),
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
