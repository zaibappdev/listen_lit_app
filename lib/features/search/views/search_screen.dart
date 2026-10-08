import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/app_colors.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../music/viewmodels/player_viewmodel.dart';
import '../../../shared/widgets/network_image_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();
    final playerVM = context.read<PlayerViewModel>();

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Search Music', style: TextStyle(color: AppColor.kLightAccentColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (val) => homeVM.search(val),
                style: TextStyle(color: AppColor.kLightAccentColor),
                decoration: InputDecoration(
                  hintText: 'Search 30+ tracks, artists, albums...',
                  hintStyle: TextStyle(color: AppColor.kGreyColor),
                  prefixIcon: Icon(Icons.search, color: AppColor.kPrimary),
                  filled: true,
                  fillColor: AppColor.kSamiDarkColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Categories / Genres chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeVM.categories.length,
                  itemBuilder: (context, index) {
                    final cat = homeVM.categories[index];
                    final isSelected = homeVM.selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => homeVM.filterByCategory(cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColor.kPrimary : AppColor.kSamiDarkColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColor.kLightAccentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: homeVM.searchQuery.isNotEmpty || homeVM.selectedCategory != 'All'
                    ? (homeVM.searchResults.isEmpty
                        ? Center(
                            child: Text(
                              'No music found matching your search.',
                              style: TextStyle(color: AppColor.kGreyColor, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: homeVM.searchResults.length,
                            itemBuilder: (context, index) {
                              final song = homeVM.searchResults[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                leading: NetworkImageWidget(
                                  url: song.coverUrl,
                                  width: 50,
                                  height: 50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                title: Text(song.title, style: TextStyle(color: AppColor.kLightAccentColor, fontWeight: FontWeight.w600)),
                                subtitle: Text('${song.artist} • ${song.album}', style: TextStyle(color: AppColor.kGreyColor)),
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
                          ))
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.headset, size: 64, color: AppColor.kPrimary.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            Text(
                              'Explore our 30+ track music catalog',
                              style: TextStyle(color: AppColor.kGreyColor, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
