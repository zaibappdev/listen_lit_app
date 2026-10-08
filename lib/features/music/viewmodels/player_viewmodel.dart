import 'package:flutter/foundation.dart';
import '../../../../data/models/song_model.dart';
import '../../../../data/services/audio_service.dart';
import '../../../../data/services/storage_service.dart';

class PlayerViewModel extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  AudioService get audioService => _audioService;

  SongModel? get currentSong => _audioService.currentSong;

  bool get isPlaying => _audioService.player.playing;

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  PlayerViewModel() {
    _initListeners();
  }

  void _initListeners() {
    _audioService.positionStream.listen((pos) {
      position = pos;
      notifyListeners();
    });

    _audioService.durationStream.listen((dur) {
      duration = dur ?? Duration.zero;
      notifyListeners();
    });

    _audioService.playerStateStream.listen((state) {
      notifyListeners();
    });
  }

  Future<void> playSong(List<SongModel> playlist, int index) async {
    await _audioService.setPlaylist(playlist, initialIndex: index);
    if (currentSong != null) {
      StorageService.addRecent(currentSong!.id);
    }
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> next() async {
    await _audioService.playNext();
    if (currentSong != null) {
      StorageService.addRecent(currentSong!.id);
    }
    notifyListeners();
  }

  Future<void> previous() async {
    await _audioService.playPrevious();
    if (currentSong != null) {
      StorageService.addRecent(currentSong!.id);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
