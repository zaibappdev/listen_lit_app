import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:listen_lit_app/data/repositories/online_music_repository.dart';

void main() {
  test('Jamendo tracks retain playback and attribution metadata', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'api.jamendo.com');
      expect(request.url.queryParameters['ccnc'], 'false');
      return http.Response(
        jsonEncode({
          'headers': {'status': 'success'},
          'results': [
            {
              'id': '123',
              'name': 'Open Skies',
              'artist_name': 'Example Artist',
              'artist_idstr': 'example-artist',
              'album_name': 'Demo EP',
              'duration': 205,
              'audio': 'https://audio.example/track.mp3',
              'image': 'https://image.example/cover.jpg',
              'license_ccurl': 'https://creativecommons.org/licenses/by/4.0/',
              'shareurl': 'https://www.jamendo.com/track/123',
              'musicinfo': {
                'tags': {
                  'genres': ['ambient'],
                },
              },
            },
          ],
        }),
        200,
      );
    });
    final repository = JamendoMusicRepository(
      client: client,
      clientId: 'test-id',
    );

    final tracks = await repository.featured(limit: 1);

    expect(tracks, hasLength(1));
    expect(tracks.single.title, 'Open Skies');
    expect(tracks.single.artist, 'Example Artist');
    expect(tracks.single.duration, '3:25');
    expect(tracks.single.category, 'ambient');
    expect(tracks.single.licenseUrl, contains('creativecommons.org'));
    expect(tracks.single.providerName, 'Jamendo');
    repository.close();
  });

  test(
    'online catalog remains empty until a client ID is configured',
    () async {
      final repository = JamendoMusicRepository(
        client: MockClient(
          (_) async => throw StateError('must not make a request'),
        ),
      );

      expect(await repository.featured(), isEmpty);
      expect(await repository.search('ambient'), isEmpty);
      repository.close();
    },
  );
}
