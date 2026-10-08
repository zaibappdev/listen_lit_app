import 'package:flutter/material.dart';

class AppTheme {
  static const Color brand = Color(0xFF9B59B6);
  static const _transparentOverlay = WidgetStatePropertyAll<Color?>(
    Colors.transparent,
  );

  static ThemeData _build(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.transparent,
    ),
    listTileTheme: const ListTileThemeData(
      enableFeedback: false,
      selectedTileColor: Colors.transparent,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentOverlay),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentOverlay),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentOverlay),
    ),
    filledButtonTheme: const FilledButtonThemeData(
      style: ButtonStyle(overlayColor: _transparentOverlay),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      overlayColor: _transparentOverlay,
      indicatorColor: Color(0x229B59B6),
    ),
    tabBarTheme: const TabBarThemeData(
      overlayColor: _transparentOverlay,
      splashFactory: NoSplash.splashFactory,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: scheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    switchTheme: const SwitchThemeData(overlayColor: _transparentOverlay),
  );

  static ThemeData get lightTheme => _build(
    ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.light,
      surface: const Color(0xFFF8F7FA),
    ),
  );

  static ThemeData get darkTheme => _build(
    ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.dark,
      surface: const Color(0xFF17151A),
    ),
  );
}
