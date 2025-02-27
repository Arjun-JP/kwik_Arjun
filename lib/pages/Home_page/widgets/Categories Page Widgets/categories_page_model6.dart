import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model_8_repo.dart';

import '../../../../bloc/Categories Page Bloc/categories_page_model6/categories_page_model6_bloc.dart';

class CategoriesPageModel6 extends StatefulWidget {
  final String title;
  final String bgColor;
  final List<String> categories;
  final String titlecolor;
  final String categorytitlecolor;
  final String categoryBG;
  final String iconBGcolor;
  final String iconcolor;
  final String seeAllButtonBG;
  final String seeAllButtontext;

  const CategoriesPageModel6(
      {super.key,
      required this.title,
      required this.bgColor,
      required this.categories,
      required this.titlecolor,
      required this.categorytitlecolor,
      required this.categoryBG,
      required this.iconBGcolor,
      required this.iconcolor,
      required this.seeAllButtonBG,
      required this.seeAllButtontext});

  @override
  State<CategoriesPageModel6> createState() => _CategoriesPageModel6State();
}

class _CategoriesPageModel6State extends State<CategoriesPageModel6> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesPageModel6Bloc(
          categoryRepository: Categorymodel8Repository())
        ..add(FetchCategoriesmodel8()),
      child: BlocBuilder<CategoriesPageModel6Bloc, CategoriesPageModel6State>(
        builder: (context, state) {
          if (state is CategoriesPageModel6Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriesPageModel6Loaded) {
            print(state.categories.length);
            return Container(
              color: parseColor(widget.bgColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 7),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: parseColor(widget.titlecolor),
                          fontSize: 24,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: state.categories.map((category) {
                        if (widget.categories.contains(category.id)) {
                          return Expanded(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Stack(
                                    clipBehavior: Clip
                                        .none, // Allows elements to overflow the container
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          color: parseColor(widget.categoryBG),
                                        ),
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 110,
                                              decoration: BoxDecoration(
                                                color: parseColor(
                                                    widget.categoryBG),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      category.imageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8, left: 8, right: 8),
                                              child: Text(
                                                category.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: parseColor(widget
                                                      .categorytitlecolor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Positioning the Icon at Bottom-Right and Half Outside
                                      Positioned(
                                        bottom:
                                            -8, // Move it downwards by half of its size (30px / 2)
                                        right:
                                            -5, // Slightly move it outside the right boundary
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color:
                                                parseColor(widget.iconBGcolor),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                spreadRadius: 2,
                                                // ignore: prefer_const_constructors
                                                offset: Offset(2,
                                                    2), // Adds depth to floating icon
                                              )
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: parseColor(widget.iconcolor),
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: parseColor(widget.seeAllButtonBG)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('See all products',
                                  style: TextStyle(
                                      color:
                                          parseColor(widget.seeAllButtontext),
                                      fontSize: 18)),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 14.0),
                                child: Icon(Icons.arrow_forward),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (state is CategoriesPageModel6Error) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
