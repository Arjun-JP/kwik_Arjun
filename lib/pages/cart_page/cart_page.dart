import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/bloc/Coupon_bloc/Coupon_bloc.dart';
import 'package:kwik/bloc/Coupon_bloc/coupon_event.dart';
import 'package:kwik/bloc/Coupon_bloc/coupon_state.dart';
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
import 'package:kwik/pages/cart_page/updatecart_loadingpage.dart';
import 'package:kwik/pages/cart_page/wishlist_to_cart_bottom_sheet.dart';
import 'package:kwik/pages/cart_page/wishlist_transfer_bottomsheet.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/select_address_cart.dart';
import 'package:kwik/widgets/shimmer/product_model1_list.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../widgets/navbar/navbar.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _instructionsController = TextEditingController();
  late final Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _loadInitialData();
  }

  Future<void> refreshPage() async {
    await Future.delayed(Duration(milliseconds: 100));
    context.push('/cart'); // push cart again to rebuild
  }

  @override
  void dispose() {
    _razorpay.clear();
    _instructionsController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<CartBloc>().add(SyncCartWithServer(userId: userId));
      context
          .read<RecommendedProductsBloc>()
          .add(const FetchRecommendedProducts("null"));
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response, User user,
  //     String otp, String deliveryType, String selectedtimeSlot) {
  //   // Handle payment success
  //   context.read<OrderManagementBloc>().add(
  //         PlaceOrder(
  //           orderJson: {
  //             "pincode": "560003",
  //             "user_ref": user.uid,
  //             "order_status": "Order placed",
  //             "otp": otp,
  //             "order_placed_time": DateTime.now().toIso8601String(),
  //             "payment_type": "Online payment",
  //             "discount_price": 10,
  //             "type_of_delivery": "tum tum",
  //             "selected_time_slot": selectedtimeSlot,
  //             "delivery_instructions": _instructionsController.text
  //           },
  //         ),
  //       );
  // }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }
  Key _cartPageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFfbfafb),
      appBar: _buildAppBar(theme),
      body: BlocBuilder<CartBloc, CartState>(
        buildWhen: (previous, current) => current is CartUpdated,
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            if (user != null) {
              context
                  .read<CartBloc>()
                  .add(SyncCartWithServer(userId: user.uid));
            }
            return const Center(child: Text(""));
          } else if (state is CartUpdated) {
            return state.cartItems.isEmpty
                ? _buildEmptyCartView(theme)
                : _buildCartWithItems(theme, state, user);
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: const Navbar(),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: const Color(0xFFfbfafb),
      elevation: 0,
      centerTitle: false,
      title: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated &&
              state.cartItems.isNotEmpty &&
              state.charges.isNotEmpty) {
            return Row(
              children: [
                const SizedBox(width: 15),
                Text(
                  "Your Cart",
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD93C),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child:
                        BlocBuilder<OrderManagementBloc, OrderManagementState>(
                            builder: (context, orderstate) {
                      return BlocBuilder<CouponBloc, CouponState>(
                          builder: (context, couponstate) {
                        return Text(
                          "Saved ₹${((calculateTotalMRP(state.cartItems) - calculateTotalSellingPrice(state.cartItems, state.charges)) + (orderstate is DeliveryTypeUpdated && orderstate.deliveryType == "slot" && state.charges["delivery_charge_tum_tum"] == 0 ? 30 : 0) + (orderstate is DeliveryTypeUpdated && orderstate.deliveryType == "instant" && state.charges["delivery_charge"] == 0 ? 30 : 0 + (couponstate is CouponApplied ? couponstate.disAmount : 0.0))).toStringAsFixed(0)}",
                          // "Saved ₹${calculateTotalSaved(orderstate is DeliveryTypeUpdated ? orderstate.deliveryType : "", state.cartItems, state.charges).toStringAsFixed(0)}",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 18),
                        );
                      });
                    }),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyCartView(ThemeData theme) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/kwiklogo.png",
                      width: 80,
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Your cart is feeling lonely! \nAdd something you love and we'll bring it right to your doorstep.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
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
                                ? _buildRecommendedProducts(
                                    theme, state.products)
                                : const SizedBox();
                          } else if (state is RecommendedProductError) {
                            return const Center(child: Text(""));
                          }
                          return const Center(child: Text(""));
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go("/home");
                        context
                            .read<NavbarBloc>()
                            .add(const UpdateNavBarIndex(0));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
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
    );
  }

  Widget _buildCartWithItems(ThemeData theme, CartUpdated state, User? user) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDeliveryContainer(theme),
                _buildDeliveryTimeContainer(theme, state.cartItems.length),
                const SizedBox(height: 15),
                if (state.wishlist.isNotEmpty) ...[
                  _buildSectionTitle(theme, "Saved by You, Craved by Many"),
                  _buildWishlistItems(theme, state.wishlist, user),
                  const SizedBox(height: 15),
                ],
                _buildSectionTitle(theme, "Picked by You, Packed for You"),
                _buildCartItems(theme, state.cartItems, user),
                const SizedBox(height: 15),
                SizedBox(
                  height: 390,
                  width: MediaQuery.of(context).size.width,
                  child: BlocBuilder<RecommendedProductsBloc,
                      RecommendedProductsState>(
                    builder: (context, state) {
                      if (state is RecommendedProductLoading) {
                        return const Center(child: ProductModel1ListShimmer());
                      } else if (state is RecommendedProductLoaded) {
                        return state.products.isNotEmpty
                            ? _buildRecommendedProducts(theme, state.products)
                            : const SizedBox();
                      } else if (state is RecommendedProductError) {
                        return const Center(child: Text(""));
                      }
                      return const Center(child: Text(""));
                    },
                  ),
                ),
                const SizedBox(height: 15),
                _buildAddMoreItems(theme),
                const SizedBox(height: 15),
                _buildDeliveryTypeSelector(theme, state.charges),
                const SizedBox(height: 15),
                _buildDeliveryInstructions(theme),
                const SizedBox(height: 15),
                _coupons(theme),
                const SizedBox(height: 15),
                _buildBillDetails(
                  theme,
                  state.cartItems,
                  state.charges,
                ),
                const SizedBox(height: 15),
                _buildAddressContainer(theme),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        _buildPaymentOptions(theme, state.cartItems, state.charges, user,
            state.appliedcouponsmount),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildDeliveryContainer(ThemeData theme) {
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
            onTap: () => print(generateIsoTime("10.30 AM - 11.30 AM")),
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    width: 40,
                    height: 40,
                    "assets/images/pizza 1.png",
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Skip the lines, skip the traffic",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF0743B2),
                        ),
                      ),
                      Text(
                        "we deliver straight to you. ",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              context.push('/coupons');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  height: 25,
                  width: 25,
                  "assets/images/couponimage.png",
                ),
                const SizedBox(width: 10),
                Text(
                  "Don’t miss out! Check available coupons \nbefore you checkout. ",
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                ),
                const Icon(
                  Icons.arrow_right_rounded,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeContainer(ThemeData theme, int numberOfProducts) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          Image.asset(
            width: 40,
            height: 40,
            "assets/images/clock_blue.png",
          ),
          const SizedBox(width: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.68,
                child: Text(
                  "Don't wait! Book your delivery slot and get it when you need it",
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF0743B2),
                  ),
                ),
              ),
              Text(
                "Shipment of $numberOfProducts items ",
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItems(
      ThemeData theme, List<WishlistItem> wishlist, User? user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _buildWishlistItem(
          theme,
          wishlist[index],
          user,
        ),
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(height: 5),
        ),
        itemCount: wishlist.length,
      ),
    );
  }

  Widget _buildWishlistItem(ThemeData theme, WishlistItem item, User? user) {
    final variant = item.productRef.variations
        .firstWhere((element) => element.id == item.variantId);

    return GestureDetector(
      onTap: () => context.push(
        '/productdetails',
        extra: {
          'product': item.productRef,
          'subcategoryref': item.productRef.subCategoryRef.first.id,
          'buttonbg': parseColor("E23338"),
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
            Expanded(
              flex: 2,
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    item.productRef.productImages.first,
                    fit: BoxFit.contain,
                  )),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.productRef.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${variant.qty} ${variant.unit}",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 30,
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, addressState) {
                    return ElevatedButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () => FocusScope.of(context).unfocus(),
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: MovetoCart(
                                    pincode:
                                        addressState is LocationSearchResults
                                            ? addressState.pincode
                                            : "000000",
                                    wishlistid: item.id),
                              ),
                            );
                          },
                        );
                        // if (user != null) {
                        //   context.read<CartBloc>().add(AddToCartFromWishlist(
                        //         userId: user.uid,
                        //         wishlistID: item.id,
                        //         pincode: addressState is LocationSearchResults
                        //             ? addressState.pincode
                        //             : "000000",
                        //       ));
                        //   context
                        //       .read<CartBloc>()
                        //       .add(SyncCartWithServer(userId: user.uid));
                        //   context.read<CouponBloc>().add(ResetCoupons());
                        //   // context.pushReplacement('/cart');
                        //  }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE23338),
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xFFE23338), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                      ),
                      child: Text(
                        "Add",
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${variant.sellingPrice.toStringAsFixed(0)}",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                    "₹${variant.mrp.toStringAsFixed(0)}",
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

  Widget _buildCartItems(
      ThemeData theme, List<CartProduct> cartItems, User? user) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildCartItem(
        theme,
        cartItems[index],
        user,
      ),
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DottedDivider(
          color: Color.fromARGB(255, 198, 198, 198),
        ),
      ),
      itemCount: cartItems.length,
    );
  }

  Widget _buildCartItem(ThemeData theme, CartProduct item, User? user) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, addressState) {
        if (addressState is LocationSearchResults) {
          final warehouseId = addressState.warehouse!.id;
          final isOutOfStock = item.productRef.variations.length == 1 &&
              (item.productRef.variations
                      .where((element) => element.id == item.variant.id)
                      .first
                      .stock
                      .where((element) => element.warehouseRef == warehouseId)
                      .isEmpty ||
                  item.productRef.variations.first.stock
                          .where(
                              (element) => element.warehouseRef == warehouseId)
                          .first
                          .stockQty ==
                      0);

          return Opacity(
            opacity: isOutOfStock ? 0.5 : 1,
            child: InkWell(
              onTap: () => context.push(
                '/productdetails',
                extra: {
                  'product': item.productRef,
                  'subcategoryref': item.productRef.subCategoryRef.first.id,
                  'buttonbg': parseColor("E23338"),
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
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          item.productRef.productImages.first,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.productRef.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${item.variant.qty} ${item.variant.unit}",
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 3),
                          InkWell(
                            onTap: () async {
                              if (user != null) {
                                bool refresh = await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: Movetowishlist(
                                            productref: item.productRef.id,
                                            variationID: item.variant.id),
                                      ),
                                    );
                                  },
                                );
                                if (refresh) {
                                  print("its true");
                                  refreshPage();
                                } else {
                                  print("its not true");
                                }
                                // context.read<CartBloc>().add(
                                //       AddToWishlistFromcart(
                                //         userId: user.uid,
                                //         productref: item.productRef.id,
                                //         variationID: item.variant.id,
                                //       ),
                                //     );
                                // context.read<CartBloc>().add(
                                //       SyncCartWithServer(userId: user.uid),
                                //     );
                                // context.read<CouponBloc>().add(ResetCoupons());
                                // context.pushReplacement('/cart');
                              }
                            },
                            child: Text(
                              "Save for later",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildQuantityControl(
                          theme,
                          item.productRef,
                          item.quantity.toString(),
                          user,
                          item.variant.id,
                          addressState.pincode),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${(item.quantity * item.variant.sellingPrice).toStringAsFixed(0)}",
                            style: theme.textTheme.bodyLarge,
                          ),
                          Text(
                            "₹${(item.quantity * item.variant.mrp).toStringAsFixed(0)}",
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
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildQuantityControl(ThemeData theme, ProductModel product,
      String qty, User? user, String variationID, String pincode) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        List<CartProduct> cartItems =
            state is CartUpdated ? state.cartItems : [];
        final currentItem = cartItems.firstWhere((element) =>
            (element.productRef.id == product.id &&
                element.variant.id == variationID));

        return Container(
          height: 30,
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE23338),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            spacing: 2,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (user != null) {
                      context.read<CartBloc>().add(
                            DecreaseCartQuantity(
                              pincode: pincode,
                              productRef: product.id,
                              userId: user.uid,
                              variantId: variationID,
                            ),
                          );
                      context.read<CouponBloc>().add(ResetCoupons());
                      context.read<CouponBloc>().add(FetchAllCoupons());
                    }
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
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Center(
                    child: Text(
                      currentItem.quantity.toString(),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (user != null) {
                      context.read<CartBloc>().add(
                            IncreaseCartQuantity(
                              pincode: pincode,
                              productRef: product.id,
                              userId: user.uid,
                              variantId: variationID,
                            ),
                          );
                      context.read<CouponBloc>().add(ResetCoupons());
                      context.read<CouponBloc>().add(FetchAllCoupons());
                    }
                  },
                  child: const SizedBox(
                    height: 25,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendedProducts(
      ThemeData theme, List<ProductModel> products) {
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
                    subcategoryRef: products[index].subCategoryRef.first.id,
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
                    product: products[index],
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAddMoreItems(ThemeData theme) {
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
          border: Border.all(color: const Color.fromARGB(255, 239, 239, 239)),
        ),
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
              ),
              label: Text(
                "Add more item",
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF233D4D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTypeSelector(
      ThemeData theme, Map<String, dynamic> charges) {
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
                  charges["enable_Instant_Delivery"]
                      ? Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<OrderManagementBloc>().add(
                                    UpdateDeliveryType(
                                      newDeliveryType: "instant",
                                      selectedSlot: '0',
                                    ),
                                  );
                            },
                            icon: Icon(
                              Icons.check_circle,
                              color: state is DeliveryTypeUpdated &&
                                      state.deliveryType == "instant"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            label: Text(
                              "Instant delivery",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: state is DeliveryTypeUpdated &&
                                        state.deliveryType == "instant"
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: state is DeliveryTypeUpdated &&
                                      state.deliveryType == "instant"
                                  ? const Color(0xFF318616)
                                  : const Color(0xFFF6F7F9),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<OrderManagementBloc>().add(
                              UpdateDeliveryType(
                                newDeliveryType: "slot",
                                selectedSlot: '0',
                              ),
                            );
                      },
                      icon: Icon(
                        Icons.add,
                        color: state is DeliveryTypeUpdated &&
                                state.deliveryType == "slot"
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Book a Slot",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          color: state is DeliveryTypeUpdated &&
                                  state.deliveryType == "slot"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: state is DeliveryTypeUpdated &&
                                state.deliveryType == "slot"
                            ? const Color(0xFF318616)
                            : const Color(0xFFF6F7F9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (state is DeliveryTypeUpdated && state.deliveryType == "slot")
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, addressState) {
                    if (addressState is LocationSearchResults) {
                      final deliverySlots = generateDeliverySlots(
                        startTimeISO:
                            addressState.warehouse!.tumTumDeliveryStartTime,
                        endTimeISO:
                            addressState.warehouse!.tumTumDeliveryEndTime,
                      );

                      return InkWell(
                        onTap: () {
                          print(addressState.warehouse!.managerName);
                          print(addressState.warehouse!.warehouseAddress);
                          print(
                              addressState.warehouse!.tumTumDeliveryStartTime);
                          print(addressState.warehouse!.tumTumDeliveryEndTime);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: deliverySlots.map((slot) {
                                return !isHideTimePassed(slot.hideTime)
                                    ? InkWell(
                                        onTap: () {
                                          context
                                              .read<OrderManagementBloc>()
                                              .add(
                                                UpdateDeliveryType(
                                                  newDeliveryType: "slot",
                                                  selectedSlot:
                                                      "${slot.startTime} - ${slot.endTime}",
                                                ),
                                              );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: (state.deliveryType ==
                                                        "slot" &&
                                                    state.selectedslot ==
                                                        "${slot.startTime} - ${slot.endTime}")
                                                ? const Color(0xFF318616)
                                                : const Color.fromARGB(
                                                    255, 255, 251, 240),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 216, 216, 216)),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          child: Center(
                                            child: Text(
                                              "${slot.startTime} - ${slot.endTime}",
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                color: (state.deliveryType ==
                                                            "slot" &&
                                                        state.selectedslot ==
                                                            "${slot.startTime} - ${slot.endTime}")
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: (state
                                                                .deliveryType ==
                                                            "slot" &&
                                                        state.selectedslot ==
                                                            "${slot.startTime} - ${slot.endTime}")
                                                    ? FontWeight.w700
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    }
                    return const Text("Update location");
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliveryInstructions(ThemeData theme) {
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
            leading: SvgPicture.asset(
              "assets/images/instructions.svg",
              height: 25,
              width: 25,
            ),
            subtitle: Text(
              "Delivery partner will be notified",
              style: theme.textTheme.bodyMedium,
            ),
            shape: const RoundedRectangleBorder(),
            collapsedShape: const RoundedRectangleBorder(),
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
                          controller: _instructionsController,
                          decoration: const InputDecoration(
                            labelText: "Enter instructions",
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xffA19DA3),
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xffA19DA3),
                                width: 0.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xffA19DA3),
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            leading: SvgPicture.asset(
              "assets/images/delivery_details.svg",
              height: 25,
              width: 25,
            ),
            subtitle: Text(
              "Learn more about how we ensue their safety",
              style: theme.textTheme.bodyMedium,
            ),
            shape: const RoundedRectangleBorder(),
            collapsedShape: const RoundedRectangleBorder(),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _coupons(ThemeData theme) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/coupons');
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ListTile(
          leading: SvgPicture.asset("assets/images/offer_selected.svg"),
          title: Text(
            "Use Coupons",
            style: theme.textTheme.bodyLarge,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildBillDetails(ThemeData theme, List<CartProduct> cartItems,
      Map<String, dynamic> charges) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 20),
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
                  height: 20,
                  width: 20,
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      "Items total",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF233D4D),
                      ),
                    ),
                    BlocBuilder<OrderManagementBloc, OrderManagementState>(
                        builder: (context, orderstate) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 109, 205, 125),
                        ),
                        child: BlocBuilder<CouponBloc, CouponState>(
                            builder: (context, couponstate) {
                          return Text(
                            "Saved ₹${((calculateTotalMRP(cartItems) - calculateTotalSellingPrice(cartItems, charges)) + (orderstate is DeliveryTypeUpdated && orderstate.deliveryType == "slot" && charges["delivery_charge_tum_tum"] == 0 ? 30 : 0) + (orderstate is DeliveryTypeUpdated && orderstate.deliveryType == "instant" && charges["delivery_charge"] == 0 ? 30 : 0 + 0 + (couponstate is CouponApplied ? couponstate.disAmount : 0.0))).toStringAsFixed(0)}",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.white),
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      "₹${calculateTotalMRP(cartItems).toStringAsFixed(0)}",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                        color: const Color(0xFFA19DA3),
                      ),
                    ),
                    Text(
                      "₹${calculateTotalSellingPrice(cartItems, charges).toStringAsFixed(0)}",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: const Color(0xFF233D4D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          BlocBuilder<OrderManagementBloc, OrderManagementState>(
              builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    "assets/images/cartbill_2.svg",
                    height: 20,
                    width: 20,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "Delivery charge",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      color: const Color(0xFF233D4D),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      state is DeliveryTypeUpdated &&
                              state.deliveryType == "instant"
                          ? Text(
                              (charges.isNotEmpty &&
                                      charges["delivery_charge"] != 0)
                                  ? ""
                                  : "₹30",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                color: const Color(0xFFA19DA3),
                              ),
                            )
                          : Text(
                              (charges.isNotEmpty &&
                                      charges["delivery_charge_tum_tum"] != 0)
                                  ? ""
                                  : "₹30",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFA19DA3),
                              ),
                            ),
                      Text(
                        (charges.isNotEmpty &&
                                charges["delivery_charge"] != 0 &&
                                state is DeliveryTypeUpdated &&
                                state.deliveryType == "slot")
                            ? "₹${charges["delivery_charge_tum_tum"]}"
                            : (charges.isNotEmpty &&
                                    charges["delivery_charge"] != 0 &&
                                    state is DeliveryTypeUpdated &&
                                    state.deliveryType == "instant")
                                ? "₹${charges["delivery_charge"]}"
                                : "FREE",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: (charges.isNotEmpty &&
                                      state is DeliveryTypeUpdated &&
                                      state.deliveryType == "instant" &&
                                      charges["delivery_charge"] != 0) ||
                                  (charges.isNotEmpty &&
                                      state is DeliveryTypeUpdated &&
                                      state.deliveryType == "slot" &&
                                      charges["delivery_charge_tum_tum"] != 0)
                              ? const Color(0xFF233D4D)
                              : const Color(0xFF7DA5D9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/cartbill_3.svg",
                  height: 20,
                  width: 20,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "Handling charge",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF233D4D),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      (charges.isNotEmpty && charges["handling_charge"] != 0)
                          ? ""
                          : "₹20",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFA19DA3),
                      ),
                    ),
                    Text(
                      (charges.isNotEmpty && charges["handling_charge"] != 0)
                          ? "₹${charges["handling_charge"]}"
                          : "FREE",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: (charges.isNotEmpty &&
                                charges["handling_charge"] != 0)
                            ? const Color(0xFF233D4D)
                            : const Color(0xFF7DA5D9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/cartbill_4.svg",
                  height: 20,
                  width: 20,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "High demand surge charge",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF233D4D),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Text(
                      (charges.isNotEmpty && charges["handling_charge"] != 0)
                          ? ""
                          : "₹40",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFA19DA3),
                      ),
                    ),
                    Text(
                      (charges.isNotEmpty && charges["handling_charge"] != 0)
                          ? "₹ ${charges["high_demand_charge"]}"
                          : "FREE",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: (charges.isNotEmpty &&
                                charges["high_demand_charge"] != 0)
                            ? const Color(0xFF233D4D)
                            : const Color(0xFF7DA5D9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: Icon(Icons.offline_bolt_rounded),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "Coupon Discount ",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF233D4D),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    BlocBuilder<CouponBloc, CouponState>(
                        builder: (context, couponstate) {
                      return Text(
                        couponstate is CouponApplied
                            ? couponstate.disAmount.toStringAsFixed(0)
                            : "0",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF233D4D),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Color.fromARGB(255, 221, 221, 221)),
          BlocBuilder<OrderManagementBloc, OrderManagementState>(
              builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Grand total",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    color: const Color(0xFF233D4D),
                  ),
                ),
                BlocBuilder<CouponBloc, CouponState>(
                    builder: (context, couponstate) {
                  return Text(
                    "₹${(calculateTotal((state is DeliveryTypeUpdated) ? state.deliveryType : "", cartItems, charges, (couponstate is CouponApplied ? couponstate.disAmount : 0))).toStringAsFixed(0)}",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: const Color(0xFF233D4D),
                    ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddressContainer(ThemeData theme) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is LocationSearchResults) {
          final address = state.selecteaddress ??
              (state.addresslist.isNotEmpty ? state.addresslist[0] : null);

          if (address != null) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              color: Colors.white,
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    flex: 2,
                    child: SvgPicture.asset("assets/images/home_logo.svg"),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivering to ${address.addressType}",
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontSize: 12),
                        ),
                        Text(
                          "${address.floor}, ${address.flatNoName}, ${address.area}, ${address.landmark}, ${address.pincode},\n${address.phoneNo}",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 12,
                            color: const Color(0xFFA19DA3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const AddressSelectionBottomSheet();
                          },
                        );
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
                              fontSize: 10,
                              color: const Color(0xFF328616),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return InkWell(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const AddressSelectionBottomSheet();
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              color: Colors.white,
              child: Center(
                child: Text(
                  "Add address",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.redAccent),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPaymentOptions(
    ThemeData theme,
    List<CartProduct> cartItems,
    Map<String, dynamic> charges,
    User? user,
    double couponamount,
  ) {
    return BlocBuilder<OrderManagementBloc, OrderManagementState>(
      builder: (context, orderState) {
        return BlocBuilder<AddressBloc, AddressState>(
            builder: (context, addressState) {
          return BlocListener<OrderManagementBloc, OrderManagementState>(
              listener: (context, state) {
            if (state is OrderPlacedOnline) {
              var options = {
                'key': dotenv.env['RAZORPAY_APIKEY']!,
                'name': 'kwik groceries',
                'order_id': state.orderResponse["razorpayOrderId"],
                'description': 'Test Payment',
                'prefill': {
                  'contact': user!.phoneNumber,
                  'email': 'test@example.com'
                }
              };
              context.go('/check-payment-status',
                  extra: state.orderResponse["razorpayOrderId"]);
              // Initialize Razorpay here and open the checkout
              Razorpay razorpay = Razorpay();
              razorpay.open(options);

              // Optional: Add event handlers if needed
              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                  (PaymentSuccessResponse response) {
                print("Payment Success: $response");
              });
              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                  (PaymentFailureResponse response) {
                print("Payment Error: $response");
              });
              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                  (ExternalWalletResponse response) {
                print("External Wallet: $response");
              });
            } else if (state is OrderPlaced) {
              context.go('/order-processing');
            }
          }, child: Builder(builder: (context) {
            return BlocBuilder<OrderManagementBloc, OrderManagementState>(
                builder: (context, createorderstate) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 12),
                        ),
                        BlocBuilder<CouponBloc, CouponState>(
                            builder: (context, couponstate) {
                          return Text(
                            "₹${calculateTotal(orderState is DeliveryTypeUpdated ? orderState.deliveryType : "", cartItems, charges, (couponstate is CouponApplied ? couponstate.disAmount : 0.0)).toStringAsFixed(0)}",
                            style: theme.textTheme.titleLarge!
                                .copyWith(fontSize: 16),
                          );
                        }),
                      ],
                    ),
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<CouponBloc, CouponState>(
                          builder: (context, couponstate) {
                        return ElevatedButton(
                          onPressed: () {
                            if (addressState is LocationSearchResults &&
                                addressState.selecteaddress != null) {
                              if (orderState is DeliveryTypeUpdated) {
                                print(orderState.deliveryType);
                                if (orderState.deliveryType == 'slot') {
                                  context.read<OrderManagementBloc>().add(
                                        CreateorderOnlinePayment(orderJson: {
                                          "pincode": addressState
                                                  is LocationSearchResults
                                              ? addressState.pincode
                                              : "000000",
                                          "user_ref": user!.uid,
                                          "order_status": "Order placed",
                                          "otp": generateRandomOTP(),
                                          "order_placed_time":
                                              DateTime.now().toIso8601String(),
                                          "payment_type": "Online payment",
                                          "discount_price":
                                              couponstate is CouponApplied
                                                  ? couponstate.disAmount
                                                  : 0.0,
                                          "type_of_delivery": "tum tum",
                                          "coupon_code":
                                              couponstate is CouponApplied
                                                  ? couponstate.couponCode
                                                  : "null",
                                          "selected_time_slot":
                                              convertTimeStringToISO(
                                            orderState is DeliveryTypeUpdated
                                                ? orderState.selectedslot
                                                : "00.00",
                                          ),
                                          "delivery_instructions":
                                              _instructionsController.text
                                        }, uid: user.uid),
                                      );
                                } else if (orderState.deliveryType ==
                                    "instant") {
                                  print(createorderstate);
                                  context.read<OrderManagementBloc>().add(
                                        CreateorderOnlinePayment(orderJson: {
                                          "pincode": addressState
                                                  is LocationSearchResults
                                              ? addressState.pincode
                                              : "000000",
                                          "user_ref": user!.uid,
                                          "order_status": "Order placed",
                                          "otp": generateRandomOTP(),
                                          "order_placed_time":
                                              DateTime.now().toIso8601String(),
                                          "payment_type": "Online payment",
                                          "discount_price":
                                              couponstate is CouponApplied
                                                  ? couponstate.disAmount
                                                  : 0.0,
                                          "type_of_delivery": "instant",
                                          "coupon_code":
                                              couponstate is CouponApplied
                                                  ? couponstate.couponCode
                                                  : "null",
                                          "delivery_instructions":
                                              _instructionsController.text
                                        }, uid: user.uid),
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("select delivery type")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("select delivery type")));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("select Delivery Address")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0.1,
                            backgroundColor: charges["enable_cod"]
                                ? const Color.fromARGB(255, 255, 240, 240)
                                : const Color(0xFFE23338),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Pay Online",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: charges["enable_cod"]
                                  ? const Color(0xFF3F3F3F)
                                  : Colors.white,
                            ),
                          ),
                        );
                      }),
                    ),
                    if (charges["enable_cod"])
                      BlocBuilder<CouponBloc, CouponState>(
                          builder: (context, couponstate) {
                        return Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              if (addressState is LocationSearchResults &&
                                  addressState.selecteaddress != null) {
                                HapticFeedback.mediumImpact();
                                if (orderState is DeliveryTypeUpdated) {
                                  if (orderState.deliveryType == 'slot') {
                                    context.read<OrderManagementBloc>().add(
                                          PlaceOrder(
                                            orderJson: {
                                              "pincode": addressState
                                                      is LocationSearchResults
                                                  ? addressState.pincode
                                                  : "000000",
                                              "user_ref": user!.uid,
                                              "order_status": "Order placed",
                                              "otp": generateRandomOTP(),
                                              "order_placed_time":
                                                  DateTime.now()
                                                      .toIso8601String(),
                                              "payment_type": "COD",
                                              "discount_price":
                                                  couponstate is CouponApplied
                                                      ? couponstate.disAmount
                                                      : 0.0,
                                              "type_of_delivery": "tum tum",
                                              "coupon_code":
                                                  couponstate is CouponApplied
                                                      ? couponstate.couponCode
                                                      : "null",
                                              "selected_time_slot":
                                                  convertTimeStringToISO(
                                                orderState
                                                        is DeliveryTypeUpdated
                                                    ? orderState.selectedslot
                                                    : "00.00",
                                              ),
                                              "delivery_instructions":
                                                  _instructionsController.text
                                            },
                                          ),
                                        );
                                  } else if (orderState.deliveryType ==
                                      "instant") {
                                    context.read<OrderManagementBloc>().add(
                                          PlaceOrder(
                                            orderJson: {
                                              "pincode": addressState
                                                      is LocationSearchResults
                                                  ? addressState.pincode
                                                  : "000000",
                                              "user_ref": user!.uid,
                                              "order_status": "Order placed",
                                              "otp": generateRandomOTP(),
                                              "order_placed_time":
                                                  DateTime.now()
                                                      .toIso8601String(),
                                              "payment_type": "COD",
                                              "coupon_code":
                                                  couponstate is CouponApplied
                                                      ? couponstate.couponCode
                                                      : "null",
                                              "discount_price":
                                                  couponstate is CouponApplied
                                                      ? couponstate.disAmount
                                                      : 0.0,
                                              "type_of_delivery": "instant",
                                              "delivery_instructions":
                                                  _instructionsController.text
                                            },
                                          ),
                                        );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("select delivery type")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("select Delivery Address")));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFE23338),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Column(
                              children: [
                                createorderstate is OrderPlacing
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "Pay Cash/UPI",
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                Text(
                                  "(On Delivery)",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              );
            });
          }));
        });
      },
    );
  }
}

double calculateTotalSellingPrice(
    List<CartProduct> cartList, Map<String, dynamic> charges) {
  return cartList.fold(
      0.0, (sum, item) => sum + (item.sellingPrice * item.quantity));
}

double calculateTotalMRP(List<CartProduct> cartList) {
  return cartList.fold(0.0, (sum, item) => sum + (item.mrp * item.quantity));
}

double calculateTotal(String type, List<CartProduct> cartList,
    Map<String, dynamic> charges, double couponDis) {
  return calculateTotalSellingPrice(cartList, charges) +
      (charges["high_demand_charge"] ?? 0) +
      (charges["handling_charge"] ?? 0) +
      ((type == "slot")
          ? charges["delivery_charge_tum_tum"]
          : charges["delivery_charge"] ?? 0) -
      couponDis;
}

double calculateTotalSaved(String type, List<CartProduct> cartList,
    Map<String, dynamic> charges, double couponamount) {
  final mrp = calculateTotalMRP(cartList);
  final sellingPrice = calculateTotalSellingPrice(cartList, charges);
  final savedCharges = (charges["high_demand_charge"] == 0 ? 40.0 : 0.0) +
      (charges["handling_charge"] == 0 ? 20.0 : 0.0) +
      ((type == "slot")
          ? charges["delivery_charge_tum_tum"]
          : charges["delivery_charge"] ?? 0);

  return (mrp - sellingPrice) + savedCharges;
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

String _formatTime(DateTime time) {
  return DateFormat('hh:mm a').format(time);
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
  final startParsedUTC = DateTime.parse(startTimeISO);
  final endParsedUTC = DateTime.parse(endTimeISO);

  // Convert UTC times to local (IST or system timezone)
  final startParsedLocal = startParsedUTC.toLocal();
  final endParsedLocal = endParsedUTC.toLocal();

  // Use the current date with the times from startTimeISO and endTimeISO
  final dayStart = DateTime(
    now.year,
    now.month,
    now.day,
    startParsedLocal.hour,
    startParsedLocal.minute,
  );
  DateTime dayEnd = DateTime(
    now.year,
    now.month,
    now.day,
    endParsedLocal.hour,
    endParsedLocal.minute,
  );

  // If end time is before start time, assume it's on the next day
  if (dayEnd.isBefore(dayStart)) {
    dayEnd = dayEnd.add(Duration(days: 1));
  }

  final List<DeliveryTimeSlot> slots = [];
  DateTime currentSlotStart = dayStart;

  // Generate slots for the day, within the calculated dayStart and dayEnd
  while (currentSlotStart.isBefore(dayEnd)) {
    DateTime currentSlotEnd =
        currentSlotStart.add(Duration(minutes: slotDurationMinutes));
    if (currentSlotEnd.isAfter(dayEnd)) {
      currentSlotEnd = dayEnd;
    }

    final formattedStart = _formatTime(currentSlotStart);
    final formattedEnd = _formatTime(currentSlotEnd);
    final hideTime =
        currentSlotStart.subtract(Duration(minutes: hideBeforeMinutes));

    slots.add(DeliveryTimeSlot(
      startTime: formattedStart,
      endTime: formattedEnd,
      hideTime: hideTime,
    ));

    currentSlotStart = currentSlotEnd;
  }

  print(slots);
  return slots;
}

String _formatTimes(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour < 12 ? 'AM' : 'PM';
  final displayHour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  return '$displayHour:$minute $period';
}

bool isHideTimePassed(DateTime hideTime) {
  final now = DateTime.now();
  final hideTimeToday = DateTime(
    now.year,
    now.month,
    now.day,
    hideTime.hour,
    hideTime.minute,
  );
  return now.isAfter(hideTimeToday);
}

String generateIsoTime(String timeRange) {
  final now = DateTime.now();

  try {
    final startTimeString = timeRange.split('-').first.trim();
    final format = DateFormat('hh.mm a');
    final parsedTime = format.parse(startTimeString);

    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    return dateTime.toIso8601String();
  } catch (e) {
    print("Error parsing time string: $e");
    return "Invalid Time Format";
  }
}

String convertTimeStringToISO(String timeString) {
  // Get the current date in the local time zone.
  final now = DateTime.now().toLocal();

  // Parse the time string.
  final timeParts =
      timeString.split(RegExp(r'[:\s]')); // Split by colon and space
  if (timeParts.length < 3) {
    throw const FormatException(
        'Invalid time string format. Expected HH:MM AM/PM');
  }

  int hour = int.parse(timeParts[0]);
  final int minute = int.parse(timeParts[1]);
  final String ampm = timeParts[2].toUpperCase();

  if (hour < 1 || hour > 12) {
    throw const FormatException('Hour must be between 1 and 12');
  }

  if (ampm != 'AM' && ampm != 'PM') {
    throw const FormatException('Invalid AM/PM indicator. Must be AM or PM');
  }

  // Convert to 24-hour format.
  if (ampm == 'PM' && hour != 12) {
    hour += 12;
  } else if (ampm == 'AM' && hour == 12) {
    hour = 0;
  }

  // Create a new DateTime object with the current date and parsed time.
  final dateTime = DateTime(now.year, now.month, now.day, hour, minute);

  // Convert to ISO 8601 format with UTC offset.
  return dateTime.toUtc().toIso8601String();
}

String generateRandomOTP() {
  final random = Random();
  String otp = '';
  for (int i = 0; i < 6; i++) {
    otp += random.nextInt(10).toString(); // Generates a random digit (0-9)
  }
  return otp;
}
