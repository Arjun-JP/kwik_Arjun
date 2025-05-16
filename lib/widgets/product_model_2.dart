import 'dart:math';
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
import 'package:kwik/widgets/custom_snackbar.dart';
import 'package:kwik/widgets/select_Varrient_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;

class ProductModel2 extends StatelessWidget {
  // final ProductModel product;

  final String productcolor;
  final String sellingpricecolor;
  final String mrpColor;
  final String offertextcolor;
  final String offertextcolor2;
  final String offerbordercolor;
  final String offerbgcolor1;
  final String offerbgcolor2;
  final String productBgColor;
  final String buttontextcolor;
  final String unitbgcolor;
  final String unitTextcolor;
  final String buttonbgcolor;
  final BuildContext context;
  final ProductModel product;
  final String subcategoryref;
  const ProductModel2(
      {super.key,
      required this.productcolor,
      required this.sellingpricecolor,
      required this.mrpColor,
      required this.offertextcolor,
      required this.productBgColor,
      required this.buttontextcolor,
      required this.unitbgcolor,
      required this.unitTextcolor,
      required this.context,
      required this.offertextcolor2,
      required this.offerbordercolor,
      required this.buttonbgcolor,
      required this.offerbgcolor1,
      required this.offerbgcolor2,
      required this.product,
      required this.subcategoryref});

  @override
  build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      List<CartProduct> cartItems = [];

      if (state is CartUpdated) {
        cartItems = state.cartItems;
      }
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: BlocBuilder<AddressBloc, AddressState>(
            builder: (context, warstate) {
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
              child: Stack(
                children: [
                  InkWell(
                    onTap: () => context.push(
                      '/productdetails',
                      extra: {
                        'product': product,
                        'subcategoryref': subcategoryref,
                        'buttonbg': parseColor(
                            buttontextcolor), // example color as a string
                        'buttontext': parseColor(buttonbgcolor)
                      },
                    ),
                    child: SizedBox(
                      width: 154,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shadowColor:
                                const Color.fromARGB(255, 233, 233, 233),
                            elevation: .1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Container(
                                    height: 58,
                                    width: 154,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: parseColor(
                                              offerbordercolor), // Change color as needed
                                          width: 2.0, // Change width as needed
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      color: parseColor(offerbgcolor1),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "₹${product.variations.first.sellingPrice.toStringAsFixed(0)}",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: parseColor(
                                                  sellingpricecolor)),
                                        ),
                                        Text(
                                            "MRP ${product.variations.first.mrp.toStringAsFixed(0)}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                                color: parseColor(mrpColor))),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: SizedBox(
                                    height: 164,
                                    width: 143,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 164,
                                          width: 143,
                                          child: CachedNetworkImage(
                                            imageUrl: product.productImages[0],
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: double.infinity,
                                                height: 200,
                                                color: Colors.white,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Align(
                                          alignment: const Alignment(-.99, .9),
                                          child: ClipPath(
                                            clipper:
                                                SmoothJaggedCircleClipper(),
                                            child: Container(
                                              width: 55,
                                              height: 55,
                                              color: parseColor(offerbgcolor2),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${percentage(product.variations.first.mrp, product.variations.first.sellingPrice)}"
                                                    " "
                                                    "%",
                                                    textAlign: TextAlign.center,
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                            color: parseColor(
                                                                offertextcolor),
                                                            fontFamily: "Inter",
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                  ),
                                                  Text(
                                                    "OFF",
                                                    textAlign: TextAlign.center,
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: parseColor(
                                                          offertextcolor2),
                                                      fontFamily: "Inter",
                                                    ),
                                                  ),
                                                ],
                                              ), // Match the color in your image
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            child: SizedBox(
                              width: 154,
                              height: 40,
                              child: Text(
                                product.productName,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            child: Text(
                              product.variations.length > 1
                                  ? "${product.variations.length} options"
                                  : "${product.variations.first.qty} ${product.variations.first.unit}",
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                  color: parseColor(unitTextcolor),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5,
                            ),
                            child: cartItems.any((element) =>
                                    element.productRef.id == product.id)
                                ? quantitycontrolbutton(
                                    user: user,
                                    pincode: warstate.pincode,
                                    buttonbgcolor: buttontextcolor,
                                    buttontext: buttonbgcolor,
                                    theme: theme,
                                    product: product,
                                    variationid: cartItems
                                        .firstWhere((element) =>
                                            element.productRef.id == product.id)
                                        .variant
                                        .id,
                                    qty: cartItems
                                        .firstWhere(
                                          (element) =>
                                              element.productRef.id ==
                                              product.id,
                                          orElse: () => CartProduct(
                                            productRef: product,
                                            quantity:
                                                1, // Default quantity to prevent UI flicker
                                            variant: product.variations.first,
                                            pincode: warstate.pincode,
                                            sellingPrice: product
                                                .variations.first.sellingPrice,
                                            mrp: product.variations.first.mrp,
                                            buyingPrice: product
                                                .variations.first.buyingPrice,
                                            inStock: true,
                                            variationVisibility: true,
                                            finalPrice: 0,
                                            cartAddedDate: DateTime.now(),
                                          ),
                                        )
                                        .quantity
                                        .toString(),
                                  )
                                : product.variations.isNotEmpty
                                    ? SizedBox(
                                        height: 35,
                                        width: 154,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (product.variations.length > 1) {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          SelectVarrientBottomSheet(
                                                        buttonBgColor:
                                                            buttontextcolor,
                                                        buttontextcolor:
                                                            buttonbgcolor,
                                                        product: product,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else if (product.variations ==
                                                    1 &&
                                                product.variations.first.stock
                                                        .first.stockQty !=
                                                    0) {
                                              context.read<CartBloc>().add(
                                                    AddToCart(
                                                      cartProduct: CartProduct(
                                                        productRef: product,
                                                        variant: product
                                                            .variations.first,
                                                        quantity: 1,
                                                        pincode:
                                                            warstate.pincode,
                                                        sellingPrice: product
                                                            .variations
                                                            .first
                                                            .sellingPrice,
                                                        mrp: product.variations
                                                            .first.mrp,
                                                        buyingPrice: product
                                                            .variations
                                                            .first
                                                            .buyingPrice,
                                                        inStock: true,
                                                        variationVisibility:
                                                            true,
                                                        finalPrice: 0,
                                                        cartAddedDate:
                                                            DateTime.now(),
                                                      ),
                                                      userId: user!.uid,
                                                      productRef: product.id,
                                                      variantId: product
                                                          .variations.first.id,
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                parseColor(buttonbgcolor),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: parseColor(
                                                      buttontextcolor)),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: Text(
                                            product.variations.length == 1 &&
                                                    (product.variations.first
                                                            .stock
                                                            .where((element) =>
                                                                element
                                                                    .warehouseRef ==
                                                                warehouseid)
                                                            .isEmpty ||
                                                        product.variations.first
                                                                .stock
                                                                .where((element) =>
                                                                    element
                                                                        .warehouseRef ==
                                                                    warehouseid)
                                                                .first
                                                                .stockQty ==
                                                            0)
                                                ? "Out of stock"
                                                : 'Add to Cart',
                                            style: TextStyle(
                                              color:
                                                  parseColor(buttontextcolor),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        child: Text("error"),
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
      );
    });
  }

  Widget quantitycontrolbutton(
      {required ThemeData theme,
      required String buttonbgcolor,
      required String buttontext,
      required User? user,
      required String pincode,
      required ProductModel product,
      required String variationid,
      required String qty}) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          color: parseColor(buttonbgcolor),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                context.read<CartBloc>().add(DecreaseCartQuantity(
                    pincode: pincode,
                    productRef: product.id,
                    userId: user!.uid,
                    variantId: variationid));
                context.read<CouponBloc>().add(ResetCoupons());
              },
              child: SizedBox(
                  height: 24,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 2,
                        decoration: BoxDecoration(
                            color: parseColor(buttontext),
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: SizedBox(
                child: Center(
              child: Text(
                qty,
                style: theme.textTheme.bodyMedium!.copyWith(
                    color: parseColor(buttontext),
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
            )),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                context.read<CartBloc>().add(IncreaseCartQuantity(
                    pincode: pincode,
                    productRef: product.id,
                    userId: user!.uid,
                    variantId: variationid));
                context.read<CouponBloc>().add(ResetCoupons());
              },
              child: SizedBox(
                  child: Center(
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: parseColor(buttontext),
                ),
              )),
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

class SmoothJaggedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double outerRadius = size.width / 2;
    double innerRadius = outerRadius * 0.85; // Adjust for smoothness
    int points = 20; // Number of spikes
    double angle = (2 * pi) / points;

    for (int i = 0; i < points; i++) {
      double startRadius = (i % 2 == 0) ? outerRadius : innerRadius;
      double endRadius = (i % 2 == 0) ? innerRadius : outerRadius;

      double startX = centerX + startRadius * cos(i * angle);
      double startY = centerY + startRadius * sin(i * angle);

      double endX = centerX + endRadius * cos((i + 1) * angle);
      double endY = centerY + endRadius * sin((i + 1) * angle);

      double controlX =
          centerX + (startRadius + endRadius) / 2 * cos((i + 0.5) * angle);
      double controlY =
          centerY + (startRadius + endRadius) / 2 * sin((i + 0.5) * angle);

      if (i == 0) {
        path.moveTo(startX, startY);
      }

      path.quadraticBezierTo(controlX, controlY, endX, endY);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(SmoothJaggedCircleClipper oldClipper) => false;
}
