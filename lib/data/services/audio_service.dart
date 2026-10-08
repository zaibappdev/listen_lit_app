import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:on_audio_query/on_audio_query.dart' as on_audio_query;
import 'package:path_provider/path_provider.dart';

import '../models/song_model.dart';

/// The single playback owner shared by the Flutter UI and Android MediaSession.
class AudioService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final ja.AudioPlayer _player = ja.AudioPlayer(handleInterruptions: false);
  ja.AudioPlayer get player => _player;

  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<ja.PlayerState> get playerStateStream => _player.playerStateStream;

  SongModel? _currentSong;
  SongModel? get currentSong => _currentSong;
  List<SongModel> _songs = const [];
  int _currentIndex = 0;
  bool _resumeAfterInterruption = false;
  double _volumeBeforeDucking = 1;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final Map<String, Uri> _artworkUris = {};

  AudioService() {
    _subscriptions.add(
      _player.playbackEventStream.listen(
        (_) => _publishState(),
        onError: (Object error, StackTrace stack) {
          _publishState(errorMessage: error.toString());
        },
      ),
    );
    _subscriptions.add(_player.positionStream.listen(_positionController.add));
    _subscriptions.add(
      _player.durationStream.listen((duration) {
        final song = _currentSong;
        if (song != null && duration != null) {
          mediaItem.add(_mediaItemFor(song).copyWith(duration: duration));
        }
      }),
    );
    _subscriptions.add(
      _player.currentIndexStream.listen((index) {
        if (index == null || index < 0 || index >= _songs.length) return;
        _currentIndex = index;
        _currentSong = _songs[index];
        mediaItem.add(_mediaItemFor(_currentSong!));
        unawaited(_attachLocalArtwork(_currentSong!));
        _publishState();
      }),
    );
  }

  Future<void> configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _subscriptions.add(
      session.interruptionEventStream.listen((event) async {
        if (event.begin) {
          _resumeAfterInterruption = _player.playing;
          if (event.type == AudioInterruptionType.duck) {
            _volumeBeforeDucking = _player.volume;
            await _player.setVolume(_volumeBeforeDucking * 0.2);
          } else {
            await _player.pause();
          }
        } else {
          if (event.type == AudioInterruptionType.duck) {
            await _player.setVolume(_volumeBeforeDucking);
          } else if (_resumeAfterInterruption) {
            await _player.play();
          }
          _resumeAfterInterruption = false;
        }
      }),
    );
    _subscriptions.add(session.becomingNoisyEventStream.listen((_) => pause()));
  }

  Future<void> setPlaylist(
    List<SongModel> songs, {
    int initialIndex = 0,
  }) async {
    if (songs.isEmpty) return;
    _songs = List<SongModel>.unmodifiable(songs);
    _currentIndex = initialIndex.clamp(0, songs.length - 1);
    final sources = songs.map((song) {
      final sourceUri = song.audioUrl.startsWith('http')
          ? Uri.parse(song.audioUrl)
          : Uri.file(song.audioUrl);
      return ja.AudioSource.uri(sourceUri, tag: _mediaItemFor(song));
    }).toList();
    queue.add(songs.map(_mediaItemFor).toList(growable: false));
    try {
      await _player.setAudioSource(
        ja.ConcatenatingAudioSource(
          children: sources,
          useLazyPreparation: true,
        ),
        initialIndex: _currentIndex,
      );
      _currentSong = _songs[_currentIndex];
      mediaItem.add(_mediaItemFor(_currentSong!));
      unawaited(_attachLocalArtwork(_currentSong!));
      await play();
    } catch (error) {
      _publishState(errorMessage: error.toString());
      rethrow;
    }
  }

  MediaItem _mediaItemFor(SongModel song) {
    final art = song.coverUrl;
    return MediaItem(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      duration: _parseDuration(song.duration),
      artUri: art.isEmpty ? _artworkUris[song.id] : Uri.tryParse(art),
      extras: {
        'audioUrl': song.audioUrl,
        'category': song.category,
        'provider': song.providerName,
        'trackUrl': song.trackUrl,
        'licenseUrl': song.licenseUrl,
      },
    );
  }

  Future<void> _attachLocalArtwork(SongModel song) async {
    if (song.coverUrl.isNotEmpty || song.audioUrl.startsWith('http')) return;
    final id = int.tryParse(song.id);
    if (id == null) return;
    try {
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}${Platform.pathSeparator}listen_lit_art_$id.jpg',
      );
      if (!await file.exists()) {
        final bytes = await on_audio_query.OnAudioQuery().queryArtwork(
          id,
          on_audio_query.ArtworkType.AUDIO,
          format: on_audio_query.ArtworkFormat.JPEG,
          size: 512,
        );
        if (bytes != null && bytes.isNotEmpty) {
          await file.writeAsBytes(bytes, flush: true);
        }
      }
      var artFile = file;
      if (!await artFile.exists()) {
        final placeholder = await rootBundle.load(
          'assets/images/logo_blue.png',
        );
        artFile = File(
          '${directory.path}${Platform.pathSeparator}listen_lit_default_art.png',
        );
        await artFile.writeAsBytes(
          placeholder.buffer.asUint8List(),
          flush: true,
        );
      }
      if (_currentSong?.id == song.id) {
        _artworkUris[song.id] = artFile.uri;
        mediaItem.add(_mediaItemFor(song).copyWith(artUri: artFile.uri));
      }
    } catch (_) {}
  }

  Duration? _parseDuration(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final minutes = int.tryParse(parts[0]);
    final seconds = int.tryParse(parts[1]);
    if (minutes == null || seconds == null) return null;
    return Duration(minutes: minutes, seconds: seconds);
  }

  void _publishState({String? errorMessage}) {
    final event = _player.playbackEvent;
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        processingState: {
          ja.ProcessingState.idle: AudioProcessingState.idle,
          ja.ProcessingState.loading: AudioProcessingState.loading,
          ja.ProcessingState.buffering: AudioProcessingState.buffering,
          ja.ProcessingState.ready: AudioProcessingState.ready,
          ja.ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
        errorMessage: errorMessage,
      ),
    );
  }

  @override
  Future<void> play() async {
    if (_player.processingState == ja.ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext) await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_player.position > const Duration(seconds: 3)) {
      await _player.seek(Duration.zero);
      await play();
    } else if (_player.hasPrevious) {
      await _player.seekToPrevious();
    }
  }

  Future<void> playNext() => skipToNext();
  Future<void> playPrevious() => skipToPrevious();
  Future<void> setVolume(double volume) => _player.setVolume(volume);
  Future<void> setLoopMode(ja.LoopMode mode) => _player.setLoopMode(mode);
  Future<void> setShuffleModeEnabled(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
    if (enabled) await _player.shuffle();
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> stop() async {
    await _player.stop();
    _currentSong = null;
    _songs = const [];
    queue.add(const []);
    mediaItem.add(null);
    _publishState();
    await super.stop();
  }

  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _positionController.close();
    await _player.dispose();
  }
}
