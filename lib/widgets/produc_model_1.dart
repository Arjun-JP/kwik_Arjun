import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/cart_repo.dart';

class ProductItem extends StatelessWidget {
  final String subcategoryRef;
  final ProductModel product;
  final String name;
  final double price;
  final String imageurl;
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

  const ProductItem({
    super.key,
    required this.name,
    required this.price,
    required this.imageurl,
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

    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      List<CartProduct> cartItems = [];
      String productqty = "0";
      print(state);
      if (state is CartUpdated) {
        print(state.cartItems.length);
        // isInCart = state.cartItems.any((item) => item.productRef == product.id);
        cartItems = state.cartItems;
        productqty = state.cartItems
            .where((item) => item.productRef == product.id)
            .first
            .quantity
            .toString();
      }
      return InkWell(
        onTap: () => context.push(
          '/productdetails',
          extra: {
            'product': product,
            'subcategoryref': subcategoryRef,
          },
        ),
        child: SizedBox(
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
                      height: 170,
                      decoration: BoxDecoration(
                        color: parseColor("F9F9F9"),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: parseColor(unitbgcolor),
                          ),
                          child: Text(
                            "100 g",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: parseColor(unitTextcolor),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    // const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "₹ 45",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: parseColor(mrpColor),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              "₹ 85",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: parseColor(sellingPriceColor),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                          child: cartItems
                                  .where((element) =>
                                      element.productRef == product.id)
                                  .isNotEmpty
                              ? quantitycontrolbutton(
                                  theme: theme,
                                  product: product,
                                  qty: productqty)
                              : ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    context.read<CartBloc>().add(
                                          AddToCart(
                                            cartProduct: CartProduct(
                                                productRef: product.id,
                                                variant:
                                                    product.variations.first,
                                                quantity: product
                                                    .variations.first.qty,
                                                pincode: "560003",
                                                sellingPrice: product.variations
                                                    .first.sellingPrice,
                                                mrp: product
                                                    .variations.first.mrp,
                                                buyingPrice: product.variations
                                                    .first.buyingPrice,
                                                inStock: true,
                                                variationVisibility: true,
                                                finalPrice: 0,
                                                cartAddedDate: DateTime.now()),
                                            userId:
                                                "s5ZdLnYhnVfAramtr7knGduOI872",
                                            productRef: product.id,
                                            variantId:
                                                product.variations.first.id,
                                            pincode: "560003",
                                          ),
                                        );
                                    print("cartbuttonclicked");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: parseColor(buttonBgColor),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: parseColor(buttontextcolor)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  child: Text(
                                    'Add',
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: parseColor(buttontextcolor),
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
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
                        "30%",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: parseColor(offertextcolor),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w900,
                        ),
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
            ],
          ),
        ),
      );
    });
  }

  Widget quantitycontrolbutton(
      {required ThemeData theme,
      required ProductModel product,
      required String qty}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE23338),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        spacing: 2,
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              context.read<CartBloc>().add(DecreaseCartQuantity(
                  pincode: "560003",
                  productRef: product.id,
                  userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                  variantId: product.variations.first.id));
              print("cartbuttonclicked");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  child: Center(
                      child: Container(
                width: 12,
                height: 2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3)),
              ))),
            ),
          ),
          SizedBox(
              child: Center(
            child: Text(
              "1",
              style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800),
            ),
          )),
          InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              context.read<CartBloc>().add(IncreaseCartQuantity(
                  pincode: "560003",
                  productRef: product.id,
                  userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                  variantId: product.variations.first.id));
              print("cartbuttonclicked");
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: SizedBox(
                  child: Center(
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
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
