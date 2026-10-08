import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';

class StorageService {
  static const String _settingsBox = 'settings_box';
  static const String _favoritesBox = 'favorites_box';
  static const String _recentBox = 'recent_box';
  static const String _userBox = 'user_box';

  static Future<void> init({String? path}) async {
    if (path == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(path);
    }
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_favoritesBox);
    await Hive.openBox(_recentBox);
    await Hive.openBox(_userBox);
  }

  // Settings
  static Box get _settings => Hive.box(_settingsBox);
  static Future<void> setDarkMode(bool isDark) async =>
      await _settings.put('isDarkMode', isDark);
  static bool getDarkMode() => _settings.get('isDarkMode', defaultValue: true);

  static Future<void> setThemeMode(String mode) async =>
      await _settings.put('theme_mode', mode);
  static String getThemeMode() =>
      _settings.get('theme_mode', defaultValue: 'system');

  static Future<void> setVolume(double volume) async =>
      await _settings.put('volume', volume);
  static double getVolume() => _settings.get('volume', defaultValue: 1.0);

  static Future<void> setPermissionHandled(bool handled) async =>
      await _settings.put('permission_handled', handled);
  static bool getPermissionHandled() =>
      _settings.get('permission_handled', defaultValue: false);

  static Future<void> setNotificationPromptHandled(bool handled) async =>
      await _settings.put('notification_prompt_handled', handled);
  static bool getNotificationPromptHandled() =>
      _settings.get('notification_prompt_handled', defaultValue: false);

  // Favorites
  static Box get _favorites => Hive.box(_favoritesBox);
  static Stream<BoxEvent> get favoriteChanges => _favorites.watch();
  static Future<void> toggleFavorite(
    String songId,
    bool isFav, {
    SongModel? song,
  }) async {
    if (!isFav) {
      await _favorites.delete(songId);
      return;
    }
    await _favorites.put(songId, song?.toJson() ?? true);
  }

  static List<SongModel> getFavoriteSongs() => _favorites.values
      .whereType<Map>()
      .map((value) => SongModel.fromJson(Map<String, dynamic>.from(value)))
      .toList(growable: false);
  static bool isFavorite(String songId) {
    final value = _favorites.get(songId, defaultValue: false);
    return value == true || value is Map;
  }

  // Recently Played
  static Box get _recent => Hive.box(_recentBox);
  static Stream<BoxEvent> get recentChanges => _recent.watch();
  static Future<void> addRecent(String songId) async =>
      await _recent.put(songId, DateTime.now().toIso8601String());
  static List<String> getRecent() => _recent.keys.cast<String>().toList();

  static Future<void> addRecentSong(
    SongModel song, {
    DateTime? playedAt,
  }) async {
    await _recent.put(song.id, {
      'playedAt': (playedAt ?? DateTime.now()).toIso8601String(),
      'song': song.toJson(),
    });
  }

  static List<SongModel> getRecentSongs() {
    final now = DateTime.now();
    final result = <({DateTime playedAt, SongModel song})>[];
    for (final key in _recent.keys.toList()) {
      final value = _recent.get(key);
      if (value is! Map) continue;
      final playedAt = DateTime.tryParse('${value['playedAt'] ?? ''}');
      final songData = value['song'];
      if (playedAt == null ||
          playedAt.isAfter(now) ||
          now.difference(playedAt) > const Duration(hours: 24)) {
        unawaited(_recent.delete(key));
        continue;
      }
      if (songData is Map) {
        result.add((
          playedAt: playedAt,
          song: SongModel.fromJson(Map<String, dynamic>.from(songData)),
        ));
      }
    }
    result.sort((a, b) => b.playedAt.compareTo(a.playedAt));
    return result.map((entry) => entry.song).toList(growable: false);
  }

  // User session
  static Box get _user => Hive.box(_userBox);
  static Future<void> saveUser(Map<String, dynamic> userData) async =>
      await _user.put('current_user', userData);
  static Map<dynamic, dynamic>? getUser() => _user.get('current_user');
  static Future<void> clearUser() async => await _user.clear();
}
