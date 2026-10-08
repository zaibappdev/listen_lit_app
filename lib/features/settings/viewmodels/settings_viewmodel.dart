import 'package:flutter/material.dart';
import '../../../../data/services/storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  double volume = 1.0;
  bool highQualityAudio = true;
  bool autoPlay = true;
  String cacheSize = '42.5 MB';

  SettingsViewModel() {
    _loadSettings();
  }

  void _loadSettings() {
    final modeStr = StorageService.getThemeMode();
    switch (modeStr) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        themeMode = ThemeMode.system;
        break;
    }
    volume = StorageService.getVolume();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    String modeStr = 'system';
    if (mode == ThemeMode.light) {
      modeStr = 'light';
    } else if (mode == ThemeMode.dark) {
      modeStr = 'dark';
    }
    await StorageService.setThemeMode(modeStr);
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    volume = value;
    await StorageService.setVolume(value);
    notifyListeners();
  }

  Future<void> setHighQualityAudio(bool value) async {
    highQualityAudio = value;
    notifyListeners();
  }

  Future<void> setAutoPlay(bool value) async {
    autoPlay = value;
    notifyListeners();
  }

  Future<void> clearCache() async {
    await Future.delayed(const Duration(milliseconds: 500));
    cacheSize = '0.0 KB';
    notifyListeners();
  }
}
