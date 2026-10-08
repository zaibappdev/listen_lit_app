import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _settingsBox = 'settings_box';
  static const String _favoritesBox = 'favorites_box';
  static const String _recentBox = 'recent_box';
  static const String _userBox = 'user_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_favoritesBox);
    await Hive.openBox(_recentBox);
    await Hive.openBox(_userBox);
  }

  // Settings
  static Box get _settings => Hive.box(_settingsBox);
  static Future<void> setDarkMode(bool isDark) async => await _settings.put('isDarkMode', isDark);
  static bool getDarkMode() => _settings.get('isDarkMode', defaultValue: true);

  static Future<void> setVolume(double volume) async => await _settings.put('volume', volume);
  static double getVolume() => _settings.get('volume', defaultValue: 1.0);

  // Favorites
  static Box get _favorites => Hive.box(_favoritesBox);
  static Future<void> toggleFavorite(String songId, bool isFav) async => await _favorites.put(songId, isFav);
  static bool isFavorite(String songId) => _favorites.get(songId, defaultValue: false);

  // Recently Played
  static Box get _recent => Hive.box(_recentBox);
  static Future<void> addRecent(String songId) async => await _recent.put(songId, DateTime.now().toIso8601String());
  static List<String> getRecent() => _recent.keys.cast<String>().toList();

  // User session
  static Box get _user => Hive.box(_userBox);
  static Future<void> saveUser(Map<String, dynamic> userData) async => await _user.put('current_user', userData);
  static Map<dynamic, dynamic>? getUser() => _user.get('current_user');
  static Future<void> clearUser() async => await _user.clear();
}
