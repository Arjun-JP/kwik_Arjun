import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Coupon_bloc/Coupon_bloc.dart';
import 'package:kwik/bloc/Coupon_bloc/coupon_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/cart_page/updatecart_loadingpage.dart';

class MovetoCart extends StatefulWidget {
  final String wishlistid;
  final String pincode;
  const MovetoCart(
      {super.key, required this.wishlistid, required this.pincode});

  @override
  State<MovetoCart> createState() => _MovetoCartState();
}

TextEditingController lessoncontroller = TextEditingController();

class _MovetoCartState extends State<MovetoCart> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    return Container(
      // height: MediaQuery.of(context).size.height * .26,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 246, 96, 93), // Choose your color
              width: 2.0, // Thickness of the border
            ),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ready to Buy?",
                // Your doorstep shopping buddy will be right here—just a tap away. Come back soon!
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.textColorblack,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(
                "Great choice! Want to move this item from your wishlist to your cart so you can check out when you're ready?",
                // Your doorstep shopping buddy will be right here—just a tap away. Come back soon!
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.textColorblack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: AppColors.buttonColorOrange, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: AppColors.textColorWhite,
                        backgroundColor: AppColors.textColorWhite,
                      ),
                      child: Text(
                        "Close",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.buttonColorOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (user != null) {
                          context.read<CartBloc>().add(AddToCartFromWishlist(
                                userId: user.uid,
                                wishlistID: widget.wishlistid,
                                pincode: widget.pincode,
                              ));
                          context
                              .read<CartBloc>()
                              .add(SyncCartWithServer(userId: user.uid));
                          context.read<CouponBloc>().add(ResetCoupons());
                          // context.pushReplacement('/cart');
                        }
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: const Color.fromARGB(255, 246, 96, 93),
                        backgroundColor: const Color.fromARGB(255, 246, 96, 93),
                      ),
                      child: Text(
                        "Continue",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.kwhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
