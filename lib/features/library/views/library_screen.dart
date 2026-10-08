import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/app_colors.dart';
import '../viewmodels/library_viewmodel.dart';
import '../../music/viewmodels/player_viewmodel.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../data/models/song_model.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibraryViewModel(),
      child: Consumer2<LibraryViewModel, PlayerViewModel>(
        builder: (context, libraryVM, playerVM, child) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: AppColor.kBGColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Your Library', style: TextStyle(color: AppColor.kLightAccentColor, fontWeight: FontWeight.bold)),
                centerTitle: true,
                bottom: TabBar(
                  labelColor: AppColor.kPrimary,
                  unselectedLabelColor: AppColor.kGreyColor,
                  indicatorColor: AppColor.kPrimary,
                  tabs: const [
                    Tab(text: 'Favorites'),
                    Tab(text: 'Recent'),
                    Tab(text: 'Downloaded'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildSongList(libraryVM.favorites, playerVM, libraryVM, 'No favorite tracks yet'),
                  _buildSongList(libraryVM.recentlyPlayed, playerVM, libraryVM, 'No recently played tracks'),
                  _buildSongList(libraryVM.downloadedSongs, playerVM, libraryVM, 'No downloaded tracks'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongList(List<SongModel> songs, PlayerViewModel playerVM, LibraryViewModel libraryVM, String emptyMessage) {
    if (songs.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(color: AppColor.kGreyColor, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: NetworkImageWidget(
            url: song.coverUrl,
            width: 50,
            height: 50,
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(song.title, style: TextStyle(color: AppColor.kLightAccentColor, fontWeight: FontWeight.w600)),
          subtitle: Text(song.artist, style: TextStyle(color: AppColor.kGreyColor)),
          trailing: IconButton(
            icon: Icon(
              song.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: song.isFavorite ? AppColor.kPrimary : AppColor.kGreyColor,
            ),
            onPressed: () => libraryVM.toggleFavorite(song),
          ),
          onTap: () => playerVM.playSong(songs, index),
        );
      },
    );
  }
}
