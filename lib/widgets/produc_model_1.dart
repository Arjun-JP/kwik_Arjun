import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/constants.dart';
import 'package:kwik/main.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/select_Varrient_bottom_sheet.dart';

class ProductItem extends StatelessWidget {
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
  final BuildContext ctx;

  const ProductItem({
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
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      List<CartProduct> cartItems = [];

      if (state is CartUpdated) {
        print(state.message);
        cartItems = state.cartItems;
      }
      return Stack(
        children: [
          InkWell(
            onTap: () {
              context.push(
                '/productdetails',
                extra: {
                  'product': product,
                  'subcategoryref': subcategoryRef,
                  'buttonbg':
                      parseColor(buttontextcolor), // example color as a string
                  'buttontext': parseColor(buttonBgColor),
                },
              );
            },
            child: Stack(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3,
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: parseColor(productBgColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(product.productImages[0]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      SizedBox(
                        width: 120,
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
                                horizontal: unitbgcolor == "00FFFFFF" ? 0 : 10,
                                vertical: 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: parseColor(unitbgcolor),
                            ),
                            child: Text(
                              product.variations.length > 1
                                  ? "${product.variations.length} options"
                                  : "${product.variations.first.qty}  ${product.variations.first.unit}",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: parseColor(unitTextcolor),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "₹${product.variations.first.mrp.toStringAsFixed(0)}",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: parseColor(mrpColor),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  "₹${product.variations.first.sellingPrice.toStringAsFixed(0)}",
                                  style: theme.textTheme.bodyMedium!.copyWith(
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
                                      instock: state is CartUpdated
                                          ? state.message
                                          : false,
                                      buttonbgcolor: buttontextcolor,
                                      buttontextcolor: buttonBgColor,
                                      theme: theme,
                                      product: product,
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
                                            } else if (product.variations
                                                            .length ==
                                                        1 &&
                                                    product
                                                            .variations
                                                            .first
                                                            .stock
                                                            .first
                                                            .stockQty !=
                                                        0 &&
                                                    state is CartUpdated
                                                ? state.message
                                                : false == true) {
                                              context.read<CartBloc>().add(
                                                    AddToCart(
                                                      cartProduct: CartProduct(
                                                        productRef: product,
                                                        variant: firstVariation,
                                                        quantity: 1,
                                                        pincode: "560003",
                                                        sellingPrice:
                                                            firstVariation
                                                                .sellingPrice,
                                                        mrp: firstVariation.mrp,
                                                        buyingPrice:
                                                            firstVariation
                                                                .buyingPrice,
                                                        inStock: true,
                                                        variationVisibility:
                                                            true,
                                                        finalPrice: 0,
                                                        cartAddedDate:
                                                            DateTime.now(),
                                                      ),
                                                      userId:
                                                          "s5ZdLnYhnVfAramtr7knGduOI872",
                                                      productRef: product.id,
                                                      variantId:
                                                          firstVariation.id,
                                                      pincode: "560003",
                                                    ),
                                                  );
                                            } else {
                                              HapticFeedback.heavyImpact();
                                              try {
                                                print("snckbar send");
                                                rootScaffoldMessengerKey
                                                    .currentState
                                                    ?.showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Out of stock")));
                                                print("snckbar send");
                                              } catch (e) {
                                                print(e);
                                              }
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
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.all(0),
                                          ),
                                          child: Text(
                                            product.variations.length == 1 &&
                                                    product
                                                            .variations
                                                            .first
                                                            .stock
                                                            .first
                                                            .stockQty ==
                                                        0
                                                ? 'No stock'
                                                : "Add",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color:
                                                  parseColor(buttontextcolor),
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
                            fontSize: 10,
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
          ),
        ],
      );
    });
  }

  Widget quantitycontrolbutton(
      {required ThemeData theme,
      required String buttonbgcolor,
      required String buttontextcolor,
      required bool instock,
      required ProductModel product,
      required String qty}) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: parseColor(buttonbgcolor), width: .5),
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
                ctx.read<CartBloc>().add(DecreaseCartQuantity(
                    pincode: "560003",
                    productRef: product.id,
                    userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                    variantId: product.variations.first.id));
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
                ctx.read<CartBloc>().add(IncreaseCartQuantity(
                    pincode: "560003",
                    productRef: product.id,
                    userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                    variantId: product.variations.first.id));
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
