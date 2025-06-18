import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model_6_repo.dart';
import 'package:kwik/widgets/shimmer/category_model_6_shimmer.dart';
import '../../../bloc/home_page_bloc/category_model_6_bloc/category_model_6_bloc.dart';

class CategoryModel6 extends StatelessWidget {
  final String bgcolor;
  final String titleColor;

  final List<String> subcategories;
  final String title;
  final String catnamecolor;
  final String catnamebgcolor;
  final String offertextcolor;
  final String offerbgcolor;
  final bool showcategory;
  final String outerbordercolor;

  const CategoryModel6({
    super.key,
    required this.bgcolor,
    required this.titleColor,
    required this.subcategories,
    required this.title,
    required this.catnamecolor,
    required this.catnamebgcolor,
    required this.offertextcolor,
    required this.offerbgcolor,
    required this.showcategory,
    required this.outerbordercolor,
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
              return const Center(child: CategoryModel6Shimmer());
            } else if (state is CategoryLoaded) {
              // Filter subcategories by matching their IDs
              var filteredSubCategories = state.subCategories
                  .where(
                    (subCategory) =>
                        subcategories.contains(subCategory.id.toString()),
                  )
                  .toList();

              return showcategory
                  ? Container(
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
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 185,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredSubCategories.length,
                              itemBuilder: (context, index) {
                                var subCategory = filteredSubCategories[index];
                                return subcategoryItem(
                                  context: context,
                                  subcat: subCategory,
                                  outerbordercolor: outerbordercolor,
                                  name: subCategory.name,
                                  offer: subCategory.offerPercentage,
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
                    )
                  : const SizedBox();
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
    required SubCategoryModel subcat,
    required String bgcolor,
    required String offer,
    required BuildContext context,
    required String imageurl,
    required String catnamebgcolor,
    required String offertextcolor,
    required String offerbgcolor,
    required String outerbordercolor,
    required String catnamecolor}) {
  return InkWell(
    onTap: () {
      HapticFeedback.mediumImpact();
      context.push(
        '/subcategory-products?subcategoryid=${subcat.id}&subcatname=${subcat.name}',
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border:
                    Border.all(color: parseColor(outerbordercolor), width: 2)),
            height: 170,
            width: 150,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(3),
                  height: 170,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
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
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                            color: parseColor(offerbgcolor),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Center(
                          child: Text(
                            "$offer % off",
                            style: TextStyle(
                                color: parseColor(offertextcolor),
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      //   child: Container(
                      //     padding: const EdgeInsets.all(5),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadiusDirectional.circular(8),
                      //       color: parseColor(catnamebgcolor),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         name,
                      //         maxLines: 2,
                      //         style: TextStyle(
                      //             fontSize: 13,
                      //             fontWeight: FontWeight.w700,
                      //             color: parseColor(catnamecolor)),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
