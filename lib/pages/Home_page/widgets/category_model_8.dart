import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/category_model_8_bloc/category_model_8_bloc.dart';
import '../../../bloc/category_model_8_bloc/category_model_8_event.dart';
import '../../../bloc/category_model_8_bloc/category_model_8_state.dart';
import '../../../repositories/category_model_8_repo.dart';

class CategoryModel8 extends StatefulWidget {
  final String title;
  final String bgColor;
  final List<String> categories;
  final String titlecolor;
  final String categorytitlecolor;
  final String categoryBG;
  final String iconBGcolor;
  final String iconcolor;
  const CategoryModel8({
    super.key,
    required this.title,
    required this.bgColor,
    required this.categories,
    required this.titlecolor,
    required this.categorytitlecolor,
    required this.categoryBG,
    required this.iconBGcolor,
    required this.iconcolor,
  });

  @override
  State<CategoryModel8> createState() => _CategoryModel8State();
}

class _CategoryModel8State extends State<CategoryModel8> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryModel8Bloc(categoryRepository: Categorymodel8Repository())
            ..add(FetchCategoriesmodel8()),
      child: BlocBuilder<CategoryModel8Bloc, CategoryBloc8State>(
        builder: (context, state) {
          if (state is Categorymode8Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Categorymode8Loaded) {
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
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else if (state is Categorymode8Error) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}

// Function to parse hex color correctly

Color parseColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return const Color(0xFFADD8E6); // Default pastel blue
  }

  hexColor = hexColor.replaceAll("#", ""); // Remove # if present

  // If the input is 6 characters long (RGB), add "FF" for full opacity
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  // If the input is not 8 characters (AARRGGBB), return default pastel color
  else if (hexColor.length != 8) {
    return const Color(0xFFADD8E6);
  }

  try {
    return Color(int.parse("0x$hexColor")); // Ensure correct 0xAARRGGBB format
  } catch (e) {
    return const Color(0xFFADD8E6); // Default pastel blue on error
  }
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
