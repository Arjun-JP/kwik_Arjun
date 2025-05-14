import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/subcategory_product_bloc/subcategory_product_bloc.dart';
import 'package:kwik/bloc/subcategory_product_bloc/subcategory_product_event.dart';
import 'package:kwik/bloc/subcategory_product_bloc/subcategory_product_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product1_grid_Shimnmer.dart';

class SubcategoryProductsPage extends StatefulWidget {
  final String subcategoryid;
  final String subcatname;

  const SubcategoryProductsPage({
    super.key,
    required this.subcategoryid,
    required this.subcatname,
  });

  @override
  State<SubcategoryProductsPage> createState() =>
      _SubcategoryProductsPageState();
}

class _SubcategoryProductsPageState extends State<SubcategoryProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubcategoryProductBlocSubcategory>().add(
        FetchSubcategoryProductsSubcategory(
            subcategoryID: widget.subcategoryid));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<SubcategoryProductBlocSubcategory,
        SubcategoryProductStatesubcategory>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.subcatname),
            backgroundColor: lightenColor(
                parseColor(state is SubcategoryProductLoadedsubcategory
                    ? state.products.first.categoryRef.color
                    : "FFFFFF"),
                .9),
            foregroundColor: lightenColor(
                parseColor(state is SubcategoryProductLoadedsubcategory
                    ? state.products.first.categoryRef.color
                    : "FFFFFF"),
                .9),
            toolbarHeight: 40,
            leading: InkWell(
              onTap: () {
                context.pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push('/searchpage');
                },
                child: SvgPicture.asset(
                  "assets/images/search.svg",
                  fit: BoxFit.contain,
                  width: 30,
                  height: 20,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: SingleChildScrollView(
            // Prevents layout overflow
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  BlocBuilder<SubcategoryProductBlocSubcategory,
                      SubcategoryProductStatesubcategory>(
                    builder: (context, state) {
                      if (state is SubcategoryProductLoadingsubcategory) {
                        return const Center(child: ProductModel1GridShimmer());
                      } else if (state is SubcategoryProductLoadedsubcategory) {
                        if (state.products.isEmpty) {
                          return const Center(
                              child: Text("No products available"));
                        }
                        return StaggeredGrid.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          children: List.generate(
                            state.products.length,
                            (index) => SizedBox(
                              height: 278,
                              child: ProductItem(
                                subcategoryRef: state
                                    .products[index].subCategoryRef.first.id,
                                productnamecolor: "000000",
                                mrpColor: "A19DA3",
                                offertextcolor: "FFFFFF",
                                productBgColor: "FFFFFF",
                                sellingPriceColor: "000000",
                                buttontextcolor: "E23338",
                                buttonBgColor: "FFFFFF",
                                unitTextcolor: "A19DA3",
                                unitbgcolor: "FFFFFF",
                                offerbgcolor: "E3520D",
                                ctx: context,
                                product: state.products[index],
                              ),
                            ),
                          ),
                        );
                      } else if (state is SubcategoryProductErrorsubcategory) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink(); // Avoids layout errors
                    },
                  ),
                  const SizedBox(height: 20),
                  const DescriptiveWidget(
                    title: "Skip the store, we're at your door!",
                    logo: "assets/images/kwiklogo.png",
                    showcategory: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
