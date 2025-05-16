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
import 'package:kwik/bloc/Coupon_bloc/Coupon_bloc.dart' show CouponBloc;
import 'package:kwik/bloc/Coupon_bloc/coupon_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/constants.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/produc_model_1.dart';

class SelectVarrientBottomSheet extends StatefulWidget {
  final ProductModel product;
  final String buttonBgColor;
  final String buttontextcolor;

  const SelectVarrientBottomSheet(
      {super.key,
      required this.product,
      required this.buttonBgColor,
      required this.buttontextcolor});

  @override
  State<SelectVarrientBottomSheet> createState() =>
      _SelectVarrientBottomSheetState();
}

TextEditingController lessoncontroller = TextEditingController();

class _SelectVarrientBottomSheetState extends State<SelectVarrientBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final filtredvariations = widget.product.variations
        .where((element) => element.stock.isNotEmpty)
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            context.pop();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(50)),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                border: Border(
                  top: BorderSide(
                    color:
                        parseColor(widget.buttonBgColor), // Choose your color
                    width: 2.0, // Thickness of the border
                  ),
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18))),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.product.productName,
                      maxLines: 2,
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: filtredvariations.length * 100,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return BlocBuilder<AddressBloc, AddressState>(
                                builder: (context, addressstate) {
                              if (addressstate is LocationSearchResults) {
                                return Opacity(
                                  opacity: filtredvariations[index]
                                              .stock
                                              .where((element) =>
                                                  element.warehouseRef ==
                                                  addressstate.warehouse!.id)
                                              .isNotEmpty &&
                                          filtredvariations[index]
                                                  .stock
                                                  .where((element) =>
                                                      element.warehouseRef ==
                                                      addressstate
                                                          .warehouse!.id)
                                                  .first
                                                  .stockQty !=
                                              0
                                      ? 1
                                      : .5,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            )),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Image.network(
                                                widget.product.productImages
                                                    .first,
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    "${filtredvariations[index].qty} ${filtredvariations[index].unit}",
                                                    maxLines: 1,
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                          "₹${filtredvariations[index].sellingPrice}",
                                                          style: theme.textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800)),
                                                      Text(
                                                        "₹${filtredvariations[index].mrp}",
                                                        style: theme.textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                color: Colors
                                                                    .blueGrey),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(
                                                height: 40,
                                                child: BlocBuilder<CartBloc,
                                                        CartState>(
                                                    builder: (context, state) {
                                                  List<CartProduct> cartItems =
                                                      [];

                                                  if (state is CartUpdated) {
                                                    cartItems = state.cartItems;
                                                  }
                                                  return cartItems.any(
                                                          (element) =>
                                                              element.productRef
                                                                      .id ==
                                                                  widget.product
                                                                      .id &&
                                                              element.variant
                                                                      .id ==
                                                                  widget
                                                                      .product
                                                                      .variations[
                                                                          index]
                                                                      .id)
                                                      ? quantitycontrolbutton(
                                                          user: user,
                                                          pincode: addressstate
                                                              .pincode,
                                                          variationid: widget
                                                              .product
                                                              .variations[index]
                                                              .id,
                                                          theme: theme,
                                                          product:
                                                              widget.product,
                                                          ctx: context,
                                                          buttonbgcolor: widget
                                                              .buttonBgColor,
                                                          buttontextcolor: widget
                                                              .buttontextcolor,
                                                          qty: cartItems
                                                              .firstWhere((element) =>
                                                                  element
                                                                      .productRef
                                                                      .id ==
                                                                  widget.product
                                                                      .id)
                                                              .quantity
                                                              .toString(),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            final firstVariation =
                                                                widget.product
                                                                        .variations[
                                                                    index];

                                                            if (widget
                                                                    .product
                                                                    .variations[
                                                                        index]
                                                                    .stock
                                                                    .first
                                                                    .stockQty ==
                                                                0) {
                                                              HapticFeedback
                                                                  .heavyImpact();
                                                              print(
                                                                  "out of stock");
                                                            } else {
                                                              print(
                                                                  "out of stock still in else condation");
                                                              context
                                                                  .read<
                                                                      CartBloc>()
                                                                  .add(
                                                                    AddToCart(
                                                                      cartProduct:
                                                                          CartProduct(
                                                                        productRef:
                                                                            widget.product,
                                                                        variant:
                                                                            firstVariation,
                                                                        quantity:
                                                                            1,
                                                                        pincode:
                                                                            addressstate.pincode,
                                                                        sellingPrice:
                                                                            firstVariation.sellingPrice,
                                                                        mrp: firstVariation
                                                                            .mrp,
                                                                        buyingPrice:
                                                                            firstVariation.buyingPrice,
                                                                        inStock:
                                                                            true,
                                                                        variationVisibility:
                                                                            true,
                                                                        finalPrice:
                                                                            0,
                                                                        cartAddedDate:
                                                                            DateTime.now(),
                                                                      ),
                                                                      userId: user!
                                                                          .uid,
                                                                      productRef:
                                                                          widget
                                                                              .product
                                                                              .id,
                                                                      variantId:
                                                                          firstVariation
                                                                              .id,
                                                                      pincode:
                                                                          addressstate
                                                                              .pincode,
                                                                    ),
                                                                  );
                                                              context
                                                                  .read<
                                                                      CouponBloc>()
                                                                  .add(
                                                                      ResetCoupons());
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15), // Set border radius here
                                                            ),
                                                            backgroundColor:
                                                                parseColor(widget
                                                                    .buttonBgColor),
                                                            minimumSize:
                                                                const Size(
                                                                    152, 48),
                                                          ),
                                                          child: Text("Add",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: parseColor(
                                                                    widget
                                                                        .buttontextcolor),
                                                              )),
                                                        );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ClipPath(
                                        clipper: ZigZagClipper(),
                                        child: Container(
                                          width: 45,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: parseColor("E3520D"),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${percentage(filtredvariations[index].mrp, filtredvariations[index].sellingPrice)}"
                                                " "
                                                "%",
                                                textAlign: TextAlign.center,
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  color: parseColor("FFFFFF"),
                                                  fontSize: 10,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              Text(
                                                "OFF",
                                                textAlign: TextAlign.center,
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  color: parseColor("FFFFFF"),
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
                            });
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: filtredvariations.length),
                    ),
                  ],
                ))),
      ],
    );
  }
}

Widget quantitycontrolbutton(
    {required ThemeData theme,
    required String variationid,
    required User? user,
    required String pincode,
    required ProductModel product,
    required String buttonbgcolor,
    required String buttontextcolor,
    required BuildContext ctx,
    required String qty}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: parseColor(buttonbgcolor),
        borderRadius: BorderRadius.circular(10)),
    child: Row(
      spacing: 3,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              ctx.read<CartBloc>().add(DecreaseCartQuantity(
                  pincode: pincode,
                  productRef: product.id,
                  userId: user!.uid,
                  variantId: variationid));
              ctx.read<CouponBloc>().add(ResetCoupons());
            },
            child: SizedBox(
                child: Center(
                    child: Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                  color: parseColor(buttontextcolor),
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
                  color: parseColor(buttontextcolor),
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
                  variantId: variationid));
              ctx.read<CouponBloc>().add(ResetCoupons());
            },
            child: SizedBox(
                child: Center(
              child: Icon(
                Icons.add,
                size: 28,
                color: parseColor(buttontextcolor),
              ),
            )),
          ),
        )
      ],
    ),
  );
}
