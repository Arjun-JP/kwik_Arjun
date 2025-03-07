import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

import '../../../bloc/home_page_bloc/category_model_16_bloc/category_model_16_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_16_bloc/category_model_16_event.dart';

class CategoryModel16 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String titleColor;
  final String subcatColor;

  const CategoryModel16({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.subcatColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => CategoryBlocModel16(
          categoryRepositoryModel2: CategoryRepositoryModel2())
        ..add(FetchCategoryDetails(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoryBlocModel16, CategoryModel16State>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                return Container(
                  color: parseColor("FFF3C4"),
                  width: double.infinity,
                  height: 410,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(state.category.name,
                          style: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: parseColor(titleColor))),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SizedBox(
                          height: 340,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                            itemCount: state.subCategories.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .71,
                              crossAxisCount: 3,
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 25,
                            ),
                            itemBuilder: (context, index) {
                              return subcategoryItem(
                                  name: state.subCategories[index].name,
                                  bgcolor: state.category.color,
                                  textcolor: subcatColor,
                                  imageurl: state.subCategories[index].imageUrl,
                                  theme: theme);
                            },
                          ),
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
      SizedBox(
        height: 146,
        child: Stack(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: parseColor("FFFFFF"),
                // image: DecorationImage(
                //     image: NetworkImage(imageurl), fit: BoxFit.fill)
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: parseColor('FFD62C'),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Upto",
                        style: theme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "85% OFF",
                        style:
                            theme.textTheme.bodyMedium!.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Text(
                  "Toys",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 1.6),
              child: Image.network(
                  height: 85,
                  "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/33571-5-plush-toy-image.png?alt=media&token=25835858-a69b-4ebb-8df0-76548d6c1b7d"),
            )
          ],
        ),
      ),
    ],
  );
}
