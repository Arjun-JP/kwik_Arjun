import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_state.dart';
import 'package:kwik/constants/colors.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.buttonColorOrange, // Border color
                width: .3, // Border width
              ),
            ),
          ),
          height: 94,
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
                      "/home"),
                ),
                Expanded(
                  flex: 1,
                  child: _buildNavItem(
                      context,
                      1,
                      "Categories",
                      "assets/images/category_selected.svg",
                      "assets/images/cart_unselected.svg",
                      "/category"),
                ),
                Expanded(
                  flex: 1,
                  child: _buildNavItem(
                      context,
                      2,
                      "Offers",
                      "assets/images/offer_selected.svg",
                      "assets/images/offer_unselected.svg",
                      "/offer"),
                ),
                Expanded(
                  flex: 1,
                  child: _buildNavItem(
                      context,
                      3,
                      "Cart",
                      "assets/images/cart_selected.svg",
                      "assets/images/cart_unselected.svg",
                      "/cart"),
                ),
                Expanded(
                  flex: 1,
                  child: _buildNavItem(
                      context,
                      4,
                      "Profile",
                      "assets/images/profile_unselected.svg",
                      "assets/images/profile_unselected.svg",
                      "/profile"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String label,
      String assetPathselected, String assetpathunselected, String route) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // overlayColor: Colors.transparent,

      onTap: () {
        context.go(route);
        context.read<NavbarBloc>().add(UpdateNavBarIndex(index));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            index == context.watch<NavbarBloc>().state.selectedIndex
                ? assetPathselected
                : assetpathunselected,
            fit: BoxFit.contain,
            width: 26,
            height: 26,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: index == context.watch<NavbarBloc>().state.selectedIndex
                  ? AppColors.buttonColorOrange
                  : AppColors.textColorblack,
              fontSize: 14,
              fontWeight:
                  index == context.watch<NavbarBloc>().state.selectedIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCenterNavItem(BuildContext context, int index, String label,
    String assetPathselected, String assetpathunselected, String route) {
  return InkWell(
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    // overlayColor: Colors.transparent,

    onTap: () {
      context.go(route);
      context.read<NavbarBloc>().add(UpdateNavBarIndex(index));
    },
    child: Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            index == context.watch<NavbarBloc>().state.selectedIndex
                ? assetPathselected
                : assetpathunselected,
            fit: BoxFit.contain,
            width: 26,
            height: 26,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: index == context.watch<NavbarBloc>().state.selectedIndex
                  ? AppColors.buttonColorOrange
                  : AppColors.textColorblack,
              fontSize: 14,
              fontWeight:
                  index == context.watch<NavbarBloc>().state.selectedIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
