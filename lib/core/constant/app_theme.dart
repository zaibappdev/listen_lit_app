import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColor.kBGColor,
        primaryColor: AppColor.kPrimary,
        colorScheme: ColorScheme.dark(
          primary: AppColor.kPrimary,
          secondary: AppColor.kLightAccentColor,
          surface: AppColor.kSamiDarkColor,
        ),
        fontFamily: 'Inter',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColor.kLightAccentColor),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColor.kLightAccentColor),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColor.kWhiteColor),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColor.kGreyColor),
        ),
      );
}
