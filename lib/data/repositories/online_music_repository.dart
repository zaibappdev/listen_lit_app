import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/song_model.dart';

/// Contract for licensed online catalogs used by the Listen Lit client.
abstract interface class OnlineMusicRepository {
  Future<List<SongModel>> featured({int limit = 20});
  Future<List<SongModel>> search(String query, {int limit = 30});
  Future<List<SongModel>> byGenre(String genre, {int limit = 30});
}

/// API and response errors returned by an online music provider.
class OnlineMusicException implements Exception {
  const OnlineMusicException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Jamendo's Creative Commons catalog adapter.
class JamendoMusicRepository implements OnlineMusicRepository {
  JamendoMusicRepository({
    http.Client? client,
    String clientId = const String.fromEnvironment('JAMENDO_CLIENT_ID'),
  }) : _client = client ?? http.Client(),
       _clientId = clientId;

  static final Uri _endpoint = Uri.https('api.jamendo.com', '/v3.0/tracks/');
  final http.Client _client;
  final String _clientId;
  bool get isConfigured => _clientId.isNotEmpty;

  @override
  Future<List<SongModel>> featured({int limit = 20}) => _fetch({
    'order': 'popularity_total_desc',
    'limit': '${limit.clamp(1, 50)}',
  });

  @override
  Future<List<SongModel>> search(String query, {int limit = 30}) {
    final normalized = query.trim();
    if (normalized.isEmpty) return Future.value(const []);
    return _fetch({'search': normalized, 'limit': '${limit.clamp(1, 50)}'});
  }

  @override
  Future<List<SongModel>> byGenre(String genre, {int limit = 30}) =>
      _fetch({'fuzzytags': genre, 'limit': '${limit.clamp(1, 50)}'});

  Future<List<SongModel>> _fetch(Map<String, String> filters) async {
    if (_clientId.isEmpty) return const [];
    final uri = _endpoint.replace(
      queryParameters: {
        'client_id': _clientId,
        'format': 'json',
        'audioformat': 'mp32',
        'imagesize': '300',
        'include': 'musicinfo',
        // Exclude non-commercial-only tracks from this public app catalog.
        'ccnc': 'false',
        ...filters,
      },
    );

    Object? lastError;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final response = await _client
            .get(uri)
            .timeout(const Duration(seconds: 12));
        if (response.statusCode < 200 || response.statusCode >= 300) {
          if (response.statusCode >= 500 && attempt < 2) continue;
          throw OnlineMusicException(
            'Jamendo returned HTTP ${response.statusCode}. Please try again.',
          );
        }
        final body = jsonDecode(response.body);
        if (body is! Map<String, dynamic> ||
            body['headers']?['status'] != 'success') {
          throw const OnlineMusicException(
            'Jamendo returned an invalid response.',
          );
        }
        final results = body['results'];
        if (results is! List) return const [];
        return results
            .whereType<Map<String, dynamic>>()
            .map(_songFromJson)
            .where((song) => song.audioUrl.isNotEmpty)
            .toList(growable: false);
      } on TimeoutException catch (error) {
        lastError = error;
      } on http.ClientException catch (error) {
        lastError = error;
      } on FormatException catch (error) {
        throw OnlineMusicException(
          'Jamendo returned invalid data: ${error.message}',
        );
      } on OnlineMusicException {
        rethrow;
      }
      if (attempt < 2) {
        await Future<void>.delayed(Duration(milliseconds: 250 * (attempt + 1)));
      }
    }
    throw OnlineMusicException(
      lastError is TimeoutException
          ? 'Jamendo took too long to respond. Check your connection and retry.'
          : 'Could not connect to Jamendo. Check your connection and retry.',
    );
  }

  SongModel _songFromJson(Map<String, dynamic> json) {
    final musicInfo = json['musicinfo'];
    final tags = musicInfo is Map<String, dynamic> ? musicInfo['tags'] : null;
    final genres = tags is Map<String, dynamic> ? tags['genres'] : null;
    final genre = genres is List && genres.isNotEmpty
        ? '${genres.first}'
        : 'Online';
    final durationSeconds = (json['duration'] as num?)?.toInt() ?? 0;
    final audioUrl = '${json['audio'] ?? ''}';
    return SongModel(
      id: 'jamendo:${json['id'] ?? ''}',
      title: '${json['name'] ?? 'Unknown track'}'.trim(),
      artist: '${json['artist_name'] ?? 'Unknown artist'}'.trim(),
      album: '${json['album_name'] ?? 'Single'}'.trim(),
      duration:
          '${durationSeconds ~/ 60}:${(durationSeconds % 60).toString().padLeft(2, '0')}',
      coverUrl: '${json['image'] ?? ''}',
      audioUrl: audioUrl,
      category: genre,
      licenseUrl: '${json['license_ccurl'] ?? ''}',
      providerName: 'Jamendo',
      artistUrl: '${json['artist_idstr'] ?? ''}'.isEmpty
          ? ''
          : 'https://www.jamendo.com/artist/${json['artist_idstr']}',
      trackUrl: '${json['shareurl'] ?? ''}',
    );
  }

  void close() => _client.close();
}
