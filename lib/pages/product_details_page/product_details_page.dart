import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart'
    show CartState, CartUpdated;
import 'package:kwik/bloc/product_details_page/product_details_bloc/product_details_page_bloc.dart';
import 'package:kwik/bloc/product_details_page/product_details_bloc/product_details_page_event.dart';
import 'package:kwik/bloc/product_details_page/product_details_bloc/product_details_page_state.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_event.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_state.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_bloc.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_event.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_products_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/constants.dart';
import 'package:kwik/models/brand_model.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/variation_model.dart';
import 'package:kwik/repositories/recommended_product_repo.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final String subcategoryref;
  final Color buttonbg;
  final Color buttontext;

  const ProductDetailsPage(
      {super.key,
      required this.product,
      required this.subcategoryref,
      required this.buttonbg,
      required this.buttontext});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  VideoPlayerController? _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;

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
    final user = FirebaseAuth.instance.currentUser;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SubcategoryProductBloc(SubcategoryProductRepository())
                ..add(FetchSubcategoryProducts(widget.subcategoryref)),
        ),
        BlocProvider(
          create: (context) => RecommendedProductsBloc(RecommendedProductRepo())
            ..add(FetchRecommendedProducts(
                widget.product.subCategoryRef.first.id)),
        )
      ],
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          toolbarHeight: 40,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: AppColors.kblackColor),
            onPressed: () => context.pop(),
          ),
          actions: [
            InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push('/searchpage');
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: SvgPicture.asset(
                    "assets/images/search_icon.svg",
                    height: 25,
                    width: 25,
                  ),
                ))
          ],
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .78,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<VariationBloc, VariationState>(
                      builder: (context, state) {
                        if (state is VariationSelected) {
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
                    samebrandproducts(
                        ctx: context,
                        brand: widget.product.brandId,
                        theme: theme),
                    const SizedBox(height: 15),
                    BlocBuilder<SubcategoryProductBloc,
                        SubcategoryProductState>(builder: (context, state) {
                      if (state is SubcategoryProductLoading) {
                        return const Center(child: ProductModel1ListShimmer());
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
                        return const Center(child: Text(""));
                      }
                    }),
                    BlocBuilder<RecommendedProductsBloc,
                        RecommendedProductsState>(builder: (context, state) {
                      if (state is RecommendedProductInitial) {
                        context.read<RecommendedProductsBloc>().add(
                            FetchRecommendedProducts(
                                widget.product.subCategoryRef.first.id));
                      } else if (state is RecommendedProductLoading) {
                        return const Center(child: ProductModel1ListShimmer());
                      } else if (state is RecommendedProductLoaded) {
                        print(state.products.length);
                        return productsYouMightAlsoLike(
                            theme: theme, productlist: state.products);
                      } else if (state is RecommendedProductError) {
                        return const Center(child: Text(""));
                      } else {
                        return const Center(child: Text(""));
                      }
                      return const Center(child: Text(""));
                    }),
                  ],
                ),
              ),
            ),
            BlocBuilder<VariationBloc, VariationState>(
              builder: (context, state) {
                if (state is VariationSelected) {
                  return addtocartContainer(
                      user: user,
                      theme: theme,
                      selecedvariation: state.selectedVariation,
                      product: widget.product);
                } else {
                  return const SizedBox(); // Return an empty widget if no variation is selected
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget productdetails(
      {required ThemeData theme,
      required ProductModel product,
      required VariationModel selectedvariation}) {
    final filtredvariations = product.variations
        .where((element) => element.stock.isNotEmpty)
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // SizedBox(
              //   height: 433,
              //   child: PageView.builder(
              //     controller: _pageController,
              //     onPageChanged: (index) {
              //       setState(() {
              //         _currentIndex = index;
              //       });
              //     },
              //     itemCount: widget.product.productImages.length,
              //     itemBuilder: (context, index) {
              //       return ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: InkWell(
              //           onTap: () {},
              //           child: Image.network(
              //             widget.product.productImages[index],
              //             fit: BoxFit.contain,
              //             width: double.infinity,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width,
                child: ProductImageSlider(
                  product: widget.product,
                ),
              ),
              // Positioned.fill(
              //   bottom: -10,
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Container(
              //       height: 25,
              //       width: (product.productImages.length * 50) / 3,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           color: AppColors.kwhiteColor),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: List.generate(
              //           product.productImages.length,
              //           (index) => Container(
              //             margin: const EdgeInsets.symmetric(horizontal: 4),
              //             width: _currentIndex == index ? 8 : 6,
              //             height: _currentIndex == index ? 8 : 6,
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: _currentIndex == index
              //                   ? AppColors.dotColorSelected
              //                   : AppColors.dotColorUnSelected,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                Text(product.productName, style: theme.textTheme.titleMedium),
          ),
          filtredvariations.length > 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          filtredvariations.length,
                          (index) => InkWell(
                            onTap: () {
                              context.read<VariationBloc>().add(
                                  SelectVariationEvent(
                                      filtredvariations[index]));
                            },
                            child: variationItem(
                                theme: theme,
                                variation: filtredvariations[index],
                                selectedvariationid: selectedvariation.id),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("${filtredvariations.first.qty} "
                      "${filtredvariations.first.unit}"),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                filtredvariations.length == 1
                    ? Text("₹" "${filtredvariations.first.sellingPrice} ",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                    : const SizedBox(),
                filtredvariations.length == 1
                    ? Text("₹" "${filtredvariations.first.mrp} ",
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.kgreyColorlite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColorDimGrey))
                    : const SizedBox(),
                filtredvariations.length == 1
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.korangeColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "${percentage(filtredvariations.first.mrp, filtredvariations.first.sellingPrice)}"
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
                tilePadding: const EdgeInsets.symmetric(horizontal: 10),
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
                          title: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Highlights",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          children: [
                            selectedvariation.highlight.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundColorWhite,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        selectedvariation.highlight.length,
                                        (index) {
                                          final MapEntry<String, dynamic>
                                              entry = selectedvariation
                                                  .highlight[index]
                                                  .entries
                                                  .first;

                                          return highlightContent(entry.key,
                                              entry.value.toString());
                                        },
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: SizedBox(
                                      child: Text("No information added"),
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
                          title: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Information",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          children: [
                            selectedvariation.info.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundColorWhite,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        selectedvariation.info.length,
                                        (index) {
                                          final MapEntry<String, dynamic>
                                              entry = selectedvariation
                                                  .info[index].entries.first;

                                          return highlightContent(entry.key,
                                              entry.value.toString());
                                        },
                                      ),
                                    ))
                                : const Center(
                                    child: SizedBox(
                                      child: Text("No information added"),
                                    ),
                                  ),
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
            height: 279,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ProductItem(
                        subcategoryRef: widget.subcategoryref,
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

  Widget addtocartContainer(
      {required ThemeData theme,
      required User? user,
      required VariationModel selecedvariation,
      required ProductModel product}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 15,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              spacing: 0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.variations.length > 1
                      ? "${selecedvariation.qty} ${selecedvariation.unit}"
                      : "${product.variations.first.qty} ${product.variations.first.unit}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                        product.variations.length > 1
                            ? "₹${selecedvariation.sellingPrice.toStringAsFixed(1)}"
                            : "₹${product.variations.first.sellingPrice.toStringAsFixed(1)}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(
                        "MRP ₹${product.variations.length > 1 ? selecedvariation.mrp.toStringAsFixed(1) : product.variations.first.mrp.toStringAsFixed(1)}",
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.kgreyColorlite,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColorDimGrey)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.korangeColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "${percentage(product.variations.length > 1 ? selecedvariation.mrp : product.variations.first.mrp, product.variations.length > 1 ? selecedvariation.sellingPrice : product.variations.first.sellingPrice)} % OFF",
                        style: const TextStyle(
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
            flex: 4,
            child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, warstate) {
              if (warstate is LocationSearchResults) {
                return SizedBox(
                  height: 40,
                  child: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                    List<CartProduct> cartItems = [];

                    if (state is CartUpdated) {
                      cartItems = state.cartItems;
                    }
                    return cartItems.any((element) =>
                            element.productRef.id == product.id &&
                            element.variant.id == selecedvariation.id)
                        ? quantitycontrolbutton(
                            user: user,
                            pincode: warstate.pincode!,
                            buttontextcolor: widget.buttontext,
                            buttonbgcolor: widget.buttonbg,
                            variationID: selecedvariation.id,
                            theme: theme,
                            product: product,
                            ctx: context,
                            qty: cartItems
                                .firstWhere((element) =>
                                    element.productRef.id == product.id &&
                                    element.variant.id == selecedvariation.id)
                                .quantity
                                .toString(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              if (selecedvariation.stock
                                      .where((element) =>
                                          element.warehouseRef ==
                                          warstate.warehouse!.id)
                                      .isEmpty &&
                                  selecedvariation.stock
                                          .where(
                                            (element) =>
                                                element.warehouseRef ==
                                                warstate.warehouse!.id,
                                          )
                                          .first
                                          .stockQty ==
                                      0) {
                                HapticFeedback.heavyImpact();
                              } else {
                                context.read<CartBloc>().add(
                                      AddToCart(
                                        cartProduct: CartProduct(
                                          productRef: product,
                                          variant: selecedvariation,
                                          quantity: 1,
                                          pincode: warstate.pincode!,
                                          sellingPrice:
                                              selecedvariation.sellingPrice,
                                          mrp: selecedvariation.mrp,
                                          buyingPrice:
                                              selecedvariation.buyingPrice,
                                          inStock: true,
                                          variationVisibility: true,
                                          finalPrice: 0,
                                          cartAddedDate: DateTime.now(),
                                        ),
                                        userId: user!.uid,
                                        productRef: product.id,
                                        variantId: selecedvariation.id,
                                        pincode: warstate.pincode!,
                                      ),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Set border radius here
                              ),
                              side: BorderSide(
                                  color: widget.buttontext, width: .8),
                              backgroundColor: widget.buttonbg,
                              minimumSize: const Size(152, 48),
                            ),
                            child: Text(
                                selecedvariation.stock
                                            .where((element) =>
                                                element.warehouseRef ==
                                                warstate.warehouse!.id)
                                            .isEmpty ||
                                        selecedvariation.stock
                                                .where((element) =>
                                                    element.warehouseRef ==
                                                    warstate.warehouse!.id)
                                                .first
                                                .stockQty ==
                                            0
                                    ? "No Stock"
                                    : "Add ",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: widget.buttontext,
                                    fontWeight: FontWeight.w700)),
                          );
                  }),
                );
              } else {
                return const SizedBox();
              }
            }),
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
  return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
    if (state is LocationSearchResults) {
      return Opacity(
        opacity: variation.stock
                    .where((element) =>
                        element.warehouseRef == state.warehouse!.id)
                    .isNotEmpty &&
                variation.stock
                        .where((element) =>
                            element.warehouseRef == state.warehouse!.id)
                        .first
                        .stockQty !=
                    0
            ? 1
            : .5,
        child: Container(
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
              gradient: LinearGradient(colors: [
                variation.stock
                            .where((element) =>
                                element.warehouseRef == state.warehouse!.id)
                            .isNotEmpty &&
                        variation.stock
                                .where((element) =>
                                    element.warehouseRef == state.warehouse!.id)
                                .first
                                .stockQty !=
                            0
                    ? const Color(0xFFEF6E35)
                    : Colors.grey,
                variation.stock
                            .where((element) =>
                                element.warehouseRef == state.warehouse!.id)
                            .isNotEmpty &&
                        variation.stock
                                .where((element) =>
                                    element.warehouseRef == state.warehouse!.id)
                                .first
                                .stockQty !=
                            0
                    ? const Color(0xFFEF6E35)
                    : Colors.grey,
                variation.stock
                            .where((element) =>
                                element.warehouseRef == state.warehouse!.id)
                            .isNotEmpty &&
                        variation.stock
                                .where((element) =>
                                    element.warehouseRef == state.warehouse!.id)
                                .first
                                .stockQty !=
                            0
                    ? const Color(0xFFEF6E35)
                    : Colors.grey,
                const Color(0xFFFFFFFF)
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                child: Text(
                  "${percentage(variation.mrp, variation.sellingPrice)}"
                  "%  OFF",
                  style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800, color: Colors.white),
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
        ),
      );
    } else {
      return const SizedBox();
    }
  });
}

Widget quantitycontrolbutton(
    {required ThemeData theme,
    required variationID,
    required String pincode,
    required User? user,
    required buttontextcolor,
    required buttonbgcolor,
    required ProductModel product,
    required BuildContext ctx,
    required String qty}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        border: Border.all(color: buttontextcolor),
        color: buttonbgcolor,
        borderRadius: BorderRadius.circular(10)),
    child: Row(
      spacing: 10,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              ctx.read<CartBloc>().add(DecreaseCartQuantity(
                  pincode: pincode,
                  productRef: product.id,
                  userId: user!.uid,
                  variantId: variationID));
            },
            child: SizedBox(
                child: Center(
                    child: Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                  color: buttontextcolor,
                  borderRadius: BorderRadius.circular(3)),
            ))),
          ),
        ),
        Expanded(
          child: SizedBox(
              child: Center(
            child: Text(
              qty,
              style: theme.textTheme.bodyMedium!.copyWith(
                  color: buttontextcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            ),
          )),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              ctx.read<CartBloc>().add(IncreaseCartQuantity(
                  pincode: pincode,
                  productRef: product.id,
                  userId: user!.uid,
                  variantId: variationID));
            },
            child: SizedBox(
                child: Center(
              child: Icon(
                Icons.add,
                size: 28,
                color: buttontextcolor,
              ),
            )),
          ),
        )
      ],
    ),
  );
}

Widget samebrandproducts(
    {required Brand brand,
    required ThemeData theme,
    required BuildContext ctx}) {
  return InkWell(
    onTap: () {
      HapticFeedback.mediumImpact();
      GoRouter.of(ctx).push('/brand?brandid=${Uri.encodeComponent(brand.id)}'
          '&brandname=${Uri.encodeComponent(brand.brandName)}'
          '&branddes=${Uri.encodeComponent(brand.brandDescription)}'
          '&brandimageurl=${Uri.encodeComponent(brand.brandImage)}'
          '&websiteurl=${Uri.encodeComponent(brand.brandUrl)}'
          '&color=${Uri.encodeComponent(brand.color)}');
    },
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 15,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.network(
                height: 40,
                width: 40,
                brand.brandImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(brand.brandName,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontSize: 15, color: parseColor("000000"))),
              Text("Explore all products",
                  style:
                      theme.textTheme.bodyMedium!.copyWith(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 30,
            // color: parseColor(brand.color),
          )
        ],
      ),
    ),
  );
}

Widget productsYouMightAlsoLike(
    {required ThemeData theme, required List<ProductModel> productlist}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    color: AppColors.kwhiteColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text("You might also like", style: theme.textTheme.titleMedium),
        const SizedBox(height: 15), // Added spacing here instead
        SizedBox(
          height: 280,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final product = productlist[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ProductItem(
                  subcategoryRef: product.subCategoryRef.first.id,
                  productnamecolor: "000000",
                  mrpColor: "A19DA3",
                  offertextcolor: "233D4D",
                  productBgColor: "FFFFFF",
                  sellingPriceColor: "000000",
                  buttontextcolor: "E23338",
                  buttonBgColor: "FFFFFF",
                  unitTextcolor: "A19DA3",
                  unitbgcolor: "FFFFFF",
                  offerbgcolor: "FFFA76",
                  ctx: context,
                  product: product,
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: productlist.length,
            itemExtent: 130, // Consider adding fixed width for each item
            cacheExtent: 300, // Improves scroll performance
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

class ProductImageSlider extends StatefulWidget {
  final ProductModel product; // Assuming you have a ProductModel

  const ProductImageSlider({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;
  VideoPlayerController? _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.product.productVideo != null &&
        widget.product.productVideo!.isNotEmpty &&
        widget.product.productVideo != "video") {
      try {
        _videoPlayerController =
            VideoPlayerController.network(widget.product.productVideo!);
        _initializeVideoPlayerFuture =
            _videoPlayerController!.initialize().then((_) {
          setState(
              () {}); // Ensure the first frame is shown after initialization
        }).catchError((error) {
          print("Error initializing video player: $error");
          // Optionally set a flag to show an error message in the UI
        });
      } catch (e) {
        print("Exception creating video player controller: $e");
        // Optionally set a flag to show an error message in the UI
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  int get _itemCount {
    return widget.product.productImages.length +
        (widget.product.productVideo != null &&
                widget.product.productVideo!.isNotEmpty &&
                widget.product.productVideo != "video"
            ? 1
            : 0);
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        _itemCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: InkWell(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );
            },
            child: _currentIndex == index
                ? (index == widget.product.productImages.length &&
                        widget.product.productVideo?.isNotEmpty == true)
                    ? const Icon(Icons.play_arrow_rounded,
                        size: 21, color: Color(0xffFC5B00)) // Video icon
                    : const Icon(Icons.circle,
                        color: Color(0xffFC5B00), size: 10) // Image indicator
                : (index == widget.product.productImages.length &&
                        widget.product.productVideo?.isNotEmpty == true)
                    ? const Icon(Icons.play_arrow_outlined,
                        size: 20, color: Colors.grey) // Video icon outline
                    : const Icon(Icons.circle_outlined,
                        color: Colors.grey,
                        size: 10), // Image indicator outline
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                if (_videoPlayerController != null) {
                  if (_currentIndex == widget.product.productImages.length) {
                    _videoPlayerController!.play();
                  } else {
                    _videoPlayerController!.pause();
                  }
                }
              });
            },
            itemCount: _itemCount,
            itemBuilder: (context, index) {
              if (index < widget.product.productImages.length) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {},
                    child: CachedNetworkImage(
                      imageUrl: widget.product.productImages[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 200, // Adjust height if needed
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              } else {
                // Display the video player with controls
                return FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (_videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized) {
                        return AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(_videoPlayerController!),
                              VideoProgressIndicator(
                                _videoPlayerController!,
                                allowScrubbing: true,
                              ),
                              if (_videoPlayerController !=
                                  null) // Pass the controller
                                VideoControls(
                                    controller: _videoPlayerController!),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: Text("Error loading video"));
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                          child:
                              Text("Error loading video: ${snapshot.error}"));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildPageIndicator(),
        ),
      ],
    );
  }
}

class VideoControls extends StatefulWidget {
  final VideoPlayerController controller; // Receive the controller

  const VideoControls({super.key, required this.controller});

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        widget.controller; // Initialize with the passed controller
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoPlayerController.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(),
          ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _videoPlayerController,
            builder: (context, value, child) {
              return Expanded(
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    value.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 500,
                    color: Colors.transparent,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      value.isPlaying
                          ? _videoPlayerController.pause()
                          : _videoPlayerController.play();
                    });
                  },
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  _videoPlayerController.value.volume == 0
                      ? Icons.volume_off
                      : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _videoPlayerController.setVolume(
                        _videoPlayerController.value.volume == 0 ? 1.0 : 0.0);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }
}
