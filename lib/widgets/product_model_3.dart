import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/bloc/Coupon_bloc/Coupon_bloc.dart';
import 'package:kwik/bloc/Coupon_bloc/coupon_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/constants.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/review_model.dart';
import 'package:kwik/widgets/custom_snackbar.dart' show CustomSnackBars;
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/select_Varrient_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

Widget productModel3(
    {required ProductModel product,
    required String productcolor,
    required String sellingpricecolor,
    required String mrpColor,
    required String offertextcolor,
    required String offerBGcolor,
    required String productBgColor,
    required String sellingPriceColor,
    required String buttontextcolor,
    required String unitbgcolor,
    required String unitTextcolor,
    required String buttonBG,
    required String buttontext,
    required ThemeData theme,
    required BuildContext context}) {
  final user = FirebaseAuth.instance.currentUser;
  return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
    List<CartProduct> cartItems = [];

    if (state is CartUpdated) {
      cartItems = state.cartItems;
    }
    return InkWell(
      onTap: () => context.push(
        '/productdetails',
        extra: {
          'product': product,
          'subcategoryref': product.subCategoryRef.first.id,
          'buttonbg': lightenColor(
              parseColor(buttontextcolor), .9), // example color as a string
          'buttontext': parseColor(buttontextcolor),
        },
      ),
      child:
          BlocBuilder<AddressBloc, AddressState>(builder: (context, warstate) {
        if (warstate is LocationSearchResults) {
          String warehouseid = warstate.warehouse!.id;
          return Opacity(
            opacity: product.variations.length == 1
                ? product.variations.first.stock
                            .where((element) =>
                                element.warehouseRef == warehouseid)
                            .isEmpty ||
                        product.variations.first.stock
                                .where((element) =>
                                    element.warehouseRef == warehouseid)
                                .first
                                .stockQty ==
                            0
                    ? .5
                    : 1
                : 1,
            child: SizedBox(
              child: Stack(
                clipBehavior: Clip.none, // Allows elements to overflow
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: const Color.fromARGB(255, 233, 255, 234),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 5,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 110,
                          child: CachedNetworkImage(
                            imageUrl: product.productImages[0],
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                                height: 200, // Optional height
                                width: double.infinity,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                    color: parseColor(unitbgcolor),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    product.variations.length > 1
                                        ? "${product.variations.length} options"
                                        : "${product.variations.first.qty} ${product.variations.first.unit}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: parseColor(unitTextcolor)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(
                            product.productName,
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                                "₹${product.variations.first.buyingPrice.toStringAsFixed(1)}",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: parseColor(sellingpricecolor))),
                            Text(
                                "₹${product.variations.first.mrp.toStringAsFixed(1)}",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8,
                                    color: parseColor(mrpColor)))
                          ],
                        )
                      ],
                    ),
                  ),
                  ClipPath(
                    clipper: ZigZagClipper(),
                    child: Container(
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                          color: parseColor(offerBGcolor),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${percentage(product.variations.first.mrp, product.variations.first.sellingPrice)}",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: parseColor(offertextcolor),
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "OFF",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: parseColor(offertextcolor),
                              fontFamily: "Inter",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  cartItems
                          .any((element) => element.productRef.id == product.id)
                      ? Positioned(
                          top: 95,
                          right: 8,
                          child: quantitycontrolbutton(
                            user: user,
                            pincode: warstate.pincode,
                            buttontext: buttonBG,
                            buttonbgcolor: buttontext,
                            context: context,
                            theme: theme,
                            product: product,
                            variationID: cartItems
                                .firstWhere((element) =>
                                    element.productRef.id == product.id)
                                .variant
                                .id,
                            qty: cartItems
                                .firstWhere(
                                  (element) =>
                                      element.productRef.id == product.id,
                                  orElse: () => CartProduct(
                                    productRef: product,
                                    quantity:
                                        1, // Default quantity to prevent UI flicker
                                    variant: product.variations.first,
                                    pincode: warstate.pincode,
                                    sellingPrice:
                                        product.variations.first.sellingPrice,
                                    mrp: product.variations.first.mrp,
                                    buyingPrice:
                                        product.variations.first.buyingPrice,
                                    inStock: true,
                                    variationVisibility: true,
                                    finalPrice: 0,
                                    cartAddedDate: DateTime.now(),
                                  ),
                                )
                                .quantity
                                .toString(),
                          ),
                        )
                      : product.variations.isNotEmpty
                          ? Positioned(
                              top: 95,
                              right: 8,
                              child: InkWell(
                                onTap: () async {
                                  HapticFeedback.mediumImpact();
                                  if (product.variations.length > 1) {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () =>
                                              FocusScope.of(context).unfocus(),
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: SelectVarrientBottomSheet(
                                              buttonBgColor: buttontext,
                                              buttontextcolor: buttonBG,
                                              product: product,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else if (product.variations.length == 1 &&
                                          product.variations.first.stock
                                              .where((element) =>
                                                  element.warehouseRef ==
                                                  warehouseid)
                                              .isNotEmpty ||
                                      product.variations.first.stock
                                              .where((element) =>
                                                  element.warehouseRef ==
                                                  warehouseid)
                                              .first
                                              .stockQty !=
                                          0) {
                                    context.read<CartBloc>().add(
                                          AddToCart(
                                            cartProduct: CartProduct(
                                              productRef: product,
                                              variant: product.variations.first,
                                              quantity: 1,
                                              pincode: warstate.pincode,
                                              sellingPrice: product.variations
                                                  .first.sellingPrice,
                                              mrp: product.variations.first.mrp,
                                              buyingPrice: product
                                                  .variations.first.buyingPrice,
                                              inStock: true,
                                              variationVisibility: true,
                                              finalPrice: 0,
                                              cartAddedDate: DateTime.now(),
                                            ),
                                            userId: user!.uid,
                                            productRef: product.id,
                                            variantId:
                                                product.variations.first.id,
                                            pincode: warstate.pincode,
                                          ),
                                        );
                                    context
                                        .read<CouponBloc>()
                                        .add(ResetCoupons());
                                  } else {
                                    HapticFeedback.heavyImpact();
                                    CustomSnackBars
                                        .showLimitedQuantityWarning();
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: parseColor(buttonBG),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: parseColor(buttontext)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      product.variations.length == 1 &&
                                              (product.variations.first.stock
                                                      .where(
                                                        (element) =>
                                                            element
                                                                .warehouseRef ==
                                                            warstate
                                                                .warehouse!.id,
                                                      )
                                                      .isEmpty ||
                                                  product.variations.first.stock
                                                          .where(
                                                            (element) =>
                                                                element
                                                                    .warehouseRef ==
                                                                warstate
                                                                    .warehouse!
                                                                    .id,
                                                          )
                                                          .first
                                                          .stockQty ==
                                                      0)
                                          ? "No stock"
                                          : "Add",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: parseColor(buttontext),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  });
}

Widget quantitycontrolbutton(
    {required ThemeData theme,
    required User? user,
    required String pincode,
    required String buttonbgcolor,
    required String buttontext,
    required ProductModel product,
    required String variationID,
    required BuildContext context,
    required String qty}) {
  return Container(
    height: 30,
    width: 80,
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
                  color: parseColor(buttontext),
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
                  color: parseColor(buttontext),
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
                  color: parseColor(buttontext),
                ),
              )),
            ),
          ),
        )
      ],
    ),
  );
}

averagerating(List<ReviewModel> reviews) {
  if (reviews.isEmpty) {
    return 4;
  } else {
    double sum = 0;
    for (int i = 0; i < reviews.length; i++) {
      sum += reviews[i].rating;
    }
    double average = sum / reviews.length;
    return average;
  }
}
