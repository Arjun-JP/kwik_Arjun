import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_event.dart';

import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_2.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

import '../../../bloc/Categories Page Bloc/categories_page_model1/categories_page_model1_bloc.dart';

class CategoriesPageModel1 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;
  const CategoriesPageModel1({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.subcatColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesPageModel1Bloc(
          categoryRepositoryModel2: CategoryRepositoryModel2())
        ..add(FetchCategoryDetailsModel1(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoriesPageModel1Bloc,
              CategoriesPageModel1State>(
            builder: (context, state) {
              if (state is CategoriesPageModel1Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesPageModel1Loaded) {
                return Container(
                  color: parseColor(bgcolor),
                  width: double.infinity,
                  height: 360,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        state.category.name, // Display main category name
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
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
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            return subcategoryItem(
                                name: state.subCategories[index].name,
                                bgcolor: state.category.color,
                                textcolor: subcatColor,
                                imageurl: state.subCategories[index].imageUrl);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              } else if (state is CategoriesPageModel1Error) {
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
