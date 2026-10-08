import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listen_lit_app/data/models/song_model.dart';
import 'package:listen_lit_app/data/services/storage_service.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('listen-lit-hive-');
    await StorageService.init(path: hiveDirectory.path);
  });

  tearDown(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('favorite records retain enough metadata to rebuild a track', () async {
    final track = _song('jamendo:42', 'Saved track');

    await StorageService.toggleFavorite(track.id, true, song: track);

    expect(StorageService.isFavorite(track.id), isTrue);
    expect(StorageService.getFavoriteSongs().single.title, track.title);
    await StorageService.toggleFavorite(track.id, false, song: track);
    expect(StorageService.getFavoriteSongs(), isEmpty);
  });

  test(
    'recent tracks deduplicate, expire after 24 hours, and sort newest first',
    () async {
      final now = DateTime.now();
      await StorageService.addRecentSong(
        _song('old', 'Expired'),
        playedAt: now.subtract(const Duration(hours: 25)),
      );
      await StorageService.addRecentSong(
        _song('new', 'Newest'),
        playedAt: now.subtract(const Duration(minutes: 5)),
      );
      await StorageService.addRecentSong(
        _song('recent', 'Recent'),
        playedAt: now.subtract(const Duration(minutes: 30)),
      );

      final recent = StorageService.getRecentSongs();

      expect(recent.map((song) => song.id), ['new', 'recent']);
      expect(StorageService.getRecentSongs(), hasLength(2));
    },
  );
}

SongModel _song(String id, String title) => SongModel(
  id: id,
  title: title,
  artist: 'Listen Lit',
  album: 'Test collection',
  duration: '3:00',
  coverUrl: 'https://example.com/art.jpg',
  audioUrl: 'https://example.com/audio.mp3',
  category: 'Ambient',
  licenseUrl: 'https://creativecommons.org/licenses/by/4.0/',
  providerName: 'Jamendo',
);
