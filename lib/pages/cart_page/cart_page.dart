import 'package:flutter/material.dart';

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.greenAccent,
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
