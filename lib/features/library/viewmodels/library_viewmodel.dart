import 'package:flutter/foundation.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/services/storage_service.dart';

class LibraryViewModel extends ChangeNotifier {
  final MusicRepository _repository = MusicRepository();
  List<SongModel> favorites = [];
  List<SongModel> recentlyPlayed = [];
  List<SongModel> downloadedSongs = [];

  LibraryViewModel() {
    loadLibrary();
  }

  void loadLibrary() {
    final all = _repository.getAllSongs();
    favorites = all.where((s) => StorageService.isFavorite(s.id)).toList();
    
    final recentIds = StorageService.getRecent();
    recentlyPlayed = all.where((s) => recentIds.contains(s.id)).toList();
    
    downloadedSongs = all.take(10).toList(); // Simulated downloaded tracks

    notifyListeners();
  }

  void toggleFavorite(SongModel song) {
    song.isFavorite = !song.isFavorite;
    StorageService.toggleFavorite(song.id, song.isFavorite);
    favorites = _repository.getAllSongs().where((s) => StorageService.isFavorite(s.id)).toList();
    notifyListeners();
  }
}
