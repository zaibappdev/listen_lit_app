import '../models/song_model.dart';
import '../../core/constant/app_images.dart';

class MusicRepository {
  List<SongModel> getFeaturedSongs() {
    return [
      SongModel(
        id: '1',
        title: 'Cosmic Chill',
        artist: 'Astral Wave',
        album: 'Galaxy Grooves',
        duration: '3:45',
        coverUrl: AppImagePath.kOnboarding1,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      ),
      SongModel(
        id: '2',
        title: 'Midnight Echo',
        artist: 'Lumina',
        album: 'Nightfall',
        duration: '4:12',
        coverUrl: AppImagePath.kOnboarding2,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      ),
      SongModel(
        id: '3',
        title: 'Neon Horizon',
        artist: 'Cyber Pulse',
        album: 'Synth City',
        duration: '3:30',
        coverUrl: AppImagePath.kOnboarding3,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      ),
    ];
  }

  List<SongModel> getRecommendedSongs() {
    return [
      SongModel(
        id: '4',
        title: 'Starlight Serenade',
        artist: 'Celestial',
        album: 'Aether',
        duration: '3:15',
        coverUrl: AppImagePath.kRectangleBackground,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      ),
      SongModel(
        id: '5',
        title: 'Electric Dream',
        artist: 'Volt',
        album: 'Currents',
        duration: '4:02',
        coverUrl: AppImagePath.kOnboarding1,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      ),
      SongModel(
        id: '6',
        title: 'Urban Sunset',
        artist: 'Metro Vibe',
        album: 'City Lights',
        duration: '2:58',
        coverUrl: AppImagePath.kOnboarding2,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      ),
    ];
  }

  List<String> getCategories() {
    return [
      'Electronic',
      'Chillout',
      'Synthwave',
      'Ambient',
      'Pop',
      'Rock',
      'Classical',
    ];
  }
}
