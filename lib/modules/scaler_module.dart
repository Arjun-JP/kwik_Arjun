import 'package:flutter/material.dart';
 
class ScalerModule {
  const ScalerModule(this.context);
 
  /// It takes a [BuildContext] as a constructor argument and uses
  /// [MediaQuery] to get the size of the viewport.
  ///
  final BuildContext context;
 
  /// The [baseViewportWidth] is set to 448.0 which is the width of the
  /// main viewport of the Flutter emulator.
  ///
  final double baseViewportWidth = 448.0;
  final double baseViewportHeight = 998.0;
 
  /// The [width], [height] and [textScaleFactor] are getters that
  /// return the width, height and text scale factor of the viewport
  /// respectively.
  ///
 
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get textScaleFactor => width / baseViewportWidth;
 
  /// The [scaleWidth], [scaleHeight] and [scaleFontSize] are functions
  /// that takes a factor as an argument, and returns the scaled value
  /// of the viewport width, height or font size respectively.
  ///
  double scaleWidth(double factor) {
    return width * factor;
  }
 
  double scaleHeight(double factor) {
    return height * factor;
  }
 
  /// The [scaleFontSize] scales the font size by the given factor
  /// based on the text scale factor of the viewport.
  double scaleFontSize(double fontSize) {
    return textScaleFactor * fontSize;
  }
 
  double normalizeHeight(double h) {
    return (h / baseViewportHeight) * height;
  }
 
  double normalizeWidth(double w) {
    return (w / baseViewportWidth) * width;
  }
}