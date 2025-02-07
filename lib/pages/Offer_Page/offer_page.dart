import 'package:flutter/material.dart';
import 'package:kwik/widgets/navbar/navbar.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellowAccent,
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
