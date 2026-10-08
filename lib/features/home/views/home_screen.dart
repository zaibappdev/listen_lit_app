import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../music/viewmodels/player_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();
    final playerVM = context.read<PlayerViewModel>();

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(color: AppColor.kGreyColor, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Music Lover 🎧',
                        style: TextStyle(
                          color: AppColor.kLightAccentColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppColor.kPrimary,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Search Bar
              TextField(
                onChanged: (val) => homeVM.search(val),
                style: TextStyle(color: AppColor.kLightAccentColor),
                decoration: InputDecoration(
                  hintText: 'Search songs, artists...',
                  hintStyle: TextStyle(color: AppColor.kGreyColor),
                  prefixIcon: Icon(Icons.search, color: AppColor.kGreyColor),
                  filled: true,
                  fillColor: AppColor.kSamiDarkColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Search Results or Home Content
              if (homeVM.searchQuery.isNotEmpty) ...[
                Text(
                  'Search Results',
                  style: TextStyle(
                    color: AppColor.kLightAccentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                homeVM.searchResults.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text('No tracks found', style: TextStyle(color: AppColor.kGreyColor)),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: homeVM.searchResults.length,
                        itemBuilder: (context, index) {
                          final song = homeVM.searchResults[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(song.coverUrl, width: 48, height: 48, fit: BoxFit.cover),
                            ),
                            title: Text(song.title, style: TextStyle(color: AppColor.kLightAccentColor)),
                            subtitle: Text(song.artist, style: TextStyle(color: AppColor.kGreyColor)),
                            trailing: IconButton(
                              icon: Icon(
                                song.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: song.isFavorite ? AppColor.kPrimary : AppColor.kGreyColor,
                              ),
                              onPressed: () => homeVM.toggleFavorite(song),
                            ),
                            onTap: () => playerVM.playSong(homeVM.searchResults, index),
                          );
                        },
                      ),
              ] else ...[
                // Categories
                Text(
                  'Categories',
                  style: TextStyle(
                    color: AppColor.kLightAccentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeVM.categories.length,
                    itemBuilder: (context, index) {
                      final cat = homeVM.categories[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: index == 0 ? AppColor.kPrimary : AppColor.kSamiDarkColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: index == 0 ? Colors.white : AppColor.kLightAccentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Featured Music
                Text(
                  'Featured Tracks',
                  style: TextStyle(
                    color: AppColor.kLightAccentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeVM.featuredSongs.length,
                    itemBuilder: (context, index) {
                      final song = homeVM.featuredSongs[index];
                      return GestureDetector(
                        onTap: () => playerVM.playSong(homeVM.featuredSongs, index),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  song.coverUrl,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                song.title,
                                style: TextStyle(
                                  color: AppColor.kLightAccentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                song.artist,
                                style: TextStyle(
                                  color: AppColor.kGreyColor,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Recommended Music
                Text(
                  'Recommended for You',
                  style: TextStyle(
                    color: AppColor.kLightAccentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeVM.recommendedSongs.length,
                  itemBuilder: (context, index) {
                    final song = homeVM.recommendedSongs[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(song.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(song.title, style: TextStyle(color: AppColor.kLightAccentColor)),
                      subtitle: Text(song.artist, style: TextStyle(color: AppColor.kGreyColor)),
                      trailing: IconButton(
                        icon: Icon(
                          song.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: song.isFavorite ? AppColor.kPrimary : AppColor.kGreyColor,
                        ),
                        onPressed: () => homeVM.toggleFavorite(song),
                      ),
                      onTap: () => playerVM.playSong(homeVM.recommendedSongs, index),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
