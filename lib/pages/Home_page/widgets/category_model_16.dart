import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model2_repository.dart';
import 'package:kwik/widgets/shimmer/category_model_16_shimmer.dart';
import '../../../bloc/home_page_bloc/category_model_16_bloc/category_model_16_bloc.dart';
import '../../../bloc/home_page_bloc/category_model_16_bloc/category_model_16_event.dart';

class CategoryModel16 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String title;
  final String titleColor;
  final List<String> subcategroylist;
  final bool showcategory;
  final String categorybgcolor;
  final String offerbgcolor;
  final String offertext1;
  final String offertext2;
  final String subcattitleColor;

  const CategoryModel16({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.titleColor,
    required this.showcategory,
    required this.title,
    required this.categorybgcolor,
    required this.offerbgcolor,
    required this.offertext1,
    required this.offertext2,
    required this.subcategroylist,
    required this.subcattitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return showcategory
        ? BlocProvider(
            create: (context) => CategoryBlocModel16(
                categoryRepositoryModel2: CategoryRepositoryModel2())
              ..add(FetchCategoryDetails(categoryId)),
            child: Builder(
              builder: (context) {
                return BlocBuilder<CategoryBlocModel16, CategoryModel16State>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CategoryModel16Shimmer());
                    } else if (state is CategoryLoaded) {
                      return Container(
                        color: parseColor(bgcolor),
                        width: double.infinity,
                        height: 403,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text(title ?? state.category.name,
                                style: theme.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: parseColor(titleColor))),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: SizedBox(
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  itemCount: state.subCategories
                                              .where((subcat) => subcategroylist
                                                  .contains(subcat.id))
                                              .length >
                                          6
                                      ? 6
                                      : state.subCategories
                                          .where((subcat) => subcategroylist
                                              .contains(subcat.id))
                                          .length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: .71,
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 30,
                                    crossAxisSpacing: 25,
                                  ),
                                  itemBuilder: (context, index) {
                                    List<SubCategoryModel> filtredsubcat = state
                                        .subCategories
                                        .where((subcat) =>
                                            subcategroylist.contains(subcat.id))
                                        .toList();
                                    return InkWell(
                                      onTap: () => context.push(
                                          "/allsubcategorypage?categoryId=${filtredsubcat[index].categoryRef.catref}&selectedsubcategory=${filtredsubcat[index].id}"),
                                      child: subcategoryItem(
                                          categorybgcolor: categorybgcolor,
                                          offerbgcolor: offerbgcolor,
                                          offertext1: offertext1,
                                          offertext2: offertext2,
                                          name: filtredsubcat[index].name,
                                          offer: filtredsubcat[index]
                                              .offerPercentage,
                                          bgcolor: categorybgcolor,
                                          textcolor: subcattitleColor,
                                          imageurl:
                                              filtredsubcat[index].imageUrl,
                                          theme: theme),
                                    );
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
          )
        : const SizedBox();
  }
}

Widget subcategoryItem(
    {required String name,
    required String bgcolor,
    required String textcolor,
    required String offerbgcolor,
    required String offertext1,
    required String offertext2,
    required String categorybgcolor,
    required ThemeData theme,
    required String offer,
    required String imageurl}) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: 126,
        child: Stack(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: parseColor(bgcolor),
                // image: DecorationImage(
                //     image: NetworkImage(imageurl), fit: BoxFit.fill)
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: parseColor(offerbgcolor),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Upto",
                        style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: parseColor(offertext1)),
                      ),
                      Text(
                        offer,
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: parseColor(offertext2)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 45, left: 5, right: 5),
                child: Text(
                  name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: parseColor(textcolor)),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 2.7),
              child: Image.network(height: 85, imageurl),
            )
          ],
        ),
      ),
    ],
  );
}
