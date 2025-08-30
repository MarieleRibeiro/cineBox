import 'package:flutter/material.dart';

abstract class AppColors {
  // Cores principais
  static const redColor = Color(0xffEA4335);
  static const backgroundColor = Color(0xffF9F9F9);
  static const lightGrey = Color(0xFF9B9B9B);
  static const darkGrey = Color(0xFF4F4F4F);
  static const yellow = Color(0xFFFFBA49);

  // Variações de vermelho
  static const redLight = Color(0xFFF44336);
  static const redDark = Color(0xFFD32F2F);
  static const redAccent = Color(0xFFFF5252);

  // Variações de cinza
  static const grey50 = Color(0xFFFAFAFA);
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey400 = Color(0xFFBDBDBD);
  static const grey500 = Color(0xFF9E9E9E);
  static const grey600 = Color(0xFF757575);
  static const grey700 = Color(0xFF616161);
  static const grey800 = Color(0xFF424242);
  static const grey900 = Color(0xFF212121);

  // Cores de status
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);

  // Cores de fundo
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF121212);

  // Cores de texto
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textDisabled = Color(0xFFBDBDBD);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textOnSecondary = Color(0xFF000000);

  // Gradientes
  static const primaryGradient = LinearGradient(
    colors: [redColor, redDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundGradient = LinearGradient(
    colors: [backgroundColor, grey100],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Sombras
  static const shadowLight = Color(0x1A000000);
  static const shadowMedium = Color(0x33000000);
  static const shadowDark = Color(0x4D000000);
}
