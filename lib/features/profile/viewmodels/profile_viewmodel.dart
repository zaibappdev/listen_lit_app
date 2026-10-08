import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../../../data/models/song_model.dart';
import '../../../../data/services/storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  List<SongModel> favorites = [];
  List<SongModel> recentlyPlayed = [];
  late final StreamSubscription<dynamic> _favoriteSubscription;
  late final StreamSubscription<dynamic> _recentSubscription;

  ProfileViewModel() {
    _favoriteSubscription = StorageService.favoriteChanges.listen(
      (_) => loadProfileData(),
    );
    _recentSubscription = StorageService.recentChanges.listen(
      (_) => loadProfileData(),
    );
    loadProfileData();
  }

  void loadProfileData() {
    favorites = StorageService.getFavoriteSongs();
    recentlyPlayed = StorageService.getRecentSongs();

    notifyListeners();
  }

  @override
  void dispose() {
    _favoriteSubscription.cancel();
    _recentSubscription.cancel();
    super.dispose();
  }
}
