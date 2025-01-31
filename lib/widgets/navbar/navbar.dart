import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navbar extends StatefulWidget {
  Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 6, left: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/home_unselected.svg",
                      fit: BoxFit.contain, width: 26, height: 26),
                  const SizedBox(height: 5),
                  const Text(
                    "Home",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/category_unselected.svg",
                      fit: BoxFit.contain, width: 26, height: 26),
                  const SizedBox(height: 5),
                  const Text(
                    "Categories",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/offer_unselected.svg",
                      fit: BoxFit.contain, width: 26, height: 26),
                  const SizedBox(height: 5),
                  const Text(
                    "Offers",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/cart_unselected.svg",
                      fit: BoxFit.contain, width: 26, height: 26),
                  const SizedBox(height: 5),
                  const Text(
                    "Cart",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
