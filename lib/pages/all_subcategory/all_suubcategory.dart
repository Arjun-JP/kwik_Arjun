import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/bloc/Coupon_bloc/Coupon_bloc.dart';
import 'package:kwik/bloc/Coupon_bloc/coupon_event.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_bloc.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_event.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/constants.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/widgets/product_model_3.dart';
import 'package:kwik/widgets/select_Varrient_bottom_sheet.dart';
import 'package:kwik/widgets/shimmer/all%20subcategory_page%20shimmer.dart';

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
    context.read<AllSubCategoryBloc>().add(SelectSubCategory(
        subCategoryId: widget.selectedsubcategory!,
        categoryID: widget.categoryrId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push('/searchpage');
                },
                child: SvgPicture.asset(
                  "assets/images/search.svg",
                  fit: BoxFit.contain,
                  width: 30,
                  height: 30,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 15)
            ]),
        body: Builder(builder: (context) {
          return BlocBuilder<AllSubCategoryBloc, AllSubCategoryState>(
              builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: AllsubcategoryPageshimmer());
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
                        state.subCategories.length > 1
                            ? Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Color.fromARGB(
                                            255, 212, 212, 212), // Border color
                                        width: .3, // Border width
                                      ),
                                    ),
                                    color: Color.fromARGB(255, 250, 250, 250),
                                  ),
                                  height: MediaQuery.of(context).size.height,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      spacing: 15,
                                      children: List.generate(
                                        state.subCategories.length,
                                        (index) => subcategoryModel(
                                            categoryID: widget.categoryrId,
                                            selectedsubcategoryID:
                                                state.selectedSubCategory,
                                            subcategory:
                                                state.subCategories[index],
                                            theme: theme,
                                            categorycolor: state.subCategories
                                                .first.categoryRef.color),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),

                        /// Right Column (Scrollable)
                        state.products
                                .where((product) => product.subCategoryRef.any(
                                    (subcat) =>
                                        subcat.id == state.selectedSubCategory))
                                .toList()
                                .isNotEmpty
                            ? Expanded(
                                flex: 3,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  padding: const EdgeInsets.all(10),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    child: StaggeredGrid.count(
                                      mainAxisSpacing: 30,
                                      crossAxisSpacing: 20,
                                      crossAxisCount:
                                          state.subCategories.length > 1
                                              ? 2
                                              : 3,
                                      children: List.generate(
                                        state.products
                                            .where((product) => product
                                                .subCategoryRef
                                                .any((subcat) =>
                                                    subcat.id ==
                                                        state
                                                            .selectedSubCategory &&
                                                    product
                                                        .variations.isNotEmpty))
                                            .length,
                                        (index) => SizedBox(
                                          height: 288,
                                          child: ProductItemSubcategorypage(
                                              product: state.products
                                                  .where((product) => product
                                                      .subCategoryRef
                                                      .any((subcat) =>
                                                          subcat.id ==
                                                          state
                                                              .selectedSubCategory))
                                                  .toList()[index],
                                              buttonBgColor: "FFFFFF",
                                              mrpColor: "A19DA3",
                                              offertextcolor: "000000",
                                              productBgColor: "FFFFFF",
                                              productnamecolor: "233D4D",
                                              sellingPriceColor: "233D4D",
                                              subcategoryRef:
                                                  widget.selectedsubcategory ??
                                                      state
                                                          .products[index]
                                                          .subCategoryRef
                                                          .first
                                                          .id,
                                              unitTextcolor: "A19DA3",
                                              unitbgcolor: "00FFFFFF",
                                              buttontextcolor: "E23338",
                                              offerbgcolor: "FFFA76",
                                              context: context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 3,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/kwiklogo.png",
                                        width: 200,
                                        height: 200,
                                      ),
                                      Text(
                                        "All out for now!\n\nswe’re restocking to serve you better!",
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 70)
                                    ],
                                  ),
                                ))
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/kwiklogo.png",
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    "All out for now!\n\nswe’re restocking to serve you better!",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 70)
                ],
              ),
            );
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
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          // height: 105,
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

class ProductItemSubcategorypage extends StatelessWidget {
  final String subcategoryRef;
  final ProductModel product;
  final String productnamecolor;
  final String mrpColor;
  final String offertextcolor;
  final String productBgColor;
  final String sellingPriceColor;
  final String buttontextcolor;
  final String buttonBgColor;
  final String offerbgcolor;
  final String unitTextcolor;
  final String unitbgcolor;
  final BuildContext context;

  const ProductItemSubcategorypage({
    super.key,
    required this.mrpColor,
    required this.offertextcolor,
    required this.productBgColor,
    required this.sellingPriceColor,
    required this.buttontextcolor,
    required this.unitTextcolor,
    required this.product,
    required this.offerbgcolor,
    required this.buttonBgColor,
    required this.productnamecolor,
    required this.unitbgcolor,
    required this.subcategoryRef,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      List<CartProduct> cartItems = [];

      if (state is CartUpdated) {
        cartItems = state.cartItems;
      }
      return Stack(
        children: [
          InkWell(
            onTap: () => context.push(
              '/productdetails',
              extra: {
                'product': product,
                'subcategoryref': subcategoryRef,
                'buttonbg':
                    parseColor(buttontextcolor), // example color as a string
                'buttontext': parseColor(buttonBgColor),
              },
            ),
            child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, warstate) {
              if (warstate is LocationSearchResults) {
                String warehouseid = warstate.warehouse!.id;
                return Opacity(
                  opacity: product.variations.length == 1 &&
                          (product.variations.first.stock
                                  .where((element) =>
                                      element.warehouseRef == warehouseid)
                                  .isEmpty ||
                              product.variations.first.stock
                                      .where((element) =>
                                          element.warehouseRef == warehouseid)
                                      .first
                                      .stockQty ==
                                  0)
                      ? .5
                      : 1,
                  child: Stack(
                    children: [
                      Container(
                        // width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Container(
                              height: 165,
                              decoration: BoxDecoration(
                                color: parseColor("F9F9F9"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                // width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(product.productImages[0]),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 1),
                            SizedBox(
                              // width: 120,
                              child: Text(
                                product.productName,
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: parseColor(productnamecolor),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: unitbgcolor == "FFFFFF" ||
                                              unitbgcolor == "00FFFFFF"
                                          ? 0
                                          : 10,
                                      vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: parseColor(unitbgcolor),
                                  ),
                                  child: Text(
                                    product.variations.length == 1
                                        ? "${product.variations.first.qty}  ${product.variations.first.unit}"
                                        : "${product.variations.length} Options",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: parseColor(unitTextcolor),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                Icon(
                                  averagerating(product.reviews) > 1
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                Icon(
                                  averagerating(product.reviews) > 2
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                Icon(
                                  averagerating(product.reviews) > 3
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                Icon(
                                  averagerating(product.reviews) > 4
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                Text(
                                  "(${product.reviews.isEmpty ? "1" : product.reviews.length.toString()})",
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 12),
                                )
                              ],
                            )),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₹${product.variations.first.mrp.toStringAsFixed(0)}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          color: parseColor(mrpColor),
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        "₹${product.variations.first.sellingPrice.toStringAsFixed(0)}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          color: parseColor(sellingPriceColor),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                    height: 30,
                                    child: cartItems.any((element) =>
                                            element.productRef.id == product.id)
                                        ? quantitycontrolbutton(
                                            buttonbgcolor: buttontextcolor,
                                            buttontextcolor: buttonBgColor,
                                            theme: theme,
                                            user: user,
                                            pincode: warstate.pincode,
                                            product: product,
                                            variationID: cartItems
                                                .firstWhere((element) =>
                                                    element.productRef.id ==
                                                    product.id)
                                                .variant
                                                .id,
                                            qty: cartItems
                                                .firstWhere((element) =>
                                                    element.productRef.id ==
                                                    product.id)
                                                .quantity
                                                .toString(),
                                          )
                                        : (product.variations.isNotEmpty
                                            ? ElevatedButton(
                                                onPressed: () async {
                                                  HapticFeedback.mediumImpact();
                                                  final firstVariation =
                                                      product.variations.first;

                                                  if (product
                                                          .variations.length >
                                                      1) {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () =>
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus(),
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                SelectVarrientBottomSheet(
                                                              product: product,
                                                              buttonBgColor:
                                                                  buttontextcolor,
                                                              buttontextcolor:
                                                                  buttonBgColor,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    context
                                                        .read<CartBloc>()
                                                        .add(
                                                          AddToCart(
                                                            cartProduct:
                                                                CartProduct(
                                                              productRef:
                                                                  product,
                                                              variant:
                                                                  firstVariation,
                                                              quantity: 1,
                                                              pincode: warstate
                                                                  .pincode,
                                                              sellingPrice:
                                                                  firstVariation
                                                                      .sellingPrice,
                                                              mrp:
                                                                  firstVariation
                                                                      .mrp,
                                                              buyingPrice:
                                                                  firstVariation
                                                                      .buyingPrice,
                                                              inStock: true,
                                                              variationVisibility:
                                                                  true,
                                                              finalPrice: 0,
                                                              cartAddedDate:
                                                                  DateTime
                                                                      .now(),
                                                            ),
                                                            userId: user!.uid,
                                                            productRef:
                                                                product.id,
                                                            variantId:
                                                                firstVariation
                                                                    .id,
                                                            pincode: warstate
                                                                .pincode,
                                                          ),
                                                        );
                                                    context
                                                        .read<CouponBloc>()
                                                        .add(ResetCoupons());
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      parseColor(buttonBgColor),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: parseColor(
                                                            buttontextcolor)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                ),
                                                child: Text(
                                                  product.variations.length ==
                                                              1 &&
                                                          (product.variations
                                                                  .first.stock
                                                                  .where((element) =>
                                                                      element
                                                                          .warehouseRef ==
                                                                      warehouseid)
                                                                  .isEmpty ||
                                                              product
                                                                      .variations
                                                                      .first
                                                                      .stock
                                                                      .where((element) =>
                                                                          element
                                                                              .warehouseRef ==
                                                                          warehouseid)
                                                                      .first
                                                                      .stockQty ==
                                                                  0)
                                                      ? 'No stock'
                                                      : "Add",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                    color: parseColor(
                                                        buttontextcolor),
                                                    fontFamily: "Inter",
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()), // Return empty widget if no variations
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      ClipPath(
                        clipper: ZigZagClipper(),
                        child: Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            color: parseColor(offerbgcolor),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${percentage(product.variations.first.mrp, product.variations.first.sellingPrice)}"
                                " "
                                "%",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: parseColor(offertextcolor),
                                  fontSize: 11,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "OFF",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: parseColor(offertextcolor),
                                  fontSize: 10,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ),
        ],
      );
    });
  }

  Widget quantitycontrolbutton(
      {required ThemeData theme,
      required final User? user,
      required final String pincode,
      required String buttonbgcolor,
      required String buttontextcolor,
      required ProductModel product,
      required String variationID,
      required String qty}) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: parseColor(buttonbgcolor),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        spacing: 2,
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                context.read<CartBloc>().add(DecreaseCartQuantity(
                    pincode: pincode,
                    productRef: product.id,
                    userId: user!.uid,
                    variantId: variationID));
                context.read<CouponBloc>().add(ResetCoupons());
              },
              child: SizedBox(
                  child: Center(
                      child: Container(
                width: 12,
                height: 2,
                decoration: BoxDecoration(
                    color: parseColor(buttontextcolor),
                    borderRadius: BorderRadius.circular(3)),
              ))),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
                child: Center(
              child: Text(
                qty,
                style: theme.textTheme.bodyMedium!.copyWith(
                    color: parseColor(buttontextcolor),
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
            )),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                context.read<CartBloc>().add(IncreaseCartQuantity(
                    pincode: pincode,
                    productRef: product.id,
                    userId: user!.uid,
                    variantId: variationID));
                context.read<CouponBloc>().add(ResetCoupons());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(
                    child: Center(
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: parseColor(buttontextcolor),
                  ),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 10);

    double x = 0;
    double y = size.height - 10;
    double step = size.width / 10;

    for (int i = 0; i < 10; i++) {
      x += step;
      y = (i % 2 == 0) ? size.height : size.height - 10;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(ZigZagClipper oldClipper) => false;
}
