import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_bloc.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_event.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/subcategory_model.dart';

import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';

// ignore: must_be_immutable
class AllSubcategory extends StatefulWidget {
  final String categoryrId;
  String? selectedsubcategory;
  AllSubcategory({
    this.selectedsubcategory,
    super.key,
    required this.categoryrId,
  });

  @override
  State<AllSubcategory> createState() => _AllSubcategoryState();
}

class _AllSubcategoryState extends State<AllSubcategory> {
  @override
  void initState() {
    context.read<AllSubCategoryBloc>().add(LoadSubCategories(
          categoryId: widget.categoryrId,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 40,
            leading: InkWell(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
                size: 23,
              ),
            ),
            actions: [
              SvgPicture.asset(
                "assets/images/search.svg",
                fit: BoxFit.contain,
                width: 30,
                height: 30,
                color: Colors.black,
              ),
              const SizedBox(width: 15)
            ]),
        body: Builder(builder: (context) {
          return BlocBuilder<AllSubCategoryBloc, AllSubCategoryState>(
              builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: ProductModel1ListShimmer());
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            } else if (state is CategoryLoaded) {
              return Column(
                children: [
                  /// Main Row
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Left Column (Scrollable)
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 5,
                              children: List.generate(
                                state.subCategories.length,
                                (index) => subcategoryModel(
                                    categoryID: widget.categoryrId,
                                    selectedsubcategoryID:
                                        state.selectedSubCategory,
                                    subcategory: state.subCategories[index],
                                    theme: theme,
                                    categorycolor: state
                                        .subCategories.first.categoryRef.color),
                              ),
                            ),
                          ),
                        ),

                        /// Right Column (Scrollable)
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.all(10),
                            color: const Color.fromARGB(255, 240, 240, 240),
                            child: StaggeredGrid.count(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: List.generate(
                                state.products
                                    .where((product) => product.subCategoryRef
                                        .any((subcat) =>
                                            subcat.id ==
                                            state.selectedSubCategory))
                                    .length,
                                (index) => ProductItem(
                                    name: "name",
                                    product: state.products
                                        .where((product) => product
                                            .subCategoryRef
                                            .any((subcat) =>
                                                subcat.id ==
                                                state.selectedSubCategory))
                                        .toList()[index],
                                    price: 100,
                                    imageurl:
                                        "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/image%2023.png?alt=media&token=9925215f-e0eb-4a12-8431-281cea504c44",
                                    buttonBgColor: "FFFFFF",
                                    mrpColor: "000000",
                                    offertextcolor: "000000",
                                    productBgColor: "FFFFFF",
                                    productnamecolor: "000000",
                                    sellingPriceColor: "000000",
                                    subcategoryRef:
                                        widget.selectedsubcategory ??
                                            state.products[index].subCategoryRef
                                                .first.id,
                                    unitTextcolor: "000000",
                                    unitbgcolor: "FFFFFF",
                                    buttontextcolor: "000000",
                                    offerbgcolor: "FFFA76",
                                    context: context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No Data Available'));
          });
        }));
  }

  Widget subcategoryModel(
      {required SubCategoryModel subcategory,
      required ThemeData theme,
      required String categoryID,
      required selectedsubcategoryID,
      required String categorycolor}) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<AllSubCategoryBloc>().add(SelectSubCategory(
            subCategoryId: subcategory.id, categoryID: categoryID));

        print(subcategory.id);
        print("selecetedcategory");
        print(selectedsubcategoryID);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 105,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 2, bottom: 5, left: 5, right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    selectedsubcategoryID == subcategory.id
                        ? lightenColor(parseColor(categorycolor), .92)
                        : Colors.white,
                    selectedsubcategoryID == subcategory.id
                        ? lightenColor(parseColor(categorycolor), .9)
                        : Colors.white,
                    selectedsubcategoryID == subcategory.id
                        ? lightenColor(parseColor(categorycolor), .8)
                        : Colors.white,
                    selectedsubcategoryID == subcategory.id
                        ? lightenColor(parseColor(categorycolor), .6)
                        : Colors.white,
                    selectedsubcategoryID == subcategory.id
                        ? lightenColor(parseColor(categorycolor), .5)
                        : Colors.white,
                  ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: [
              Image.network(
                  height: 60,
                  width: 60,
                  fit: BoxFit.fill,
                  subcategory.imageUrl),
              Text(
                subcategory.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              )
            ],
          )),
    );
  }
}
