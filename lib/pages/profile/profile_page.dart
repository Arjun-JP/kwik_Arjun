import 'package:flutter/material.dart';
import 'package:kwik/widgets/navbar/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.brown,
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
