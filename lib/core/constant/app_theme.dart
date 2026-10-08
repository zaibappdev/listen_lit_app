import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        primaryColor: AppColor.kPrimary,
        colorScheme: ColorScheme.light(
          primary: AppColor.kPrimary,
          secondary: AppColor.kPrimary,
          surface: Colors.white,
        ),
        fontFamily: 'Inter',
        textTheme: TextTheme(
          displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
          bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[700]),
        ),
      );

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

  static ThemeData get amoledTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: AppColor.kPrimary,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFCA7CD8),
          secondary: Color(0xFFF4E5F7),
          surface: Color(0xFF121212),
        ),
        fontFamily: 'Inter',
        textTheme: TextTheme(
          displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[400]),
        ),
      );
}
