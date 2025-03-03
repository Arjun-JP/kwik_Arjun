import 'package:flutter/material.dart';
import 'package:kwik/widgets/products_3.dart';

import '../../widgets/navbar/navbar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Products3(
          image: 'assets/images/image2.jpeg',
          title: 'Watermelon Kiran',
          quantity: "1 Pc",
          mrp: "100",
          buyingPrice: "50",
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
