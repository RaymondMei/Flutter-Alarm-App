import 'package:flutter/material.dart';

class GradientColors {
  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

List<List<Color>> gradientTemplate = [
  GradientColors.sky,
  GradientColors.sunset,
  GradientColors.sea,
  GradientColors.mango,
  GradientColors.fire
];

MaterialColor backgroundTheme = MaterialColor(
  0xFF2D2F41,
  <int, Color>{
    50: Color(0xff8c8d97),
    100: Color(0xff81828d),
    200: Color(0xff6c6d7a),
    300: Color(0xff575967),
    400: Color(0xff424454),
    500: Color(0xff2d2f41),
    600: Color(0xff282a3a),
    700: Color(0xff242634),
    800: Color(0xff1f212d),
    900: Color(0xff1b1c27)
  },
);

// creates a color swatch from a single 32-bit color (Credit: https://blog.usejournal.com/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3)
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
