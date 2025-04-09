import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SubcategoryProductBloc(SubcategoryProductRepository())
                ..add(FetchSubcategoryProducts(widget.subcategoryref)),
        ),
        BlocProvider(
          create: (context) => RecommendedProductsBloc(RecommendedProductRepo())
            ..add(FetchRecommendedProducts(widget.subcategoryref)),
        )
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColorWhite,
        appBar: AppBar(
          toolbarHeight: 40,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: AppColors.kblackColor),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.kblackColor),
              onPressed: () {
                HapticFeedback.selectionClick();
                context.push('/searchpage');
              },
            ),
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
                      if (state is RecommendedProductLoading) {
                        return const Center(child: ProductModel1ListShimmer());
                      } else if (state is RecommendedProductLoaded) {
                        return productsYouMightAlsoLike(
                            theme: theme, productlist: state.products);
                      } else if (state is RecommendedProductError) {
                        return const Center(child: Text(""));
                      } else {
                        return const Center(child: Text(""));
                      }
                    }),
                  ],
                ),
              ),
            ),
            BlocBuilder<VariationBloc, VariationState>(
              builder: (context, state) {
                if (state is VariationSelected) {
                  return addtocartContainer(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
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
                      child: InkWell(
                        onTap: () {},
                        child: Image.network(
                          widget.product.productImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                bottom: -10,
                child: Align(
                  alignment: Alignment.bottomCenter,
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                Text(product.productName, style: theme.textTheme.titleMedium),
          ),
          product.variations.length > 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
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
                            },
                            child: variationItem(
                                theme: theme,
                                variation: product.variations[index],
                                selectedvariationid: selectedvariation.id),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("${product.variations.first.qty} "
                      "${product.variations.first.unit}"),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
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
          const SizedBox(height: 10)
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

  Widget addtocartContainer(
      {required ThemeData theme,
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
                            ? selecedvariation.sellingPrice.toStringAsFixed(1)
                            : product.variations.first.sellingPrice
                                .toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(
                        "MRP ${product.variations.length > 1 ? selecedvariation.mrp.toStringAsFixed(1) : product.variations.first.mrp.toStringAsFixed(1)}",
                        style: const TextStyle(
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
            flex: 5,
            child: SizedBox(
              height: 40,
              child:
                  BlocBuilder<CartBloc, CartState>(builder: (context, state) {
                List<CartProduct> cartItems = [];

                if (state is CartUpdated) {
                  cartItems = state.cartItems;
                }
                return cartItems.any((element) =>
                        element.productRef.id == product.id &&
                        element.variant.id == selecedvariation.id)
                    ? quantitycontrolbutton(
                        theme: theme,
                        product: product,
                        ctx: context,
                        qty: cartItems
                            .firstWhere((element) =>
                                element.productRef.id == product.id)
                            .quantity
                            .toString(),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          final firstVariation = product.variations.first;

                          context.read<CartBloc>().add(
                                AddToCart(
                                  cartProduct: CartProduct(
                                    productRef: product,
                                    variant: firstVariation,
                                    quantity: 1,
                                    pincode: "560003",
                                    sellingPrice: firstVariation.sellingPrice,
                                    mrp: firstVariation.mrp,
                                    buyingPrice: firstVariation.buyingPrice,
                                    inStock: true,
                                    variationVisibility: true,
                                    finalPrice: 0,
                                    cartAddedDate: DateTime.now(),
                                  ),
                                  userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                                  productRef: product.id,
                                  variantId: firstVariation.id,
                                  pincode: "560003",
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15), // Set border radius here
                          ),
                          backgroundColor: AppColors.addToCartBorder,
                          minimumSize: const Size(152, 48),
                        ),
                        child: const Text("Add to Cart",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      );
              }),
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

Widget quantitycontrolbutton(
    {required ThemeData theme,
    required ProductModel product,
    required BuildContext ctx,
    required String qty}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: const Color(0xFFE23338),
        borderRadius: BorderRadius.circular(10)),
    child: Row(
      spacing: 10,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              ctx.read<CartBloc>().add(DecreaseCartQuantity(
                  pincode: "560003",
                  productRef: product.id,
                  userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                  variantId: product.variations.first.id));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  child: Center(
                      child: Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3)),
              ))),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
              child: Center(
            child: Text(
              qty,
              style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
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
                  pincode: "560003",
                  productRef: product.id,
                  userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                  variantId: product.variations.first.id));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: SizedBox(
                  child: Center(
                child: Icon(
                  Icons.add,
                  size: 28,
                  color: Colors.white,
                ),
              )),
            ),
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
                  context: context,
                  product: product,
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: productlist.length,
            itemExtent: 180, // Consider adding fixed width for each item
            cacheExtent: 300, // Improves scroll performance
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
