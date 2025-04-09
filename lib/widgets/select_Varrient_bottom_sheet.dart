import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/variation_model.dart';
import 'package:kwik/pages/product_details_page/product_details_page.dart';

class SelectVarrientBottomSheet extends StatefulWidget {
  final ProductModel product;
  const SelectVarrientBottomSheet({super.key, required this.product});

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
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 166, 28, 28), // Choose your color
                width: 2.0, // Thickness of the border
              ),
            ),
            borderRadius: BorderRadius.only(
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
                                            AppColors.addToCartBorder,
                                        minimumSize: const Size(152, 48),
                                      ),
                                      child: const Text("Add",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
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
