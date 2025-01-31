import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/category_bloc/category_bloc.dart';
import '../../../bloc/category_bloc/category_event.dart';
import '../../../bloc/category_bloc/category_state.dart';
import '../../../repositories/home_category_repository.dart';

class CategoryTab extends StatefulWidget {
  final String bgColor;
  final List<String> categories;
  final String titlecolor;
  final String textcolor;
  const CategoryTab(
      {super.key,
      required this.bgColor,
      required this.categories,
      required this.titlecolor,
      required this.textcolor});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryBloc(categoryRepository: CategoryRepository())
            ..add(FetchCategories()),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return Container(
              color: parseColor(widget.bgColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top Categories For You",
                      style: TextStyle(
                          color: parseColor(widget.titlecolor),
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.categories.map((category) {
                          if (widget.categories.contains(category.catref)) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 10),
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: parseColor(category.color),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  category.imageUrl),
                                              fit: BoxFit.cover)),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      category.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: parseColor(widget.textcolor)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CategoryError) {
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
