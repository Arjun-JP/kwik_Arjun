import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kwik/constants/colors.dart';

class CategoryModel17 extends StatelessWidget {
  final String categoryId1;
  final String categoryId2;
  final String categoryId3;
  final String image1;
  final String image2;
  final String image3;
  final String bgcolor;
  final String title;
  final String titleColor;
  final String category;
  final bool showcategory;

  const CategoryModel17({
    super.key,
    required this.categoryId1,
    required this.categoryId2,
    required this.categoryId3,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.bgcolor,
    required this.titleColor,
    required this.showcategory,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? Container(
            color: parseColor(bgcolor),
            width: double.infinity,
            height: 380,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(title,
                    style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: parseColor(titleColor))),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                      height: 295,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 15,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => context.push(
                                  "/allsubcategorypage?categoryId=$category&selectedsubcategory=$categoryId1"),
                              child: subcategoryItem(
                                height: 291,
                                subcatgroryid: categoryId1,
                                imageurl: image1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 15,
                              children: [
                                InkWell(
                                  onTap: () => context.push(
                                      "/allsubcategorypage?categoryId=$category&selectedsubcategory=$categoryId2"),
                                  child: subcategoryItem(
                                    subcatgroryid: categoryId2,
                                    height: 140,
                                    imageurl: image2,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => context.push(
                                      "/allsubcategorypage?categoryId=$category&selectedsubcategory=$categoryId3"),
                                  child: subcategoryItem(
                                    subcatgroryid: categoryId3,
                                    height: 140,
                                    imageurl: image3,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          )
        : const SizedBox();
  }
}

Widget subcategoryItem(
    {required double height,
    required String subcatgroryid,
    required String imageurl}) {
  return SizedBox(
    height: height,
    child: Column(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: parseColor("FFFFFF"),
              image: DecorationImage(
                  image: NetworkImage(imageurl), fit: BoxFit.cover)),
        ),
      ],
    ),
  );
}
