import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/player_viewmodel.dart';
import '../views/full_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playerVM = context.watch<PlayerViewModel>();
    final song = playerVM.currentSong;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FullPlayerScreen()),
        );
      },
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColor.kSamiDarkColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                song.coverUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 48,
                  height: 48,
                  color: AppColor.kPrimary,
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 2),
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
            IconButton(
              icon: Icon(
                playerVM.isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColor.kLightAccentColor,
              ),
              onPressed: () => playerVM.togglePlayPause(),
            ),
            IconButton(
              icon: Icon(Icons.skip_next, color: AppColor.kLightAccentColor),
              onPressed: () => playerVM.next(),
            ),
          ],
        ),
      ),
    );
  }
}
