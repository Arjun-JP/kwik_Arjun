import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model2_repository.dart';
import 'package:kwik/widgets/shimmer/categoryModel2_shimmer.dart';

import '../../../bloc/home_page_bloc/category_model_2_bloc/category_model2_bloc.dart';

class CategoryModel2 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  final bool showcategory;
  final String title;

  const CategoryModel2({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.subcatColor,
    required this.showcategory,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (context) => CategoryBlocModel2(
                categoryRepositoryModel2: CategoryRepositoryModel2())
              ..add(FetchCategoryDetails(categoryId)),
            child: Builder(
              builder: (context) {
                return BlocBuilder<CategoryBlocModel2, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: Categorymodel2Shimmer());
                    } else if (state is CategoryLoaded) {
                      final selectedSubCategoryRef = List<String>.from(
                          state.category.selectedSubCategoryRef!);

                      return Container(
                        color: parseColor(bgcolor),
                        width: double.infinity,
                        height: 364,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text(title ?? state.category.name,
                                style: theme.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: parseColor(titleColor))),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 294,
                              width: MediaQuery.of(context).size.width,
                              child: GridView.builder(
                                itemCount: state.subCategories
                                    .where((element) => selectedSubCategoryRef
                                        .contains(element.id))
                                    .toList()
                                    .length,
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.2,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      context.push(
                                          "/allsubcategorypage?categoryId=$categoryId&selectedsubcategory=${state.subCategories[index].id}");
                                    },
                                    child: subcategoryItem(
                                        name: state.subCategories
                                            .where((element) =>
                                                selectedSubCategoryRef
                                                    .contains(element.id))
                                            .toList()[index]
                                            .name,
                                        bgcolor: state.category.color,
                                        textcolor: subcatColor,
                                        imageurl: state.subCategories
                                            .where((element) =>
                                                selectedSubCategoryRef
                                                    .contains(element.id))
                                            .toList()[index]
                                            .imageUrl,
                                        theme: theme),
                                  );
                                },
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
          )
        : const SizedBox();
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
        height: 94,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: lightenColor(parseColor(bgcolor), .9),
            image: DecorationImage(
                image: NetworkImage(imageurl), fit: BoxFit.contain)),
      ),
      const SizedBox(height: 10),
      Text(name,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium!
              .copyWith(color: parseColor(textcolor)))
    ],
  );
}
