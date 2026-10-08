import 'package:flutter_test/flutter_test.dart';
import 'package:listen_lit_app/data/models/song_model.dart';

void main() {
  test('song metadata can be serialized for playback queues', () {
    final song = SongModel(
      id: 'song-1',
      title: 'Test track',
      artist: 'Listen Lit',
      album: 'Unit test',
      duration: '3:25',
      coverUrl: 'https://example.com/art.png',
      audioUrl: 'https://example.com/audio.mp3',
      category: 'Test',
    );

    final restored = SongModel.fromJson(song.toJson());
    expect(restored.title, song.title);
    expect(restored.artist, song.artist);
    expect(restored.audioUrl, song.audioUrl);
  });
}
