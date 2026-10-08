import 'package:flutter/foundation.dart';
import '../../../../data/services/storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  bool isDarkMode = true;
  double volume = 1.0;

  SettingsViewModel() {
    isDarkMode = StorageService.getDarkMode();
    volume = StorageService.getVolume();
  }

  Future<void> setDarkMode(bool value) async {
    isDarkMode = value;
    await StorageService.setDarkMode(value);
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    volume = value;
    await StorageService.setVolume(value);
    notifyListeners();
  }
}
