import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateCartLoadingPage extends StatefulWidget {
  final BuildContext ctx;
  const UpdateCartLoadingPage({super.key, required this.ctx});

  @override
  State<UpdateCartLoadingPage> createState() => _UpdateCartLoadingPageState();
}

class _UpdateCartLoadingPageState extends State<UpdateCartLoadingPage> {
  @override
  void initState() {
    super.initState();
    // Schedule the navigation after the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.ctx.go('/cart');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.orange, // Customize as needed
        ),
      ),
    );
  }
}
