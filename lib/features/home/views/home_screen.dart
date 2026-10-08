import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../data/models/song_model.dart';
import '../../music/viewmodels/player_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../profile/views/profile_screen.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../../../shared/widgets/network_image_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();
    final playerVM = context.read<PlayerViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.kPrimary,
          onRefresh: () async {
            if (homeVM.isLocalSection) {
              await homeVM.loadLocalMusic();
            } else {
              await homeVM.loadData();
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Tappable Profile Avatar & Segmented Switch
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: AppColor.kGreyColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.name ?? 'Music Lover 🎧',
                            style: TextStyle(
                              color: AppColor.kLightAccentColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColor.kPrimary,
                          child: user?.avatarUrl.isNotEmpty == true
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.network(
                                    user!.avatarUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  user?.name.isNotEmpty == true
                                      ? user!.name[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Segmented Switch: Online vs Local
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.kSamiDarkColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => homeVM.switchSection(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: homeVM.isLocalSection
                                    ? AppColor.kPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Local (Device)',
                                  style: TextStyle(
                                    color: homeVM.isLocalSection
                                        ? Colors.white
                                        : AppColor.kGreyColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => homeVM.switchSection(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !homeVM.isLocalSection
                                    ? AppColor.kPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Online Music',
                                  style: TextStyle(
                                    color: !homeVM.isLocalSection
                                        ? Colors.white
                                        : AppColor.kGreyColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (homeVM.isLocalSection) ...[
                  // Local Section Content
                  if (homeVM.isLocalLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (homeVM.localDeviceSongs.isEmpty) ...[
                    // Fallback Logic when no device music found
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColor.kSamiDarkColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.music_off,
                            size: 48,
                            color: AppColor.kPrimary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No music found on your device. Here is some online music for you.',
                            style: TextStyle(
                              color: AppColor.kLightAccentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.kPrimary,
                            ),
                            onPressed: () => homeVM.loadLocalMusic(),
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Rescan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Featured Online Tracks',
                        style: TextStyle(
                          color: AppColor.kLightAccentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: homeVM.featuredSongs.length,
                      itemBuilder: (context, index) {
                        final song = homeVM.featuredSongs[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: NetworkImageWidget(
                            url: song.coverUrl,
                            width: 50,
                            height: 50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            song.title,
                            style: TextStyle(
                              color: AppColor.kLightAccentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _creditLine(song),
                            style: TextStyle(color: AppColor.kGreyColor),
                          ),
                          onTap: () =>
                              playerVM.playSong(homeVM.featuredSongs, index),
                        );
                      },
                    ),
                  ] else ...[
                    // Local Sub-tabs: Songs, Albums, Artists, Folders, Playlists
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children:
                            [
                              'Songs',
                              'Albums',
                              'Artists',
                              'Folders',
                              'Playlists',
                            ].map((tab) {
                              final isSelected = homeVM.localSubTab == tab;
                              return GestureDetector(
                                onTap: () => homeVM.setLocalSubTab(tab),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColor.kPrimary
                                        : AppColor.kSamiDarkColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      tab,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColor.kLightAccentColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sort options for Local Songs
                    if (homeVM.localSubTab == 'Songs') ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Sort by: ',
                              style: TextStyle(
                                color: AppColor.kGreyColor,
                                fontSize: 12,
                              ),
                            ),
                            DropdownButton<String>(
                              dropdownColor: AppColor.kSamiDarkColor,
                              value: homeVM.localSortOrder,
                              items: const [
                                DropdownMenuItem(
                                  value: 'name',
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'date',
                                  child: Text(
                                    'Date Added',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'duration',
                                  child: Text(
                                    'Duration',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) homeVM.setLocalSortOrder(val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Display Local Content based on sub-tab
                    if (homeVM.localSubTab == 'Songs')
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeVM.localDeviceSongs.length,
                        itemBuilder: (context, index) {
                          final ds = homeVM.localDeviceSongs[index];
                          final song = homeVM.convertDeviceSong(ds);
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColor.kPrimary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              song.title,
                              style: TextStyle(
                                color: AppColor.kLightAccentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              _creditLine(song),
                              style: TextStyle(color: AppColor.kGreyColor),
                            ),
                            trailing: Text(
                              song.duration,
                              style: TextStyle(
                                color: AppColor.kGreyColor,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () {
                              final mappedQueue = homeVM.localDeviceSongs
                                  .map((e) => homeVM.convertDeviceSong(e))
                                  .toList();
                              playerVM.playSong(mappedQueue, index);
                            },
                          );
                        },
                      )
                    else if (homeVM.localSubTab == 'Albums')
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeVM.localDeviceAlbums.length,
                        itemBuilder: (context, index) {
                          final album = homeVM.localDeviceAlbums[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.album,
                              color: Colors.white,
                              size: 40,
                            ),
                            title: Text(
                              album.album,
                              style: TextStyle(
                                color: AppColor.kLightAccentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${album.numOfSongs} songs',
                              style: TextStyle(color: AppColor.kGreyColor),
                            ),
                          );
                        },
                      )
                    else if (homeVM.localSubTab == 'Artists')
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeVM.localDeviceArtists.length,
                        itemBuilder: (context, index) {
                          final artist = homeVM.localDeviceArtists[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                            title: Text(
                              artist.artist,
                              style: TextStyle(
                                color: AppColor.kLightAccentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${artist.numberOfTracks} tracks',
                              style: TextStyle(color: AppColor.kGreyColor),
                            ),
                          );
                        },
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'No items found in ${homeVM.localSubTab}',
                            style: TextStyle(color: AppColor.kGreyColor),
                          ),
                        ),
                      ),
                  ],
                ] else ...[
                  // Online Section Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (val) => homeVM.search(val),
                      style: TextStyle(color: AppColor.kLightAccentColor),
                      decoration: InputDecoration(
                        hintText: 'Search songs, 30+ tracks, artists...',
                        hintStyle: TextStyle(color: AppColor.kGreyColor),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColor.kGreyColor,
                        ),
                        filled: true,
                        fillColor: AppColor.kSamiDarkColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: homeVM.categories.length,
                      itemBuilder: (context, index) {
                        final cat = homeVM.categories[index];
                        final isSelected = homeVM.selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => homeVM.filterByCategory(cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColor.kPrimary
                                  : AppColor.kSamiDarkColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColor.kLightAccentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (homeVM.searchQuery.isNotEmpty ||
                      homeVM.selectedCategory != 'All') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        homeVM.selectedCategory != 'All'
                            ? '${homeVM.selectedCategory} Tracks'
                            : 'Search Results',
                        style: TextStyle(
                          color: AppColor.kLightAccentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    homeVM.searchResults.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(
                                'No tracks found',
                                style: TextStyle(color: AppColor.kGreyColor),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: homeVM.searchResults.length,
                            itemBuilder: (context, index) {
                              final song = homeVM.searchResults[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: NetworkImageWidget(
                                  url: song.coverUrl,
                                  width: 50,
                                  height: 50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                title: Text(
                                  song.title,
                                  style: TextStyle(
                                    color: AppColor.kLightAccentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  _creditLine(song),
                                  style: TextStyle(color: AppColor.kGreyColor),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    song.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: song.isFavorite
                                        ? AppColor.kPrimary
                                        : AppColor.kGreyColor,
                                  ),
                                  onPressed: () => homeVM.toggleFavorite(song),
                                ),
                                onTap: () => playerVM.playSong(
                                  homeVM.searchResults,
                                  index,
                                ),
                              );
                            },
                          ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Featured Tracks',
                        style: TextStyle(
                          color: AppColor.kLightAccentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (homeVM.onlineError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          homeVM.onlineError!,
                          style: TextStyle(color: AppColor.kGreyColor),
                        ),
                      ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeVM.featuredSongs.length,
                        itemBuilder: (context, index) {
                          final song = homeVM.featuredSongs[index];
                          return GestureDetector(
                            onTap: () =>
                                playerVM.playSong(homeVM.featuredSongs, index),
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NetworkImageWidget(
                                    url: song.coverUrl,
                                    width: 140,
                                    height: 140,
                                    borderRadius: BorderRadius.circular(12),
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
                                    _creditLine(song),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Recommended for You (30+ Tracks)',
                        style: TextStyle(
                          color: AppColor.kLightAccentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (homeVM.onlineError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          homeVM.onlineError!,
                          style: TextStyle(color: AppColor.kGreyColor),
                        ),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: homeVM.recommendedSongs.length,
                      itemBuilder: (context, index) {
                        final song = homeVM.recommendedSongs[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: NetworkImageWidget(
                            url: song.coverUrl,
                            width: 50,
                            height: 50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            song.title,
                            style: TextStyle(
                              color: AppColor.kLightAccentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _creditLine(song),
                            style: TextStyle(color: AppColor.kGreyColor),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              song.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: song.isFavorite
                                  ? AppColor.kPrimary
                                  : AppColor.kGreyColor,
                            ),
                            onPressed: () => homeVM.toggleFavorite(song),
                          ),
                          onTap: () =>
                              playerVM.playSong(homeVM.recommendedSongs, index),
                        );
                      },
                    ),
                  ],
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _creditLine(SongModel song) {
    if (song.providerName.isEmpty) return song.artist;
    return '${song.artist} · ${song.providerName} · Creative Commons';
  }
}
