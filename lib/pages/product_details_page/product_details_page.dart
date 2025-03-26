import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/product_details_page/product_details_bloc/product_details_page_bloc.dart';
import 'package:kwik/bloc/product_details_page/product_details_bloc/product_details_page_event.dart';
import 'package:kwik/bloc/product_details_page/product_details_bloc/product_details_page_state.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_bloc.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_event.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_products_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/constants.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/variation_model.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

import 'package:kwik/widgets/produc_model_1.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final String subcategoryref;

  const ProductDetailsPage(
      {super.key, required this.product, required this.subcategoryref});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.product.variations.isNotEmpty) {
      context
          .read<VariationBloc>()
          .add(SelectVariationEvent(widget.product.variations.first));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          SubcategoryProductBloc(SubcategoryProductRepository())
            ..add(FetchSubcategoryProducts(widget.subcategoryref)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColorWhite,
        // appBar: AppBar(
        //   toolbarHeight: 10,
        //   foregroundColor: Colors.transparent,
        //   backgroundColor: Colors.transparent,
        // ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<VariationBloc, VariationState>(
                      builder: (context, state) {
                        if (state is VariationSelected) {
                          print(state.selectedVariation.id);
                          print("object");
                          return productdetails(
                            theme: theme,
                            product: widget.product,
                            selectedvariation: state.selectedVariation,
                          );
                        } else {
                          return const SizedBox(); // Return an empty widget if no variation is selected
                        }
                      },
                    ),
                    BlocBuilder<SubcategoryProductBloc,
                        SubcategoryProductState>(builder: (context, state) {
                      if (state is SubcategoryProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SubcategoryProductLoaded) {
                        return similerproducts(
                            theme: theme,
                            productList: state.products
                                .where((element) =>
                                    element.id != widget.product.id)
                                .toList());
                      } else if (state is SubcategoryProductError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(child: Text("No products found"));
                      }
                    }),
                    productsYouMightAlsoLike(theme: theme),
                  ],
                ),
              ),
            ),
            addtocartContainer(theme: theme),
          ],
        ),
      ),
    );
  }

  Widget productdetails(
      {required ThemeData theme,
      required ProductModel product,
      required VariationModel selectedvariation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: SizedBox(
                  height: 433,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: widget.product.productImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.product.productImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.kblackColor),
                  onPressed: () => context.pop(),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon:
                        const Icon(Icons.search, color: AppColors.kblackColor),
                    onPressed: () {},
                  ),
                ),
              ),
              Positioned.fill(
                bottom: -10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Expanded(
                    child: Container(
                      height: 25,
                      width: (product.productImages.length * 50) / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.kwhiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.productImages.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == index ? 8 : 6,
                            height: _currentIndex == index ? 8 : 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? AppColors.dotColorSelected
                                  : AppColors.dotColorUnSelected,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(product.productName, style: theme.textTheme.titleMedium),
          product.variations.length > 1
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        product.variations.length,
                        (index) => InkWell(
                          onTap: () {
                            context.read<VariationBloc>().add(
                                SelectVariationEvent(
                                    product.variations[index]));
                            print(product.variations[index].id);
                            print(product.variations[index].info.length);
                          },
                          child: variationItem(
                              theme: theme,
                              variation: product.variations[index],
                              selectedvariationid: selectedvariation.id),
                        ),
                      ),
                    ),
                  ),
                )
              : Text("${product.variations.first.qty} "
                  "${product.variations.first.unit}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              product.variations.length == 1
                  ? Text("₹" "${product.variations.first.sellingPrice} ",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))
                  : const SizedBox(),
              product.variations.length == 1
                  ? Text("₹" "${product.variations.first.mrp} ",
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.kgreyColorlite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorDimGrey))
                  : const SizedBox(),
              product.variations.length == 1
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.korangeColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "${percentage(product.variations.first.mrp, product.variations.first.sellingPrice)}"
                        " OFF",
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textColorWhite,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                collapsedIconColor: const Color(0xFF0d821f),
                iconColor: const Color(0xFF0d821f),
                collapsedBackgroundColor: AppColors.kwhiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  "View product details",
                  style: TextStyle(
                      color: Color.fromARGB(255, 16, 160, 38),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                children: [
                  Column(
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          // iconColor: const Color(0xFF0d821f),
                          backgroundColor: AppColors.kwhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          collapsedBackgroundColor: AppColors.kwhiteColor,
                          initiallyExpanded: true,
                          tilePadding: EdgeInsets.zero,
                          title: const Text(
                            "Highlights",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColorWhite,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  selectedvariation.highlight.length,
                                  (index) {
                                    final MapEntry<String, dynamic> entry =
                                        selectedvariation
                                            .highlight[index].entries.first;

                                    return highlightContent(
                                        entry.key, entry.value.toString());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          backgroundColor: AppColors.kwhiteColor,
                          collapsedBackgroundColor: AppColors.kwhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tilePadding: EdgeInsets.zero,
                          initiallyExpanded: true,
                          title: const Text(
                            "Information",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: AppColors.backgroundColorWhite,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    selectedvariation.info.length,
                                    (index) {
                                      final MapEntry<String, dynamic> entry =
                                          selectedvariation
                                              .info[index].entries.first;

                                      return highlightContent(
                                          entry.key, entry.value.toString());
                                    },
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget similerproducts(
      {required ThemeData theme, required List<ProductModel> productList}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.kwhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            "Similar Products",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(
            height: 270,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ProductItem(
                        subcategoryRef: widget.subcategoryref,
                        productnamecolor: "000000",
                        name: widget.product.productName,
                        price: 200,
                        imageurl: widget.product.productImages[0],
                        mrpColor: "000000",
                        offertextcolor: "000000",
                        productBgColor: "FFFFFF",
                        sellingPriceColor: "000000",
                        buttontextcolor: "000000",
                        buttonBgColor: "FFFFFF",
                        unitTextcolor: "000000",
                        unitbgcolor: "FFFFFF",
                        offerbgcolor: "FFFFFF",
                        context: context,
                        product: productList[index]),
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: productList.length > 10 ? 10 : productList.length),
          ),
        ],
      ),
    );
  }

  Widget productsYouMightAlsoLike({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.kwhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          const SizedBox(height: 15),
          Text("You might also like", style: theme.textTheme.titleMedium),
          SizedBox(
            height: 280,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ProductItem(
                        subcategoryRef: widget.subcategoryref,
                        productnamecolor: "000000",
                        name: widget.product.productName,
                        price: 200,
                        imageurl: widget.product.productImages[0],
                        mrpColor: "000000",
                        offertextcolor: "000000",
                        productBgColor: "FFFFFF",
                        sellingPriceColor: "000000",
                        buttontextcolor: "000000",
                        buttonBgColor: "FFFFFF",
                        unitTextcolor: "000000",
                        unitbgcolor: "FFFFFF",
                        offerbgcolor: "FFFFFF",
                        context: context,
                        product: widget.product),
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: 3),
          ),
        ],
      ),
    );
  }

  Widget addtocartContainer({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.kwhiteColor,
        border: Border(
          top: BorderSide(
            color: AppColors.buttonColorOrange, // Border color
            width: .3, // Border width
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              spacing: 0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "1 pack (160g - 180g)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Row(
                  spacing: 5,
                  children: [
                    const Text("₹66",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const Text("MRP ₹160",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.kgreyColorlite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColorDimGrey)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.korangeColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "15% OFF",
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textColorWhite,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Inclusive of all taxes",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textColorDimGrey,
                  ),
                ),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Set border radius here
                  ),
                  backgroundColor: AppColors.addToCartBorder,
                  minimumSize: const Size(152, 48),
                ),
                child: const Text("Add to Cart",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget highlightContent(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textColorDimGrey),
          ),
        ),
      ],
    ),
  );
}

Widget variationItem(
    {required ThemeData theme,
    required VariationModel variation,
    required String selectedvariationid}) {
  return Container(
    width: 120,
    height: 98,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            width: 2.2,
            color: variation.id == selectedvariationid
                ? const Color.fromARGB(255, 6, 115, 0)
                : const Color.fromARGB(255, 220, 220, 220)),
        gradient: const LinearGradient(colors: [
          Color(0xFFEF6E35),
          Color(0xFFEF6E35),
          Color(0xFFEF6E35),
          Color(0xFFFFFFFF)
        ])),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 2),
          child: Text(
            "${percentage(variation.mrp, variation.sellingPrice)}" "%  OFF",
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        Container(
          width: 120,
          height: 70,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${variation.qty}" "${variation.unit}",
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                "₹" "${variation.sellingPrice}",
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                "MRP ₹" " ${variation.mrp}",
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
