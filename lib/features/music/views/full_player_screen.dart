import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/player_viewmodel.dart';
import '../../../../data/services/storage_service.dart';

class FullPlayerScreen extends StatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen> {
  PaletteGenerator? _paletteGenerator;

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  Future<void> _updatePalette() async {
    final playerVM = context.read<PlayerViewModel>();
    final song = playerVM.currentSong;
    if (song != null && song.coverUrl.isNotEmpty) {
      try {
        final palette = await PaletteGenerator.fromImageProvider(
          NetworkImage(song.coverUrl),
        );
        setState(() {
          _paletteGenerator = palette;
        });
      } catch (_) {
        try {
          final palette = await PaletteGenerator.fromImageProvider(
            AssetImage(song.coverUrl),
          );
          setState(() {
            _paletteGenerator = palette;
          });
        } catch (_) {}
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showQueueBottomSheet(BuildContext context, PlayerViewModel playerVM) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.kSamiDarkColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Up Next (Queue)', style: TextStyle(color: AppColor.kLightAccentColor, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: playerVM.currentQueue.isEmpty
                  ? Center(child: Text('Queue is empty', style: TextStyle(color: AppColor.kGreyColor)))
                  : ListView.builder(
                      itemCount: playerVM.currentQueue.length,
                      itemBuilder: (context, index) {
                        final song = playerVM.currentQueue[index];
                        final isCurrent = song.id == playerVM.currentSong?.id;
                        return ListTile(
                          title: Text(song.title, style: TextStyle(color: isCurrent ? AppColor.kPrimary : AppColor.kLightAccentColor, fontWeight: FontWeight.w600)),
                          subtitle: Text(song.artist, style: TextStyle(color: AppColor.kGreyColor)),
                          trailing: isCurrent ? Icon(Icons.volume_up, color: AppColor.kPrimary) : null,
                          onTap: () {
                            playerVM.playSong(playerVM.currentQueue, index);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSleepTimerSheet(BuildContext context, PlayerViewModel playerVM) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.kSamiDarkColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sleep Timer', style: TextStyle(color: AppColor.kLightAccentColor, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              title: Text('15 Minutes', style: TextStyle(color: AppColor.kLightAccentColor)),
              onTap: () {
                playerVM.setSleepTimer(const Duration(minutes: 15));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sleep timer set for 15 minutes')));
              },
            ),
            ListTile(
              title: Text('30 Minutes', style: TextStyle(color: AppColor.kLightAccentColor)),
              onTap: () {
                playerVM.setSleepTimer(const Duration(minutes: 30));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sleep timer set for 30 minutes')));
              },
            ),
            ListTile(
              title: Text('45 Minutes', style: TextStyle(color: AppColor.kLightAccentColor)),
              onTap: () {
                playerVM.setSleepTimer(const Duration(minutes: 45));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sleep timer set for 45 minutes')));
              },
            ),
            ListTile(
              title: Text('60 Minutes', style: TextStyle(color: AppColor.kLightAccentColor)),
              onTap: () {
                playerVM.setSleepTimer(const Duration(minutes: 60));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sleep timer set for 60 minutes')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaybackSpeedSheet(BuildContext context, PlayerViewModel playerVM) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.kSamiDarkColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Playback Speed', style: TextStyle(color: AppColor.kLightAccentColor, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            for (var speed in [0.5, 0.75, 1.0, 1.25, 1.5, 2.0])
              ListTile(
                title: Text('${speed}x', style: TextStyle(color: playerVM.playbackSpeed == speed ? AppColor.kPrimary : AppColor.kLightAccentColor)),
                onTap: () {
                  playerVM.setSpeed(speed);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showSongInfoDialog(BuildContext context, song) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.kSamiDarkColor,
        title: Text('Song Info', style: TextStyle(color: AppColor.kLightAccentColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${song.title}', style: TextStyle(color: AppColor.kLightAccentColor)),
            const SizedBox(height: 8),
            Text('Artist: ${song.artist}', style: TextStyle(color: AppColor.kGreyColor)),
            const SizedBox(height: 8),
            Text('Album: ${song.album}', style: TextStyle(color: AppColor.kGreyColor)),
            const SizedBox(height: 8),
            Text('Duration: ${song.duration}', style: TextStyle(color: AppColor.kGreyColor)),
            const SizedBox(height: 8),
            Text('Source: ${song.audioUrl}', style: TextStyle(color: AppColor.kGreyColor), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColor.kPrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerVM = context.watch<PlayerViewModel>();
    final song = playerVM.currentSong;
    final dominantColor = _paletteGenerator?.dominantColor?.color ?? AppColor.kPrimary;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 300) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.kBGColor,
        body: Stack(
          children: [
            if (song != null && song.coverUrl.isNotEmpty)
              Positioned.fill(
                child: song.coverUrl.startsWith('http')
                    ? Image.network(
                        song.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: AppColor.kBGColor),
                      )
                    : Image.asset(
                        song.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: AppColor.kBGColor),
                      ),
              ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),
            SafeArea(
              child: song == null
                  ? Center(
                      child: Text(
                        'No Song Playing',
                        style: TextStyle(color: AppColor.kGreyColor, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_down, color: AppColor.kLightAccentColor, size: 30),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                'Now Playing',
                                style: TextStyle(color: AppColor.kLightAccentColor, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: AppColor.kLightAccentColor, size: 24),
                                onPressed: () async {
                                  await playerVM.stopPlayer();
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: dominantColor.withValues(alpha: 0.5),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: song.coverUrl.startsWith('http')
                                  ? Image.network(
                                      song.coverUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: AppColor.kPrimary,
                                        child: const Icon(Icons.music_note, size: 80, color: Colors.white),
                                      ),
                                    )
                                  : Image.asset(
                                      song.coverUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: AppColor.kPrimary,
                                        child: const Icon(Icons.music_note, size: 80, color: Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title,
                                      style: TextStyle(
                                        color: AppColor.kLightAccentColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      song.artist,
                                      style: TextStyle(
                                        color: AppColor.kGreyColor,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  song.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: song.isFavorite ? AppColor.kPrimary : AppColor.kLightAccentColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    song.isFavorite = !song.isFavorite;
                                    StorageService.toggleFavorite(song.id, song.isFavorite);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: dominantColor,
                              inactiveTrackColor: AppColor.kGreyColor.withValues(alpha: 0.3),
                              thumbColor: dominantColor,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.shuffle,
                                  color: playerVM.isShuffleEnabled ? dominantColor : AppColor.kGreyColor,
                                ),
                                onPressed: () => playerVM.toggleShuffle(),
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_previous, size: 36, color: AppColor.kLightAccentColor),
                                onPressed: () => playerVM.previous(),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: dominantColor,
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
                              IconButton(
                                icon: Icon(Icons.skip_next, size: 36, color: AppColor.kLightAccentColor),
                                onPressed: () => playerVM.next(),
                              ),
                              IconButton(
                                icon: Icon(
                                  playerVM.repeatMode == LoopMode.one
                                      ? Icons.repeat_one
                                      : playerVM.repeatMode == LoopMode.all
                                          ? Icons.repeat
                                          : Icons.repeat,
                                  color: playerVM.repeatMode != LoopMode.off ? dominantColor : AppColor.kGreyColor,
                                ),
                                onPressed: () => playerVM.cycleRepeatMode(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.queue_music, color: AppColor.kLightAccentColor),
                                tooltip: 'Queue',
                                onPressed: () => _showQueueBottomSheet(context, playerVM),
                              ),
                              IconButton(
                                icon: Icon(Icons.timer, color: AppColor.kLightAccentColor),
                                tooltip: 'Sleep Timer',
                                onPressed: () => _showSleepTimerSheet(context, playerVM),
                              ),
                              IconButton(
                                icon: Icon(Icons.speed, color: AppColor.kLightAccentColor),
                                tooltip: 'Playback Speed',
                                onPressed: () => _showPlaybackSpeedSheet(context, playerVM),
                              ),
                              IconButton(
                                icon: Icon(Icons.share, color: AppColor.kLightAccentColor),
                                tooltip: 'Share',
                                onPressed: () {
                                  Share.share('Check out ${song.title} by ${song.artist} on ListenLit!');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.info_outline, color: AppColor.kLightAccentColor),
                                tooltip: 'Song Info',
                                onPressed: () => _showSongInfoDialog(context, song),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
