import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart' show SyncCartWithServer;
import 'package:kwik/bloc/Cart_bloc/cart_state.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_state.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_event.dart';
import 'package:kwik/constants/colors.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: AppColors.buttonColorOrange, // Border color
                width: .3, // Border width
              ),
            ),
          ),
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 6, left: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildNavItem(
                      context,
                      0,
                      "Home",
                      "assets/images/home_selected.svg",
                      "assets/images/home_unselected.svg",
                      "/home",
                      null),
                ),
                Expanded(
                  flex: 1,
                  child: _buildNavItem(
                      context,
                      1,
                      "Categories",
                      "assets/images/category_selected.svg",
                      "assets/images/category_unselected.svg",
                      "/category",
                      null),
                ),
                Expanded(
                  flex: 1,
                  child: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                    return _buildNavItem(
                        context,
                        3,
                        "Cart",
                        "assets/images/cart_selected.svg",
                        "assets/images/cart_unselected.svg",
                        "/cart",
                        state is CartUpdated
                            ? state.cartItems.length.toString()
                            : null);
                  }),
                ),
                Expanded(
                  flex: 1,
                  child: _buildNavItem(
                      context,
                      2,
                      "Offers",
                      "assets/images/supersaver.png",
                      "assets/images/supersaver.png",
                      "/offer",
                      null),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String label,
    String assetPathSelected,
    String assetPathUnselected,
    String route,
    String? cartProductCount,
  ) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        HapticFeedback.mediumImpact();
        context.go(route);
        context.read<NavbarBloc>().add(UpdateNavBarIndex(index));
      },
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                index != 2
                    ? Stack(
                        alignment: Alignment.center, // Keeps the icon centered
                        clipBehavior:
                            Clip.none, // Prevents clipping of the badge
                        children: [
                          SvgPicture.asset(
                            index ==
                                    context
                                        .watch<NavbarBloc>()
                                        .state
                                        .selectedIndex
                                ? assetPathSelected
                                : assetPathUnselected,
                            fit: BoxFit.contain,
                            width: 26,
                            height: 26,
                          ),
                          if (index == 3 &&
                              cartProductCount != null &&
                              cartProductCount != "0")
                            Positioned(
                              top:
                                  -5, // Move the badge exactly on top of the icon
                              right: -18, // Center it horizontally
                              left: 0, // Ensures it's centered above the icon
                              child: Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  shape: BoxShape.circle,
                                  color: context
                                              .watch<NavbarBloc>()
                                              .state
                                              .selectedIndex ==
                                          3
                                      ? Colors.white
                                      : Colors.red,
                                ),
                                child: Text(
                                  cartProductCount,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: context
                                                .watch<NavbarBloc>()
                                                .state
                                                .selectedIndex ==
                                            3
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    : Container(
                        decoration: const BoxDecoration(),
                        width: 60,
                        height: 60,
                        child: Image.asset("assets/images/supersaver.svg"),
                      ),
                const SizedBox(height: 5),
                if (index != 2)
                  Text(
                    label,
                    style: TextStyle(
                      color: index ==
                              context.watch<NavbarBloc>().state.selectedIndex
                          ? AppColors.buttonColorOrange
                          : AppColors.textColorblack,
                      fontSize: 14,
                      fontWeight: index ==
                              context.watch<NavbarBloc>().state.selectedIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
