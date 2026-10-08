import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/player_viewmodel.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final playerVM = context.watch<PlayerViewModel>();
    final song = playerVM.currentSong;

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: AppColor.kLightAccentColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(color: AppColor.kLightAccentColor, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: song == null
          ? Center(
              child: Text(
                'No Song Playing',
                style: TextStyle(color: AppColor.kGreyColor, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Album Art
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.kPrimary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        song.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColor.kPrimary,
                          child: const Icon(Icons.music_note, size: 80, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title and Artist
                  Text(
                    song.title,
                    style: TextStyle(
                      color: AppColor.kLightAccentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: AppColor.kGreyColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Progress Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColor.kPrimary,
                      inactiveTrackColor: AppColor.kGreyColor.withValues(alpha: 0.3),
                      thumbColor: AppColor.kPrimary,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      min: 0,
                      max: playerVM.duration.inMilliseconds.toDouble() > 0
                          ? playerVM.duration.inMilliseconds.toDouble()
                          : 1.0,
                      value: playerVM.position.inMilliseconds
                          .toDouble()
                          .clamp(0.0, playerVM.duration.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        playerVM.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(playerVM.position),
                          style: TextStyle(color: AppColor.kGreyColor, fontSize: 12),
                        ),
                        Text(
                          _formatDuration(playerVM.duration),
                          style: TextStyle(color: AppColor.kGreyColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, size: 36, color: AppColor.kLightAccentColor),
                        onPressed: () => playerVM.previous(),
                      ),
                      const SizedBox(width: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.kPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            playerVM.isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () => playerVM.togglePlayPause(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: Icon(Icons.skip_next, size: 36, color: AppColor.kLightAccentColor),
                        onPressed: () => playerVM.next(),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
    );
  }
}
