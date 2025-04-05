import 'package:flutter/material.dart';

class AnimatedAdvertisementLoadingIndicator extends StatefulWidget {
  const AnimatedAdvertisementLoadingIndicator({super.key});

  @override
  AnimatedAdvertisementLoadingIndicatorState createState() =>
      AnimatedAdvertisementLoadingIndicatorState();
}

class AnimatedAdvertisementLoadingIndicatorState
    extends State<AnimatedAdvertisementLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  final List<String> _imagePaths = [
    'https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/Group%201000001399%20(1).png?alt=media&token=968885e6-8fa4-45c4-81e4-33723a7e6366', // Replace with your image paths
    'https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/Group%201000001399%20(1).png?alt=media&token=968885e6-8fa4-45c4-81e4-33723a7e6366',
    'https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/Group%201000001399%20(1).png?alt=media&token=968885e6-8fa4-45c4-81e4-33723a7e6366',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1500), // 1.5 seconds for full cycle
    )..repeat();

    _animation = IntTween(begin: 0, end: _imagePaths.length - 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircularProgressIndicator(), // Background loading indicator
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Image.network(
                _imagePaths[_animation.value],
                height: 50, // Adjust image size as needed
                width: 50,
              );
            },
          ),
        ],
      ),
    );
  }
}
