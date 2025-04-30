import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_bloc.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_event.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_state.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_event.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/wishlist_model.dart';
import 'package:kwik/pages/Address_management/location_search_page.dart';
import 'package:kwik/pages/product_details_page/product_details_page.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../widgets/navbar/navbar.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    print('initState called');
    Future.microtask(() {
      context
          .read<CartBloc>()
          .add(SyncCartWithServer(userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
      context
          .read<RecommendedProductsBloc>()
          .add(const FetchRecommendedProducts("null"));
    });
  }

  UniqueKey _rebuildKey = UniqueKey();
  final Razorpay _razorpay = Razorpay();

  void _forceRebuild() {
    setState(() {
      _rebuildKey = UniqueKey(); // Changing key forces full rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KeyedSubtree(
      key: _rebuildKey,
      child: Scaffold(
        backgroundColor: const Color(0xFFfbfafb),
        // backgroundColor: const Color.fromARGB(255, 201, 201, 201),
        appBar: AppBar(
            backgroundColor: const Color(0xFFfbfafb),
            elevation: 0,
            centerTitle: false,
            title: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              return state is CartUpdated &&
                      state.cartItems.isNotEmpty &&
                      state.charges != {}
                  ? Row(
                      children: [
                        const SizedBox(width: 15),
                        Text(
                          "Your Cart",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFD93C),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Text(
                                "Saved  ₹${(calculateTotalsaved(state.cartItems, state.charges)).toStringAsFixed(0)}",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontSize: 18)),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            })),
        body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            context.read<CartBloc>().add(
                SyncCartWithServer(userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
            return const Center(child: Text(""));
          } else if (state is CartInitial) {
            // Trigger loading when in initial state
            context.read<CartBloc>().add(
                SyncCartWithServer(userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartUpdated && state.cartItems.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  flex: 11,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        deliveryContainer(theme: theme),
                        deliveryTimeContainer(theme: theme),
                        const SizedBox(
                          height: 15,
                        ),
                        state.wishlist.isNotEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              const CartPage(),
                                          transitionDuration: Duration.zero,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Saved by You, Craved by Many",
                                      textAlign: TextAlign.left,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        //wishlist  products
                        state.wishlist.isNotEmpty
                            ? Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(10),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      wishlistProductItem(
                                          wishlistproduct:
                                              state.wishlist[index],
                                          theme: theme,
                                          qty: state.wishlist[index].productRef
                                              .variations
                                              .where(
                                                (element) =>
                                                    element.id ==
                                                    state.wishlist[index]
                                                        .variantId,
                                              )
                                              .toString()),
                                  separatorBuilder: (context, index) =>
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: SizedBox(
                                            height: 5,
                                          )),
                                  itemCount: state.wishlist.length,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Text(
                              "Picked by You, Packed for You",
                              textAlign: TextAlign.left,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        //cart products
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => cartproductItem(
                              cartproduct: state.cartItems[index],
                              theme: theme,
                              qty: state.cartItems[index].quantity.toString()),
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: DottedDivider(
                              color: Color.fromARGB(255, 198, 198, 198),
                            ),
                          ),
                          itemCount: state.cartItems.length,
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 390,
                          width: MediaQuery.of(context).size.width,
                          child: BlocBuilder<RecommendedProductsBloc,
                                  RecommendedProductsState>(
                              builder: (context, state) {
                            if (state is RecommendedProductLoading) {
                              return const Center(
                                  child: ProductModel1ListShimmer());
                            } else if (state is RecommendedProductLoaded) {
                              return state.products.isNotEmpty
                                  ? productsYouMightAlsoLike(
                                      theme: theme, productlist: state.products)
                                  : const SizedBox();
                            } else if (state is RecommendedProductError) {
                              return const Center(child: Text(""));
                            } else {
                              return const Center(child: Text(""));
                            }
                          }),
                        ),
                        const SizedBox(height: 15),
                        addMoreItem(theme: theme),
                        const SizedBox(height: 15),
                        selectDeliveryType(theme: theme),
                        const SizedBox(height: 15),
                        deliveryInstructions(theme: theme),
                        BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                          return billDetails(
                              theme: theme,
                              charges:
                                  state is CartUpdated ? state.charges : {},
                              cartproducts:
                                  state is CartUpdated ? state.cartItems : []);
                        }),
                        const SizedBox(height: 15),
                        addressContainer(theme: theme),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
                paymentOptions(
                    theme: theme,
                    charges: state.charges,
                    cartproducts: state.cartItems)
              ],
            );
          } else {
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          // padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                                width: 80,
                                height: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Your cart is feeling lonely! \nAdd something you love and we’ll bring it right to your doorstep.",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 390,
                                width: MediaQuery.of(context).size.width,
                                child: BlocBuilder<RecommendedProductsBloc,
                                        RecommendedProductsState>(
                                    builder: (context, state) {
                                  if (state is RecommendedProductLoading) {
                                    return const Center(
                                        child: ProductModel1ListShimmer());
                                  } else if (state
                                      is RecommendedProductLoaded) {
                                    return state.products.isNotEmpty
                                        ? productsYouMightAlsoLike(
                                            theme: theme,
                                            productlist: state.products)
                                        : const SizedBox();
                                  } else if (state is RecommendedProductError) {
                                    return const Center(child: Text(""));
                                  } else {
                                    return const Center(child: Text(""));
                                  }
                                }),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  context.go("/home");
                                  context
                                      .read<NavbarBloc>()
                                      .add(const UpdateNavBarIndex(0));
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  foregroundColor: AppColors.buttonColorOrange,
                                  backgroundColor: AppColors.buttonColorOrange,
                                ),
                                child: Text(
                                  "Find Your Favorites",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: AppColors.kwhiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
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
              ),
            );
          }
        }),
        bottomNavigationBar: const Navbar(),
      ),
    );
  }

  Widget deliveryContainer({required ThemeData theme}) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 236, 236, 236)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              print(generateIsoTime("10.30 AM - 11.30 AM"));
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFF),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                      width: 40, height: 40, "assets/images/pizza 1.png"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get FREE delivery",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 14, color: const Color(0xFF0743B2)),
                      ),
                      Text(
                        "Add products worth ₹102 more ",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  height: 25, width: 25, "assets/images/couponimage.png"),
              const SizedBox(width: 10),
              Text(
                "Add products worth ₹102 more ",
                style: theme.textTheme.bodyMedium,
              ),
              const Icon(
                Icons.arrow_right_rounded,
                size: 20,
              )
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget deliveryTimeContainer({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          Image.asset(width: 40, height: 40, "assets/images/clock_blue.png"),
          const SizedBox(width: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Delivery less then 20 mins",
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontSize: 14, color: const Color(0xFF0743B2)),
              ),
              Text(
                "Shipment of 3 items ",
                style: theme.textTheme.bodyMedium,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget cartproductItem({
    required ThemeData theme,
    required CartProduct cartproduct,
    required String qty,
  }) {
    return InkWell(
      onTap: () => context.push(
        '/productdetails',
        extra: {
          'product': cartproduct.productRef,
          'subcategoryref': cartproduct.productRef.subCategoryRef.first.id,
          'buttonbg': parseColor("E23338"), // example color as a string
          'buttontext': parseColor("FFFFFF"),
        },
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: Row(
          spacing: 15,
          children: [
            // Image Column
            Expanded(
              flex: 2,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  cartproduct.productRef.productImages.first,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Product Info Column
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cartproduct.productRef.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${cartproduct.variant.qty} ${cartproduct.variant.unit}",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 3),
                  InkWell(
                    onTap: () {
                      context.read<CartBloc>().add(AddToWishlistFromcart(
                          userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                          productref: cartproduct.productRef.id,
                          variationID: cartproduct.variant.id));
                    },
                    child: Text(
                      "Save for later",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            // Spacing between items

            // Quantity Control Column
            Expanded(
              flex: 3,
              child: quantitycontrolbutton(
                theme: theme,
                product: cartproduct.productRef,
                qty: qty,
              ),
            ),
            // Spacing between items

            // Price Column
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${(cartproduct.quantity * cartproduct.variant.sellingPrice).toStringAsFixed(0)}",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                    "₹${(cartproduct.quantity * cartproduct.variant.mrp).toStringAsFixed(0)}",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wishlistProductItem({
    required ThemeData theme,
    required WishlistItem wishlistproduct,
    required String qty,
  }) {
    return GestureDetector(
      onTap: () => context.push(
        '/productdetails',
        extra: {
          'product': wishlistproduct.productRef,
          'subcategoryref': wishlistproduct.productRef.subCategoryRef.first.id,
          'buttonbg': parseColor("E23338"), // example color as a string
          'buttontext': parseColor("FFFFFF"),
        },
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 255, 252, 229),
        ),
        child: Row(
          spacing: 15,
          children: [
            // Image Column
            Expanded(
              flex: 2,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  wishlistproduct.productRef.productImages.first,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Product Info Column
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wishlistproduct.productRef.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${wishlistproduct.productRef.variations.firstWhere((element) => element.id == wishlistproduct.variantId).qty} ${wishlistproduct.productRef.variations.firstWhere((element) => element.id == wishlistproduct.variantId).unit}",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            ),
            // Expanded(
            //     flex: 3,
            //     child: SizedBox(
            //       height: 30,
            //       child: ElevatedButton(
            //         onPressed: () {},
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor:
            //               const Color(0xFFE23338), // background color
            //           foregroundColor: Colors.white,
            //           // text color
            //           side: const BorderSide(
            //               color: Color(0xFFE23338), width: 1), // border
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(
            //                 8), // optional: rounded corners
            //           ),
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 10, vertical: 0), // optional: spacing
            //         ),
            //         child: Text(
            //           "Add",
            //           style: theme.textTheme.bodyLarge
            //               ?.copyWith(color: Colors.white),
            //         ),
            //       ),
            //     )),
            Expanded(
                flex: 3,
                child: SizedBox(
                  height: 30,
                  child: BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, addressstate) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(AddToCartFromWishlist(
                            userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                            wishlistID: wishlistproduct.id,
                            pincode: addressstate is LocationSearchResults
                                ? "560003"
                                //  extractAddressDetails(
                                //     addressstate.currentlocationaddress)["pin"]!
                                : "673541"));
                        // context.read<CartBloc>().add(SyncCartWithServer(
                        //     userId: "s5ZdLnYhnVfAramtr7knGduOI872"));

                        Future.microtask(() {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CartPage(), // Replace CartPage() with your actual page widget
                            ),
                          );
                        });
                        context.read<CartBloc>().add(SyncCartWithServer(
                            userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE23338), // background color
                        foregroundColor: Colors.white,
                        // text color
                        side: const BorderSide(
                            color: Color(0xFFE23338), width: 1), // border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // optional: rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0), // optional: spacing
                      ),
                      child: Text(
                        "Add",
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    );
                  }),
                )),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${wishlistproduct.productRef.variations.firstWhere((element) => element.id == wishlistproduct.variantId).sellingPrice.toStringAsFixed(0)}",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                    "₹${wishlistproduct.productRef.variations.firstWhere((element) => element.id == wishlistproduct.variantId).mrp.toStringAsFixed(0)}",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addMoreItem({required ThemeData theme}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border:
                Border.all(color: const Color.fromARGB(255, 239, 239, 239))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Missed something?",
              style: theme.textTheme.bodyMedium!.copyWith(fontSize: 14),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.go("/home");
                context.read<NavbarBloc>().add(const UpdateNavBarIndex(0));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ), // Your icon
              label: Text(
                "Add more item",
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontSize: 14, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF233D4D), // Background color
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ), // Button text
            )
          ],
        ),
      ),
    );
  }

  Widget selectDeliveryType({required ThemeData theme}) {
    return BlocBuilder<OrderManagementBloc, OrderManagementState>(
        builder: (context, state) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                "Delivery Options",
                style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
              ),
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<OrderManagementBloc>().add(
                            UpdateDeliveryType(
                                newDeliveryType: "instant", selectedSlot: '0'));
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: state is DeliveryTypeUpdated &&
                                state.deliveryType == "instant"
                            ? Colors.white
                            : Colors.black,
                      ), // Your icon
                      label: Text(
                        "Instant delivery",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 14,
                            color: state is DeliveryTypeUpdated &&
                                    state.deliveryType == "instant"
                                ? Colors.white
                                : Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state is DeliveryTypeUpdated &&
                                state.deliveryType == "instant"
                            ? const Color(0xFF8CCA97)
                            : const Color(0xFFF6F7F9), // Background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ), // Button text
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<OrderManagementBloc>().add(
                            UpdateDeliveryType(
                                newDeliveryType: "slot", selectedSlot: '0'));
                      },
                      icon: Icon(
                        Icons.add,
                        color: state is DeliveryTypeUpdated &&
                                state.deliveryType == "slot"
                            ? Colors.white
                            : Colors.black,
                      ), // Your icon
                      label: Text(
                        "Book a Slot",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 14,
                            color: state is DeliveryTypeUpdated &&
                                    state.deliveryType == "slot"
                                ? Colors.white
                                : Colors.black),
                      ),

                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: state is DeliveryTypeUpdated &&
                                state.deliveryType == "slot"
                            ? const Color(0xFF8CCA97)
                            : const Color(0xFFF6F7F9), // Background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ), // Button text
                    ),
                  )
                ],
              ),
              state is DeliveryTypeUpdated && state.deliveryType == "slot"
                  ? BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, addressstate) {
                      if (addressstate is LocationSearchResults) {
                        return SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 10,
                              children: List.generate(
                                generateDeliverySlots(
                                        startTimeISO: addressstate
                                            .warehouse.tumTumDeliveryStartTime,
                                        endTimeISO: addressstate
                                            .warehouse.tumTumDeliveryEndTime)
                                    .length,
                                (index) {
                                  List<DeliveryTimeSlot> deliverytimeslot =
                                      generateDeliverySlots(
                                          startTimeISO: addressstate.warehouse
                                              .tumTumDeliveryStartTime,
                                          endTimeISO: addressstate
                                              .warehouse.tumTumDeliveryEndTime);
                                  return InkWell(
                                    onTap: () {
                                      context.read<OrderManagementBloc>().add(
                                          UpdateDeliveryType(
                                              newDeliveryType: "slot",
                                              selectedSlot:
                                                  "${deliverytimeslot[index].startTime} - ${deliverytimeslot[index].endTime}"));
                                    },
                                    child: isHideTimePassed(
                                            deliverytimeslot[index].hideTime)
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: (state.deliveryType ==
                                                            "slot" &&
                                                        state.selectedslot ==
                                                            "${deliverytimeslot[index].startTime} - ${deliverytimeslot[index].endTime}")
                                                    ? const Color(
                                                        0xFF8CCA97) // Selected color
                                                    : const Color.fromARGB(
                                                        255, 255, 251, 240),
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 216, 216, 216))),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 8),
                                            child: Center(
                                              child: Text(
                                                "${deliverytimeslot[index].startTime} - ${deliverytimeslot[index].endTime}",
                                                style: theme.textTheme.bodyMedium!.copyWith(
                                                    color: (state.deliveryType ==
                                                                "slot" &&
                                                            state.selectedslot ==
                                                                "${deliverytimeslot[index].startTime} - ${deliverytimeslot[index].endTime}")
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: (state
                                                                    .deliveryType ==
                                                                "slot" &&
                                                            state.selectedslot ==
                                                                "${deliverytimeslot[index].startTime} - ${deliverytimeslot[index].endTime}")
                                                        ? FontWeight.w700
                                                        : FontWeight.w400),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Text("Update location");
                      }
                    })
                  : const SizedBox(),
            ],
          ));
    });
  }

  Widget deliveryInstructions({required ThemeData theme}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text(
              "Delivery Instructions",
              style: theme.textTheme.bodyLarge,
            ),
            leading: SvgPicture.asset("assets/images/instructions.svg",
                height: 40, width: 40),
            subtitle: Text(
              "Delivery partner will be notified",
              style: theme.textTheme.bodyMedium,
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(0)), // Removes the top & bottom lines
            collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    0)), // Ensures the collapsed state also has no lines
            onExpansionChanged: (expanded) {},
            children: [
              AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            maxLines: 2,
                            style: theme.textTheme.bodyMedium,
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: "Enter instructions",
                              labelStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xffA19DA3), width: .5)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xffA19DA3), width: .5)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xffA19DA3), width: .5)),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Expanded(
                        //     flex: 1,
                        //     child: ElevatedButton.icon(
                        //       onPressed: () {},
                        //       icon: const Icon(
                        //         Icons.add,
                        //         color: Colors.white,
                        //       ), // Your icon
                        //       label: Text(
                        //         "Add",
                        //         style: theme.textTheme.bodyMedium!.copyWith(
                        //             fontSize: 14, color: Colors.white),
                        //       ),
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor:
                        //             const Color(0xFF233D4D), // Background color
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 16, vertical: 12), // Padding
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(
                        //               8), // Rounded corners
                        //         ),
                        //       ), // Button text
                        //     )),
                      ],
                    ),
                  ))
            ],
          ),
          const SizedBox(height: 5),
          Dash(
            direction: Axis.horizontal,
            length: MediaQuery.of(context).size.width,
            dashLength: 5,
            dashGap: 5,
            dashColor: Colors.grey,
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text(
              "Delivery Partner Safety",
              style: theme.textTheme.bodyLarge,
            ),
            leading: SvgPicture.asset("assets/images/delivery_details.svg",
                height: 40, width: 40),
            subtitle: Text(
              "Learn more about how we ensue their safety",
              style: theme.textTheme.bodyMedium,
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(0)), // Removes the top & bottom lines
            collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    0)), // Ensures the collapsed state also has no lines
            onExpansionChanged: (expanded) {},
            children: [
              AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          "Here's How We Do It",
                          style: theme.textTheme.bodyLarge,
                        ),
                        Row(
                          spacing: 15,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.delivery_dining_outlined,
                                size: 24,
                                color: Color.fromARGB(255, 208, 25, 5),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                "Delivery partners ride safely at an average speed of 15kmph per delivery",
                                maxLines: 5,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 15,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.delivery_dining_outlined,
                                size: 24,
                                color: Color.fromARGB(255, 5, 107, 208),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                "No penalties for late deliveries & no oo incentives for on-time deliveries",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 15,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.delivery_dining_outlined,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                "Delivery partners are not informed about promised delivery time",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget billDetails(
      {required ThemeData theme,
      required List<CartProduct> cartproducts,
      required Map<String, dynamic> charges}) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 30, bottom: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            " Bill details",
            style: theme.textTheme.titleLarge!
                .copyWith(color: const Color(0xFF233D4D), fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    "assets/images/cartbill_1.svg",
                    height: 28,
                    width: 28,
                  )),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      "Items total",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14, color: const Color(0xFF233D4D)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 109, 205, 125)),
                      child: Text(
                        "Saved ₹${(calculateTotalMRP(cartproducts) - calculateTotalSellingPrice(cartproducts, charges)).toStringAsFixed(0)}",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      "₹${calculateTotalMRP(cartproducts).toStringAsFixed(0)}",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 13,
                          color: const Color(0xFFA19DA3)),
                    ),
                    Text(
                      "₹${calculateTotalSellingPrice(cartproducts, charges).toStringAsFixed(0)}",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF233D4D)),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    "assets/images/cartbill_2.svg",
                    height: 28,
                    width: 28,
                  )),
              Expanded(
                flex: 5,
                child: Text(
                  "Delivery charge",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 14, color: const Color(0xFF233D4D)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      (charges != {} && charges["delivery_charge"] != 0)
                          ? ""
                          : "₹30",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                          color: const Color(0xFFA19DA3)),
                    ),
                    Text(
                      (charges != {} && charges["delivery_charge"] != 0)
                          ? "₹${charges["delivery_charge"]}"
                          : "FREE",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color:
                              (charges != {} && charges["delivery_charge"] != 0)
                                  ? const Color(0xFF233D4D)
                                  : const Color(0xFF7DA5D9)),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    "assets/images/cartbill_3.svg",
                    height: 28,
                    width: 28,
                  )),
              Expanded(
                flex: 5,
                child: Text(
                  "Handling charge",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 14, color: const Color(0xFF233D4D)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      (charges != {} && charges["handling_charge"] != 0)
                          ? ""
                          : "₹20",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                          color: const Color(0xFFA19DA3)),
                    ),
                    Text(
                      (charges != {} && charges["handling_charge"] != 0)
                          ? "₹${charges["handling_charge"]}"
                          : "FREE",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          color:
                              (charges != {} && charges["handling_charge"] != 0)
                                  ? const Color(0xFF233D4D)
                                  : const Color(0xFF7DA5D9)),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    "assets/images/cartbill_4.svg",
                    height: 28,
                    width: 28,
                  )),
              Expanded(
                flex: 5,
                child: Text(
                  "High demand surge charge",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 14, color: const Color(0xFF233D4D)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      (charges != {} && charges["handling_charge"] != 0)
                          ? ""
                          : "₹40",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                          color: const Color(0xFFA19DA3)),
                    ),
                    Text(
                      (charges != {} && charges["handling_charge"] != 0)
                          ? "₹ ${charges["high_demand_charge"]}"
                          : "FREE",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: (charges != {} &&
                                  charges["high_demand_charge"] != 0)
                              ? const Color(0xFF233D4D)
                              : const Color(0xFF7DA5D9)),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(color: Color.fromARGB(255, 221, 221, 221)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand total",
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontSize: 18, color: const Color(0xFF233D4D)),
              ),
              Text(
                "₹${calculatetotal(cartproducts, charges).toStringAsFixed(0)}",
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontSize: 18, color: const Color(0xFF233D4D)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addressContainer({required ThemeData theme}) {
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      if (state is LocationSearchResults) {
        return state.selecteaddress != null
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                color: Colors.white,
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SvgPicture.asset("assets/images/home_logo.svg")),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivering to ${state.selecteaddress!.addressType}",
                            style: theme.textTheme.titleLarge!
                                .copyWith(fontSize: 12),
                          ),
                          Text(
                            "${state.selecteaddress!.floor}, ${state.selecteaddress!.flatNoName}, ${state.selecteaddress!.area}, ${state.selecteaddress!.landmark}, ${state.selecteaddress!.pincode},\n${state.selecteaddress!.phoneNo}",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 12, color: const Color(0xFFA19DA3)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LocationSearchPage(),
                          ));
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFD0F1C5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Center(
                              child: Text(
                            "Change",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 10, color: const Color(0xFF328616)),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                color: Colors.white,
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SvgPicture.asset("assets/images/home_logo.svg")),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivering to ${state.addresslist[0]!.addressType}",
                            style: theme.textTheme.titleLarge!
                                .copyWith(fontSize: 12),
                          ),
                          Text(
                            "${state.addresslist[0]!.floor}, ${state.addresslist[0]!.flatNoName}, ${state.addresslist[0]!.area}, ${state.addresslist[0]!.landmark}, ${state.addresslist[0]!.pincode},\n${state.addresslist[0]!.phoneNo}",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 12, color: const Color(0xFFA19DA3)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LocationSearchPage(),
                          ));
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFD0F1C5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Center(
                              child: Text(
                            "Change",
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 10, color: const Color(0xFF328616)),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget paymentOptions(
      {required ThemeData theme,
      required List<CartProduct> cartproducts,
      required Map<String, dynamic> charges}) {
    return BlocBuilder<OrderManagementBloc, OrderManagementState>(
        builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          spacing: 15,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To Pay",
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 12),
                ),
                Text(
                  "₹${calculatetotal(cartproducts, charges).toStringAsFixed(0)}",
                  style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
                ),
              ],
            ),
            Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    final Razorpay _razorpay = Razorpay();
                    _razorpay.on(
                        Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                    _razorpay.on(
                        Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                    _razorpay.on(
                        Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                    var options = {
                      'key':
                          'rzp_test_BQYhrtYkdExJNC', // Replace with your TEST key
                      'amount': (calculatetotal(cartproducts, charges)) *
                          100, // ₹100 (10000 paise)
                      'name': 'kwik groceries',
                      'description': 'Test Payment',
                      'prefill': {
                        'contact': '9876543210',
                        'email': 'test@example.com'
                      }
                    };

                    try {
                      _razorpay.open(options);
                    } catch (e) {
                      print('Error: $e');
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    elevation: .1,

                    backgroundColor: charges["enable_cod"]
                        ? const Color.fromARGB(255, 255, 240, 240)
                        : const Color(0xFFE23338), // Background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),

                  child: Text(
                    "Pay Online",
                    style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: charges["enable_cod"]
                            ? const Color(0xFF3F3F3F)
                            : Colors.white),
                  ), // Button text
                )),
            charges["enable_cod"]
                ? Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (state is DeliveryTypeUpdated &&
                            state.deliveryType == "instant") {
                        } else {
                          // state is DeliveryTypeUpdated ?state.selectedslot.
                          try {
                            HapticFeedback.mediumImpact();
                            context
                                .read<OrderManagementBloc>()
                                .add(PlaceOrder(orderJson: {
                                  "pincode": "560003",
                                  "user_ref": "s5ZdLnYhnVfAramtr7knGduOI872",
                                  "order_status": "Order placed",
                                  "otp": "123456",
                                  "order_placed_time":
                                      DateTime.now().toIso8601String(),
                                  "payment_type": "COD",
                                  "discount_price": 10,
                                  "type_of_delivery": "tum tum",
                                  "selected_time_slot": generateIsoTime(
                                      state is DeliveryTypeUpdated
                                          ? state.selectedslot
                                          : "10.30 AM - 11.30 AM"),
                                  "delivery_instructions": " intruction"
                                }));
                            context.go('/order-success');
                            context.read<CartBloc>().add(SyncCartWithServer(
                                userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const OrderSuccessPage(),
                            //   ),
                            //   (route) => false,
                            // );
                          } catch (error) {
                            // context.read<CartBloc>().add(SyncCartWithServer(
                            //     userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
                            print(error);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color(0xFFE23338), // Background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ),

                      child: Column(
                        children: [
                          Text(
                            "Pay Cash/UPI",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          Text(
                            "(On Delivery)",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ), // Button text
                    ))
                : const SizedBox(),
          ],
        ),
      );
    });
  }

  Widget quantitycontrolbutton(
      {required ThemeData theme,
      required ProductModel product,
      required String qty}) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      List<CartProduct> cartItems = [];

      if (state is CartUpdated) {
        cartItems = state.cartItems;
      }
      return Container(
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
        decoration: BoxDecoration(
            color: const Color(0xFFE23338),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          spacing: 2,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  context.read<CartBloc>().add(DecreaseCartQuantity(
                      pincode: "560003",
                      productRef: product.id,
                      userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                      variantId: product.variations.first.id));
                },
                child: SizedBox(
                  height: 25,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: SizedBox(
                    child: Center(
                  child: Text(
                    cartItems
                        .where((element) => element.productRef.id == product.id)
                        .first
                        .quantity
                        .toString(),
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                )),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  context.read<CartBloc>().add(IncreaseCartQuantity(
                      pincode: "560003",
                      productRef: product.id,
                      userId: "s5ZdLnYhnVfAramtr7knGduOI872",
                      variantId: product.variations.first.id));
                },
                child: const SizedBox(
                    height: 25,
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
    });
  }

  whishlistcontainer(
      {required ThemeData theme, required List<WishlistItem> wishlist}) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.amber,
      child: Column(
        children: List.generate(
          wishlist.length,
          (index) {
            return ListTile(
              leading:
                  Image.network(wishlist[index].productRef.productImages.first),
            );
          },
        ),
      ),
    );
  }
}

Widget productsYouMightAlsoLikeCart(
    {required ThemeData theme, required List<ProductModel> productlist}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    color: AppColors.kwhiteColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        const SizedBox(height: 15),
        Text("You might also like", style: theme.textTheme.titleMedium),
        SizedBox(
          height: 280,
          child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ProductItem(
                      subcategoryRef:
                          productlist[index].subCategoryRef.first.id,
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
                      ctx: context,
                      product: productlist[index]),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: productlist.length),
        ),
        const SizedBox(height: 20)
      ],
    ),
  );
}

double calculateTotalSellingPrice(
    List<CartProduct> cartList, Map<String, dynamic> charges) {
  double total = 0.0;
  for (var item in cartList) {
    total += item.sellingPrice * item.quantity;
  }
  return total;
}

double calculateTotalMRP(List<CartProduct> cartList) {
  double total = 0.0;
  for (var item in cartList) {
    total += item.mrp * item.quantity;
  }
  return total;
}

double calculatetotal(
    List<CartProduct> cartList, Map<String, dynamic> charges) {
  double total = 0.0;
  for (var item in cartList) {
    total += item.sellingPrice * item.quantity +
        charges["high_demand_charge"] +
        charges["handling_charge"] +
        charges["delivery_charge"];
  }
  return total;
}

double calculateTotalsaved(
    List<CartProduct> cartList, Map<String, dynamic> charges) {
  double mrp = 0.0;
  double sellingprice = 0.0;
  double savedcharges = 0.0;
  savedcharges = (charges["high_demand_charge"] == 0 ? 40.0 : 0.0) +
      (charges["handling_charge"] == 0 ? 20.0 : 0.0) +
      (charges["delivery_charge"] == 0 ? 30.0 : 0.0);

  for (var item in cartList) {
    mrp += item.mrp * item.quantity;
    sellingprice += item.sellingPrice * item.quantity;
  }
  return (mrp - sellingprice) + savedcharges;
}

class DeliveryTimeSlot {
  final String startTime;
  final String endTime;
  final DateTime hideTime;

  DeliveryTimeSlot({
    required this.startTime,
    required this.endTime,
    required this.hideTime,
  });

  @override
  String toString() =>
      '$startTime - $endTime (hide at ${_formatTime(hideTime)})';
}

List<DeliveryTimeSlot> generateDeliverySlots({
  required String startTimeISO,
  required String endTimeISO,
  int slotDurationMinutes = 60,
  int hideBeforeMinutes = 15,
}) {
  print(startTimeISO);
  print(endTimeISO);

  final now = DateTime.now();

  final startParsed = DateTime.parse(startTimeISO);
  final endParsed = DateTime.parse(endTimeISO);

  // Only take today's date but the time from parsed
  final start = DateTime(
    now.year,
    now.month,
    now.day,
    startParsed.hour,
    startParsed.minute,
  );
  final end = DateTime(
    now.year,
    now.month,
    now.day,
    endParsed.hour,
    endParsed.minute,
  );

  final slots = <DeliveryTimeSlot>[];

  DateTime currentStart = start;

  while (currentStart.isBefore(end)) {
    DateTime currentEnd =
        currentStart.add(Duration(minutes: slotDurationMinutes));
    if (currentEnd.isAfter(end)) {
      currentEnd = end;
    }

    final formattedStart = _formatTime(currentStart);
    final formattedEnd = _formatTime(currentEnd);

    final hideTime =
        currentStart.subtract(Duration(minutes: hideBeforeMinutes));

    slots.add(DeliveryTimeSlot(
      startTime: formattedStart,
      endTime: formattedEnd,
      hideTime: hideTime,
    ));

    currentStart = currentEnd;
  }

  print(slots);
  return slots;
}

String _formatTime(DateTime time) {
  final hour = time.hour;
  final minute = time.minute;

  // Handle 11.59 instead of 12 to avoid AM/PM confusion
  final displayHour = hour == 12
      ? 11.59
      : hour > 12
          ? hour - 12
          : hour;

  // Format minutes with leading zero if needed
  final minuteStr = minute < 10 ? '0$minute' : '$minute';

  // Handle display for times like 11.59
  if (displayHour == 11.59) {
    return minute == 0 ? '11.59 AM' : '11.$minuteStr AM';
  }

  // Handle display for times like 12.1 (which would be 12:06 PM)
  if (hour == 12 && minute > 0) {
    final decimalMinute = minute / 10;
    return '12.$decimalMinute PM';
  }

  // Standard formatting
  final period = hour < 12 ? 'AM' : 'PM';
  return '$displayHour.$minuteStr $period';
}

//to hide passed time slot
bool isHideTimePassed(DateTime hideTime) {
  final now = DateTime.now();

  // Create a time today from hideTime's hour and minute
  final hideTimeToday = DateTime(
    now.year,
    now.month,
    now.day,
    hideTime.hour,
    hideTime.minute,
  );

  // Now compare the current time with hideTimeToday
  return now.isAfter(hideTimeToday);
}

void _payNow() {
  final Razorpay _razorpay = Razorpay();
  var options = {
    'key': 'rzp_test_BQYhrtYkdExJNC', // Replace with your TEST key
    'amount': 10000, // ₹100 (10000 paise)
    'name': 'Kwik Store',
    'description': 'Test Payment',
    'prefill': {'contact': '9876543210', 'email': 'test@example.com'}
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    print('Error: $e');
  }
}

String generateIsoTime(String timeRange) {
  final now = DateTime.now();

  try {
    // Split the input by '-' and take the first part (start time)
    final startTimeString = timeRange.split('-').first.trim();

    // Parse the time string
    final format =
        DateFormat('hh.mm a'); // because your input has dot (10.30 AM)
    final parsedTime = format.parse(startTimeString);

    // Combine today's date with parsed time
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    print(dateTime.toIso8601String());
    return dateTime.toIso8601String();
  } catch (e) {
    print("Error parsing time string: $e");
    return "Invalid Time Format";
  }
}

void _handlePaymentSuccess(
    PaymentSuccessResponse response, BuildContext context) {
  print('Payment Success');
  print('Payment ID: ${response.paymentId}');
  print('Order ID: ${response.orderId}');
  print('Signature: ${response.signature}');

  // Here you get the paymentId — use it to verify payment status
}

void _handlePaymentError(PaymentFailureResponse response) {
  print('Payment Failed');
  print('Code: ${response.code}');
  print('Message: ${response.message}');
}

void _handleExternalWallet(ExternalWalletResponse response) {
  print('External Wallet selected: ${response.walletName}');
}
