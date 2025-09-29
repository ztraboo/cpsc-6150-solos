import 'package:flutter/material.dart';

enum Luminance { light, dark }

class Palette {
  final String name;
  final Color swatch;
  final Luminance luminance;
  
  late TextStyle _bodyMedium;
  late TextStyle _titleSmall;
  late TextStyle _titleMedium; 
  late TextStyle _headlineLarge;

  late Colors _inputSplitCounterColor;

  late Colors _sliderActiveColor;
  late Colors _sliderInactiveColor;

  Palette({required this.name, required this.swatch, required this.luminance})
  : _bodyMedium = TextStyle(
    color: luminance == Luminance.light ? Colors.black : Colors.white,
    // fontSize: 16,
  ),
  _titleSmall = TextStyle(
    color: luminance == Luminance.light ? Colors.black : Colors.white,
    // fontSize: 16,
  ),
  _titleMedium = TextStyle(
    color: luminance == Luminance.light ? Colors.black : Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500
  ),
  _headlineLarge = TextStyle(
    color: luminance == Luminance.light ? Colors.black : Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  TextStyle get bodyMedium => _bodyMedium;
  TextStyle get titleSmall => _titleSmall;
  TextStyle get titleMedium => _titleMedium;
  TextStyle get headlineLarge => _headlineLarge;

  Color get inputSplitCounterColor => luminance == Luminance.light ? Colors.black : Colors.white;

  Color get sliderActiveColor => luminance == Luminance.light ? Colors.black : Colors.white;
  Color get sliderInactiveColor => luminance == Luminance.light ? Colors.black : Colors.white.withOpacity(0.3);
}