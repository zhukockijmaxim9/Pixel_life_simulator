import 'package:flutter/material.dart';

class AppColors {
  static const accent1 = Color(0xFF8F1162);
  static const accent2 = Color(0xFFC0045C);
  static const accent3 = Color(0xFFC5035C);
  static const accent4 = Color(0xFFE74B31);
  static const accent5 = Color(0xFFEB9B2A);

  static const gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    colors: [accent1, accent2, accent3, accent4, accent5],
  );

  static const greyPinkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF202020),
      Color(0xFF8B1062),
    ],
  );
}

