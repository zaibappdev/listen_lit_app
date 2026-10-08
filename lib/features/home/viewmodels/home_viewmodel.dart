import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio;
import '../../../../data/models/song_model.dart';
import '../../../../data/repositories/online_music_repository.dart';
import '../../../../data/services/storage_service.dart';

class HomeViewModel extends ChangeNotifier {
  final JamendoMusicRepository _onlineRepository = JamendoMusicRepository();
  final audio.OnAudioQuery _audioQuery = audio.OnAudioQuery();
  Timer? _searchDebounce;
  late final StreamSubscription<dynamic> _favoriteSubscription;

  List<SongModel> featuredSongs = [];
  List<SongModel> recommendedSongs = [];
  List<String> categories = [];
  List<SongModel> searchResults = [];

  bool isLocalSection = true; // Local music is the first view after onboarding.
  String localSubTab = 'Songs'; // Songs, Albums, Artists, Folders, Playlists
  List<audio.SongModel> localDeviceSongs = [];
  List<audio.AlbumModel> localDeviceAlbums = [];
  List<audio.ArtistModel> localDeviceArtists = [];
  List<audio.PlaylistModel> localDevicePlaylists = [];
  bool isLocalLoading = false;
  String localSortOrder = 'name'; // name, date, duration

  bool isLoading = false;
  bool isSearchLoading = false;
  String? onlineError;
  String searchQuery = '';
  String selectedCategory = 'All';

  HomeViewModel() {
    _favoriteSubscription = StorageService.favoriteChanges.listen((_) {
      for (final song in [
        ...featuredSongs,
        ...recommendedSongs,
        ...searchResults,
      ]) {
        song.isFavorite = StorageService.isFavorite(song.id);
      }
      notifyListeners();
    });
    loadData();
    if (StorageService.getPermissionHandled()) {
      loadLocalMusic();
    }
  }

  Future<void> loadData() async {
    isLoading = true;
    onlineError = null;
    notifyListeners();

    categories = const [
      'All',
      'Pop',
      'Rock',
      'Hip Hop',
      'Chill',
      'Workout',
      'Jazz',
      'Electronic',
      'Synthwave',
      'Ambient',
    ];
    if (!_onlineRepository.isConfigured) {
      featuredSongs = [];
      recommendedSongs = [];
      onlineError =
          'Set JAMENDO_CLIENT_ID at build time to browse licensed music.';
      isLoading = false;
      notifyListeners();
      return;
    }
    try {
      final tracks = await _onlineRepository.featured(limit: 30);
      featuredSongs = tracks.take(10).toList(growable: false);
      recommendedSongs = tracks.skip(10).toList(growable: false);
      for (final song in tracks) {
        song.isFavorite = StorageService.isFavorite(song.id);
      }
    } on OnlineMusicException catch (error) {
      onlineError = error.message;
      featuredSongs = [];
      recommendedSongs = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
    } catch (_) {}
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
      onlineError = null;
      isSearchLoading = false;
      notifyListeners();
    } else {
      unawaited(_searchGenre(category));
    }
  }

  Future<void> _searchGenre(String genre) async {
    if (!_onlineRepository.isConfigured) {
      onlineError =
          'Set JAMENDO_CLIENT_ID at build time to browse licensed music.';
      notifyListeners();
      return;
    }
    isSearchLoading = true;
    onlineError = null;
    notifyListeners();
    try {
      searchResults = await _onlineRepository.byGenre(genre);
      for (final song in searchResults) {
        song.isFavorite = StorageService.isFavorite(song.id);
      }
    } on OnlineMusicException catch (error) {
      searchResults = [];
      onlineError = error.message;
    } finally {
      isSearchLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    searchQuery = query;
    _searchDebounce?.cancel();
    if (query.trim().isEmpty) {
      searchResults = [];
      isSearchLoading = false;
      onlineError = null;
      notifyListeners();
      return;
    }
    isSearchLoading = true;
    onlineError = null;
    notifyListeners();
    if (!_onlineRepository.isConfigured) {
      isSearchLoading = false;
      onlineError =
          'Set JAMENDO_CLIENT_ID at build time to search licensed music.';
      notifyListeners();
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final results = await _onlineRepository.search(query);
        searchResults = results;
        for (final song in results) {
          song.isFavorite = StorageService.isFavorite(song.id);
        }
      } on OnlineMusicException catch (error) {
        searchResults = [];
        onlineError = error.message;
      } finally {
        isSearchLoading = false;
        notifyListeners();
      }
    });
  }

  void toggleFavorite(SongModel song) {
    song.isFavorite = !song.isFavorite;
    StorageService.toggleFavorite(song.id, song.isFavorite, song: song);
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _favoriteSubscription.cancel();
    _onlineRepository.close();
    super.dispose();
  }
}
