import 'package:flutter/foundation.dart';
import '../../../../data/models/song_model.dart';
import '../../../../data/repositories/music_repository.dart';
import '../../../../data/services/storage_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MusicRepository _repository = MusicRepository();

  List<SongModel> featuredSongs = [];
  List<SongModel> recommendedSongs = [];
  List<String> categories = [];
  List<SongModel> searchResults = [];

  bool isLoading = false;
  String searchQuery = '';

  HomeViewModel() {
    loadData();
  }

  void loadData() {
    isLoading = true;
    notifyListeners();

    featuredSongs = _repository.getFeaturedSongs();
    recommendedSongs = _repository.getRecommendedSongs();
    categories = _repository.getCategories();

    // Check favorite status from Hive
    for (var song in [...featuredSongs, ...recommendedSongs]) {
      song.isFavorite = StorageService.isFavorite(song.id);
    }

    isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      searchResults = [];
    } else {
      final all = [...featuredSongs, ...recommendedSongs];
      searchResults = all.where((s) =>
          s.title.toLowerCase().contains(query.toLowerCase()) ||
          s.artist.toLowerCase().contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }

  void toggleFavorite(SongModel song) {
    song.isFavorite = !song.isFavorite;
    StorageService.toggleFavorite(song.id, song.isFavorite);
    notifyListeners();
  }
}
