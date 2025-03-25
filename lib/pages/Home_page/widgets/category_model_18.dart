import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_18_bloc/category_model_18_state.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model_18.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
import '../../../bloc/home_page_bloc/category_model_18_bloc/category_model_18_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_18_bloc/category_model_18_event.dart';
import '../../../constants/colors.dart';

class CategoryModel18 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final List<String> maincategories;
  final String offerBGcolor;
  final String offertextcolor1;
  final String offertextcolor2;
  final String categoryBgColor;
  final bool showcategory;
  final String bannerimageurl;
  final String categorytitlecolor;
  final String seeallbuttontextcolor;
  final String seeallbuttonbgcolor;

  const CategoryModel18({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.maincategories,
    required this.offerBGcolor,
    required this.offertextcolor1,
    required this.offertextcolor2,
    required this.categoryBgColor,
    required this.showcategory,
    required this.bannerimageurl,
    required this.categorytitlecolor,
    required this.seeallbuttontextcolor,
    required this.seeallbuttonbgcolor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (_) =>
                CategoryBloc18(categoryRepository: Categorymodel18Repository())
                  ..add(FetchCategoryAndProductsEvent(
                    categoryId: categoryId,
                    subCategoryIds:
                        maincategories, // Dispatch event to fetch category and products
                  )),
            child: Container(
              color: parseColor(bgcolor),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      bannerimageurl),
                  const SizedBox(height: 10),
                  BlocBuilder<CategoryBloc18, CategoryModel18State>(
                    builder: (context, state) {
                      if (state is SubCategoriesLoading) {
                        return const Center(child: ProductModel1ListShimmer());
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is CategoryLoadedState) {
                        print(state.subCategories.length);
                        return Column(
                          children: [
                            state.subCategories.isNotEmpty
                                ? SizedBox(
                                    height: 182,
                                    width: MediaQuery.of(context).size.width,
                                    child: StaggeredGrid.count(
                                      crossAxisCount: 3,
                                      children: List.generate(3, (index) {
                                        List<SubCategoryModel> filtredsubcat =
                                            state.subCategories
                                                .where(
                                                  (element) => maincategories
                                                      .contains(element.id),
                                                )
                                                .toList();
                                        return subcategoryItem(
                                          categorybgcolor: categoryBgColor,
                                          offerbgcolor: offerBGcolor,
                                          offertext1: offertextcolor1,
                                          offertext2: offertextcolor2,
                                          name: state.subCategories[index].name,
                                          textcolor: categorytitlecolor,
                                          imageurl: state.subCategories.length
                                              .toString(),
                                          theme: theme,
                                        );
                                      }),
                                    ))
                                : Container(
                                    color: Colors.black,
                                    height: 50,
                                    width: 200,
                                  ),
                            const SizedBox(height: 10),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: parseColor(seeallbuttonbgcolor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('See all products',
                                          style: TextStyle(
                                              color: parseColor(
                                                  seeallbuttontextcolor),
                                              fontSize: 18)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 14.0),
                                        child: Icon(Icons.arrow_forward,
                                            color: parseColor(
                                                seeallbuttontextcolor)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(child: Text('No Data Available'));
                    },
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

Widget subcategoryItem(
    {required String name,
    required String textcolor,
    required String offerbgcolor,
    required String offertext1,
    required String offertext2,
    required String categorybgcolor,
    required ThemeData theme,
    required String imageurl}) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: parseColor(offerbgcolor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: parseColor(offerbgcolor),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Upto",
                        style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: parseColor(offertext1)),
                      ),
                      Text(
                        "85% OFF",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 16, color: parseColor(offertext2)),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: parseColor(categorybgcolor),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 5,
                  children: [
                    const SizedBox(height: 5),
                    Image.network(
                        height: 85,
                        "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/33571-5-plush-toy-image.png?alt=media&token=25835858-a69b-4ebb-8df0-76548d6c1b7d"),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4, bottom: 10),
                      child: Text(
                        name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: parseColor(textcolor)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
