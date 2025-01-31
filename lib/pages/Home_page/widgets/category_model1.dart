import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_event.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model1_repository.dart';

class CategoryModel1 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;

  const CategoryModel1(
      {super.key,
      required this.categoryId,
      required this.bgcolor,
      required this.titleColor,
      required this.subcatColor});

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
                return Container(
                  color: parseColor(bgcolor),
                  width: double.infinity,
                  height: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        state.category.name, // Display main category name
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
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
                      )
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

  Widget subcategoryItem(
      {required String name,
      required String bgcolor,
      required String textcolor,
      required String imageurl}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 98,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: parseColor(bgcolor),
              image: DecorationImage(
                  image: NetworkImage(imageurl), fit: BoxFit.fill)),
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: parseColor(textcolor)),
        )
      ],
    );
  }
}
