import 'package:flutter/foundation.dart';
import '../../../../data/models/song_model.dart';
import '../../../../data/repositories/music_repository.dart';
import '../../../../data/services/storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final MusicRepository _repository = MusicRepository();
  List<SongModel> favorites = [];
  List<SongModel> recentlyPlayed = [];

  ProfileViewModel() {
    loadProfileData();
  }

  void loadProfileData() {
    final all = _repository.getAllSongs();
    
    favorites = all.where((s) => StorageService.isFavorite(s.id)).toList();
    
    final recentIds = StorageService.getRecent();
    recentlyPlayed = all.where((s) => recentIds.contains(s.id)).toList();

    notifyListeners();
  }
}
