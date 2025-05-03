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
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/constants.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/pages/Address_management/address_form.dart';
import 'package:kwik/widgets/custom_snackbar.dart' show CustomSnackBars;
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/select_Varrient_bottom_sheet.dart';

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
    required String seeAllButtonBG,
    required String seeAllButtontext,
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
                        Container(
                          height: 120,
                          width: 110,
                          decoration: BoxDecoration(
                            color: parseColor(productcolor),
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(product.productImages[0]),
                              fit: BoxFit.contain,
                            ),
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
                        const SizedBox(
                            child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 15,
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 15,
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 15,
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 15,
                            ),
                            Icon(
                              Icons.star_outline_rounded,
                              color: Colors.amber,
                              size: 15,
                            ),
                          ],
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                                product.variations.first.buyingPrice
                                    .toStringAsFixed(1),
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: parseColor(sellingpricecolor))),
                            Text(
                                product.variations.first.mrp.toStringAsFixed(1),
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    decoration: TextDecoration.lineThrough,
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
                      decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${percentage(product.variations.first.mrp, product.variations.first.sellingPrice)}",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: parseColor("233D4D"),
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "OFF",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: parseColor("233D4D"),
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
                            pincode: extractAddressDetails(
                                warstate.currentlocationaddress)["pin"]!,
                            buttontextcolor: seeAllButtonBG,
                            buttonbgcolor: seeAllButtontext,
                            context: context,
                            theme: theme,
                            product: product,
                            qty: cartItems
                                .firstWhere(
                                  (element) =>
                                      element.productRef.id == product.id,
                                  orElse: () => CartProduct(
                                    productRef: product,
                                    quantity:
                                        1, // Default quantity to prevent UI flicker
                                    variant: product.variations.first,
                                    pincode: extractAddressDetails(warstate
                                        .currentlocationaddress)["pin"]!,
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
                                              buttonBgColor: seeAllButtontext,
                                              buttontextcolor: seeAllButtonBG,
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
                                              pincode: extractAddressDetails(
                                                      warstate
                                                          .currentlocationaddress)[
                                                  "pin"]!,
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
                                            pincode: extractAddressDetails(
                                                    warstate
                                                        .currentlocationaddress)[
                                                "pin"]!,
                                          ),
                                        );
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
                                    color: parseColor(seeAllButtonBG),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: parseColor(buttontextcolor)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      product.variations.length == 1 &&
                                              (product.variations.first.stock
                                                      .where(
                                                        (element) => element.warehouseRef==warstate.warehouse!.id,
                                                      ).isEmpty||product.variations.first.stock
                                                      .where(
                                                        (element) => element.warehouseRef==warstate.warehouse!.id,
                                                      ).first .stockQty ==
                                                  0)
                                          ? "No stock"
                                          : "Add",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: parseColor(seeAllButtontext),
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
    required String buttontextcolor,
    required ProductModel product,
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
              context.read<CartBloc>().add(IncreaseCartQuantity(
                  pincode: pincode,
                  productRef: product.id,
                  userId: user!.uid,
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
