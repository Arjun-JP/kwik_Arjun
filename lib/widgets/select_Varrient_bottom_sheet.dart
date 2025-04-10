import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';

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
    final theme = Theme.of(context);
    return Container(
        // height: MediaQuery.of(context).size.height * .26,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: parseColor(widget.buttonBgColor), // Choose your color
                width: 2.0, // Thickness of the border
              ),
            ),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
            child: SizedBox(
              height: widget.product.variations.length * 80,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Image.network(
                            widget.product.productImages.first,
                            width: 50,
                            height: 80,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.productName,
                                maxLines: 2,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${widget.product.variations[index].mrp}",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.blueGrey),
                                  ),
                                  Text(
                                      "${widget.product.variations[index].sellingPrice}",
                                      style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                              List<CartProduct> cartItems = [];

                              if (state is CartUpdated) {
                                cartItems = state.cartItems;
                              }
                              return cartItems.any((element) =>
                                      element.productRef.id ==
                                          widget.product.id &&
                                      element.variant.id ==
                                          widget.product.variations[index].id)
                                  ? quantitycontrolbutton(
                                      theme: theme,
                                      product: widget.product,
                                      ctx: context,
                                      buttonbgcolor: widget.buttonBgColor,
                                      buttontextcolor: widget.buttontextcolor,
                                      qty: cartItems
                                          .firstWhere((element) =>
                                              element.productRef.id ==
                                              widget.product.id)
                                          .quantity
                                          .toString(),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        final firstVariation =
                                            widget.product.variations.first;

                                        context.read<CartBloc>().add(
                                              AddToCart(
                                                cartProduct: CartProduct(
                                                  productRef: widget.product,
                                                  variant: firstVariation,
                                                  quantity: 1,
                                                  pincode: "560003",
                                                  sellingPrice: firstVariation
                                                      .sellingPrice,
                                                  mrp: firstVariation.mrp,
                                                  buyingPrice: firstVariation
                                                      .buyingPrice,
                                                  inStock: true,
                                                  variationVisibility: true,
                                                  finalPrice: 0,
                                                  cartAddedDate: DateTime.now(),
                                                ),
                                                userId:
                                                    "s5ZdLnYhnVfAramtr7knGduOI872",
                                                productRef: widget.product.id,
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
                                        backgroundColor:
                                            parseColor(widget.buttonBgColor),
                                        minimumSize: const Size(152, 48),
                                      ),
                                      child: Text("Add",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: parseColor(
                                                widget.buttontextcolor),
                                          )),
                                    );
                            }),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const DottedDivider(),
                  itemCount: widget.product.variations.length),
            )));
  }
}

Widget quantitycontrolbutton(
    {required ThemeData theme,
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
                    color: parseColor(buttontextcolor),
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
                  pincode: "560003",
                  productRef: product.id,
                  userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                  variantId: product.variations.first.id));
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
