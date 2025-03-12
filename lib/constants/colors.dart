import 'package:flutter/material.dart';

class AppColors {
  static const textColorWhite = Color.fromARGB(255, 255, 255, 255);
  static const textColorblack = Color(0xFF233D4D);
  static const textColorGrey = Color(0xff79868E);

  static const textColorDimGrey = Color(0xffC8C3C3);
  static const textColorSettings = Color(0xff5923C4);
  static const dotColorSelected = Color(0xffFF592E);
  static const dotColorUnSelected = Color(0xffC8CAD1);
  static const buttonwhite = Color.fromARGB(255, 255, 255, 255);

  static const backgroundColorWhite = Color(0xffFAFAFA);

  static const primaryColor = Color(0xFF233D4D);

  static final gradient1black = Color(0xFF233D4D).withOpacity(0.0);

  static final gradient2orange = Color(0xffFC5B00).withOpacity(0.2);

  static const secondaryColor = Color(0xffCEBEFB);

  static const kwhiteColor = Colors.white;
  static const kpurple = Color(0xff612ACE);
  static const kblackColor = Color(0xFF233D4D);
  static const kgreyColor = Color(0xff838383);
  static const kgreyColorlite = Color(0xffC8C3C3);

  static const offerBadgeColor = Color(0xffFFFA76);
  static const addToCartBorder = Color(0xffE23338);
  static const korangeColor = Color(0xffFF9B2E);

  static const buttonColorOrange = Color(0xffFC5B00);
}

// Function to parse hex color correctly

Color parseColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return const Color(0xFFADD8E6); // Default pastel blue
  }

  hexColor = hexColor.replaceAll("#", ""); // Remove # if present

  // If the input is 6 characters long (RGB), add "FF" for full opacity
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  // If the input is not 8 characters (AARRGGBB), return default pastel color
  else if (hexColor.length != 8) {
    return const Color(0xFFADD8E6);
  }

  try {
    return Color(int.parse("0x$hexColor")); // Ensure correct 0xAARRGGBB format
  } catch (e) {
    return const Color(0xFFADD8E6); // Default pastel blue on error
  }
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

Color lightenColor(Color color, double amount) {
  int r = color.red;
  int g = color.green;
  int b = color.blue;

  r = (r + ((255 - r) * amount)).round();
  g = (g + ((255 - g) * amount)).round();
  b = (b + ((255 - b) * amount)).round();

  return Color.fromRGBO(r, g, b, 1.0);
}
