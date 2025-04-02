// import 'package:flutter/material.dart' as w;
// import 'package:flutter/widgets.dart';
// import 'package:lottie/lottie.dart';
// import 'package:rive/rive.dart';

// class GroceryLoadingIndicator extends StatefulWidget {
//   @override
//   _GroceryLoadingIndicatorState createState() =>
//       _GroceryLoadingIndicatorState();
// }

// class _GroceryLoadingIndicatorState extends State<GroceryLoadingIndicator>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final List<String> _groceryImages = [
//     '',
//     '',
//     'assets/images/image2.jpeg',
//     'assets/images/image.jpeg'
//   ];
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     )..repeat();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Rotating orange ring
//         RotationTransition(
//           turns: _controller,
//           child: Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: w.Colors.orange, width: 6),
//             ),
//           ),
//         ),

//         // Center advertisement glow
//         Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: w.Colors.orange.withOpacity(0.3),
//             boxShadow: [
//               BoxShadow(
//                 color: w.Colors.orange.withOpacity(0.6),
//                 blurRadius: 15,
//                 spreadRadius: 5,
//               )
//             ],
//           ),
//           child: Center(
//             child: w.Image.asset(
//               'assets/images/User_fill.png', // Replace with actual ad
//               width: 60,
//               height: 60,
//             ),
//           ),
//         ),

//         // Floating grocery items
//         Positioned(
//           top: 20,
//           right: 0,
//           child: AnimatedGroceryItem(imagePath: 'assets/images/vegicon.png'),
//         ),
//         Positioned(
//           bottom: 20,
//           right: -40,
//           child: AnimatedGroceryItem(imagePath: 'assets/images/image2.jpeg'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class AnimatedGroceryItem extends StatelessWidget {
//   final String imagePath;

//   const AnimatedGroceryItem({required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder(
//       tween: Tween<Offset>(begin: Offset(2, 0), end: Offset(-2, 0)),
//       duration: Duration(seconds: 3),
//       builder: (context, Offset offset, child) {
//         return Transform.translate(
//           offset: Offset(offset.dx * MediaQuery.of(context).size.width, 0),
//           child: child,
//         );
//       },
//       child: w.Image.asset(
//         imagePath,
//         width: 50,
//         height: 50,
//       ),
//     );
//   }
// }
