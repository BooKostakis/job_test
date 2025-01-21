import 'package:flutter/material.dart';
import 'package:job_test/common/theme/app_colors.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Gilroy',
      fontWeight: FontWeight.w600,
      fontSize: 32,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColors.appGrey,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Gilroy',
      fontWeight: FontWeight.w600,
      fontSize: 28,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Gilroy',
      fontWeight: FontWeight.w600,
      fontSize: 24,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: AppColors.appBlue,
    ),
    bodySmall: TextStyle(
        fontFamily: 'Manrope', fontWeight: FontWeight.w500, fontSize: 12, color: Color.fromRGBO(4, 4, 4, 0.4)),
  ),
);
