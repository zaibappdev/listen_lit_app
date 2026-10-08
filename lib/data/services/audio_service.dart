import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  SongModel? _currentSong;
  SongModel? get currentSong => _currentSong;

  List<SongModel> _playlist = [];
  int _currentIndex = 0;

  Future<void> setPlaylist(List<SongModel> songs, {int initialIndex = 0}) async {
    _playlist = songs;
    _currentIndex = initialIndex;
    if (_playlist.isNotEmpty) {
      await loadAndPlay(_playlist[_currentIndex]);
    }
  }

  Future<void> loadAndPlay(SongModel song) async {
    try {
      _currentSong = song;
      final url = song.audioUrl.isNotEmpty
          ? song.audioUrl
          : 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
      
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> play() async => await _player.play();
  Future<void> pause() async => await _player.pause();
  Future<void> stop() async {
    await _player.stop();
    _currentSong = null;
  }
  Future<void> seek(Duration position) async => await _player.seek(position);
  Future<void> setVolume(double volume) async => await _player.setVolume(volume);
  Future<void> setLoopMode(LoopMode mode) async => await _player.setLoopMode(mode);
  Future<void> setShuffleModeEnabled(bool enabled) async => await _player.setShuffleModeEnabled(enabled);
  Future<void> setSpeed(double speed) async => await _player.setSpeed(speed);

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await loadAndPlay(_playlist[_currentIndex]);
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await loadAndPlay(_playlist[_currentIndex]);
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
