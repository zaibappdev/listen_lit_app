import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio;
import '../../../../data/models/song_model.dart';
import '../../../../data/repositories/music_repository.dart';
import '../../../../data/services/storage_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MusicRepository _repository = MusicRepository();
  final audio.OnAudioQuery _audioQuery = audio.OnAudioQuery();

  List<SongModel> featuredSongs = [];
  List<SongModel> recommendedSongs = [];
  List<String> categories = [];
  List<SongModel> searchResults = [];

  bool isLocalSection = false; // false = Online, true = Local
  String localSubTab = 'Songs'; // Songs, Albums, Artists, Folders, Playlists
  List<audio.SongModel> localDeviceSongs = [];
  List<audio.AlbumModel> localDeviceAlbums = [];
  List<audio.ArtistModel> localDeviceArtists = [];
  List<audio.PlaylistModel> localDevicePlaylists = [];
  bool isLocalLoading = false;
  String localSortOrder = 'name'; // name, date, duration

  bool isLoading = false;
  String searchQuery = '';
  String selectedCategory = 'All';

  HomeViewModel() {
    loadData();
  }

  void loadData() {
    isLoading = true;
    notifyListeners();

    featuredSongs = _repository.getFeaturedSongs();
    recommendedSongs = _repository.getRecommendedSongs();
    categories = _repository.getCategories();

    for (var song in [...featuredSongs, ...recommendedSongs]) {
      song.isFavorite = StorageService.isFavorite(song.id);
    }

    isLoading = false;
    notifyListeners();
  }

  void switchSection(bool local) {
    isLocalSection = local;
    if (local && localDeviceSongs.isEmpty && !isLocalLoading) {
      loadLocalMusic();
    }
    notifyListeners();
  }

  Future<void> loadLocalMusic() async {
    isLocalLoading = true;
    notifyListeners();
    try {
      final hasPermission = await _audioQuery.checkAndRequest();
      if (hasPermission) {
        localDeviceSongs = await _audioQuery.querySongs(
          sortType: localSortOrder == 'date'
              ? audio.SongSortType.DATE_ADDED
              : localSortOrder == 'duration'
                  ? audio.SongSortType.DURATION
                  : audio.SongSortType.TITLE,
          orderType: audio.OrderType.ASC_OR_SMALLER,
          uriType: audio.UriType.EXTERNAL,
        );
        localDeviceAlbums = await _audioQuery.queryAlbums();
        localDeviceArtists = await _audioQuery.queryArtists();
        localDevicePlaylists = await _audioQuery.queryPlaylists();
      }
    } catch (e) {
      debugPrint('Error loading local music: $e');
    }
    isLocalLoading = false;
    notifyListeners();
  }

  void setLocalSubTab(String subTab) {
    localSubTab = subTab;
    notifyListeners();
  }

  void setLocalSortOrder(String sort) {
    localSortOrder = sort;
    loadLocalMusic();
  }

  SongModel convertDeviceSong(audio.SongModel ds) {
    return SongModel(
      id: ds.id.toString(),
      title: ds.title,
      artist: ds.artist ?? 'Unknown Artist',
      album: ds.album ?? 'Unknown Album',
      duration: _formatMillis(ds.duration ?? 0),
      coverUrl: '',
      audioUrl: ds.data,
      category: 'Local',
      isFavorite: StorageService.isFavorite(ds.id.toString()),
    );
  }

  String _formatMillis(int millis) {
    final minutes = (millis ~/ 1000) ~/ 60;
    final seconds = (millis ~/ 1000) % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    if (category == 'All') {
      searchResults = [];
      searchQuery = '';
    } else {
      searchResults = _repository.getSongsByCategory(category);
    }
    for (var song in searchResults) {
      song.isFavorite = StorageService.isFavorite(song.id);
    }
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    if (query.isEmpty && selectedCategory == 'All') {
      searchResults = [];
    } else {
      final all = _repository.getAllSongs();
      searchResults = all.where((s) {
        final matchesQuery = query.isEmpty ||
            s.title.toLowerCase().contains(query.toLowerCase()) ||
            s.artist.toLowerCase().contains(query.toLowerCase()) ||
            s.album.toLowerCase().contains(query.toLowerCase());
        final matchesCategory = selectedCategory == 'All' || s.category.toLowerCase() == selectedCategory.toLowerCase();
        return matchesQuery && (query.isEmpty ? matchesCategory : true);
      }).toList();
    }
    for (var song in searchResults) {
      song.isFavorite = StorageService.isFavorite(song.id);
    }
    notifyListeners();
  }

  void toggleFavorite(SongModel song) {
    song.isFavorite = !song.isFavorite;
    StorageService.toggleFavorite(song.id, song.isFavorite);
    notifyListeners();
  }
}
