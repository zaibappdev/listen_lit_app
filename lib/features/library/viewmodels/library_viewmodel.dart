import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../../data/models/song_model.dart';
import '../../../data/services/storage_service.dart';

class LibraryViewModel extends ChangeNotifier {
  List<SongModel> favorites = [];
  List<SongModel> recentlyPlayed = [];
  List<SongModel> downloadedSongs = [];
  late final StreamSubscription<dynamic> _favoriteSubscription;
  late final StreamSubscription<dynamic> _recentSubscription;

  LibraryViewModel() {
    _favoriteSubscription = StorageService.favoriteChanges.listen(
      (_) => loadLibrary(),
    );
    _recentSubscription = StorageService.recentChanges.listen(
      (_) => loadLibrary(),
    );
    loadLibrary();
  }

  void loadLibrary() {
    favorites = StorageService.getFavoriteSongs();
    recentlyPlayed = StorageService.getRecentSongs();
    downloadedSongs = const [];

    notifyListeners();
  }

  void toggleFavorite(SongModel song) {
    song.isFavorite = !song.isFavorite;
    StorageService.toggleFavorite(song.id, song.isFavorite, song: song);
    favorites = StorageService.getFavoriteSongs();
    notifyListeners();
  }

  @override
  void dispose() {
    _favoriteSubscription.cancel();
    _recentSubscription.cancel();
    super.dispose();
  }
}
