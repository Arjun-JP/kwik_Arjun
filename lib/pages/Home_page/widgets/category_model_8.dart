import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/category_model_6_bloc/category_model_6_event.dart';
import 'package:kwik/bloc/category_model_6_bloc/category_model_6_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model_6_repo.dart';
import '../../../bloc/category_model_6_bloc/category_model_6_bloc.dart';

class CategoryModel7 extends StatelessWidget {
  final String bgcolor;
  final String titleColor;

  final List<String> subcategories;
  final String title;
  final String catnamecolor;
  final String catnamebgcolor;
  final String offertextcolor;
  final String offerbgcolor;

  const CategoryModel7({
    super.key,
    required this.bgcolor,
    required this.titleColor,
    required this.subcategories,
    required this.title,
    required this.catnamecolor,
    required this.catnamebgcolor,
    required this.offertextcolor,
    required this.offerbgcolor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            CategoryBlocModel6(categoryModel6Repo: CategoryModel6Repo())
              ..add(FetchCategoryDetails()),
        child: BlocBuilder<CategoryBlocModel6, CategoryState6>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              // Filter subcategories by matching their IDs
              var filteredSubCategories = state.subCategories
                  .where(
                    (subCategory) =>
                        subcategories.contains(subCategory.id.toString()),
                  )
                  .toList();

              return Container(
                color: parseColor(bgcolor),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      title,
                      style: TextStyle(
                        color: parseColor(titleColor),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredSubCategories.length,
                        itemBuilder: (context, index) {
                          var subCategory = filteredSubCategories[index];
                          return subcategoryItem(
                            name: subCategory.name,
                            bgcolor: bgcolor,
                            imageurl: subCategory.imageUrl,
                            catnamecolor: catnamecolor,
                            catnamebgcolor: catnamebgcolor,
                            offerbgcolor: offerbgcolor,
                            offertextcolor: offertextcolor,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ));
  }
}

Widget subcategoryItem(
    {required String name,
    required String bgcolor,
    required String imageurl,
    required String catnamebgcolor,
    required String offertextcolor,
    required String offerbgcolor,
    required String catnamecolor}) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: SizedBox(
          height: 170,
          width: 150,
          child: Stack(
            children: [
              Container(
                height: 170,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80)),
                  color: parseColor(bgcolor),
                  image: DecorationImage(
                    image: NetworkImage(imageurl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: parseColor(offerbgcolor),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          "17% off",
                          style: TextStyle(
                              color: parseColor(offertextcolor),
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(8),
                          color: parseColor(catnamebgcolor),
                        ),
                        child: Center(
                          child: Text(
                            name,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: parseColor(catnamecolor)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
