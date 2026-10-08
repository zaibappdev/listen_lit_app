import '../models/song_model.dart';

class MusicRepository {
  List<String> getCategories() {
    return [
      'All',
      'Pop',
      'Rock',
      'Hip Hop',
      'Chill',
      'Workout',
      'Jazz',
      'Electronic',
      'Synthwave',
      'Ambient',
    ];
  }

  List<SongModel> getAllSongs() {
    final List<SongModel> songs = [];
    final titles = [
      'Cosmic Chill', 'Midnight Echo', 'Neon Horizon', 'Starlight Serenade', 'Electric Dream',
      'Urban Sunset', 'Golden Rays', 'Velvet Night', 'Infinite Space', 'Pulse of the City',
      'Ocean Breeze', 'Quantum Leap', 'Solar Flare', 'Lunar Eclipse', 'Cybernetic Heart',
      'Retro Wave', 'Smooth Horizon', 'Deep Focus', 'Mountain High', 'Desert Mirage',
      'Rainfall Melody', 'Stellar Wind', 'Neon Lights', 'Crystal Cave', 'Thunderstorm Groove',
      'Cosmic dust', 'Astral Journey', 'Horizon Chase', 'Midnight Train', 'Dreamer State',
      'Echoes of Time', 'Galaxy Groove', 'Nebula Ride', 'Supersonic Vibe', 'Titanium Beat'
    ];

    final artists = [
      'Astral Wave', 'Lumina', 'Cyber Pulse', 'Celestial', 'Volt',
      'Metro Vibe', 'Solstice', 'Nova', 'Aether', 'Synapse',
      'Echo Sound', 'Prism', 'Apex', 'Horizon', 'Vortex',
      'Stellar', 'Krypton', 'Zenith', 'Polaris', 'Orion',
      'Helix', 'Quantum', 'Nebula', 'Titan', 'Atlas',
      'Phoenix', 'Gravity', 'Matrix', 'Spectrum', 'Cipher',
      'Eclipse', 'Radiant', 'Stardust', 'Infinite', 'Chronos'
    ];

    final albums = [
      'Galaxy Grooves', 'Nightfall', 'Synth City', 'Aether', 'Currents',
      'City Lights', 'Sunshine', 'Midnight', 'Universe', 'Metropolis',
      'Coastline', 'Physics', 'Sun', 'Moon', 'Android',
      '80s Dream', 'Panorama', 'Mindscape', 'Altitude', 'Mirage',
      'Monsoon', 'Galactic', 'Illumination', 'Underground', 'Storm',
      'Stardust', 'Voyage', 'Speedway', 'Express', 'Somnia',
      'Relics', 'Cosmos', 'Deep Space', 'Supersonic', 'Metal'
    ];

    final categories = [
      'Chill', 'Electronic', 'Synthwave', 'Ambient', 'Pop',
      'Rock', 'Jazz', 'Workout', 'Hip Hop', 'Electronic',
      'Chill', 'Synthwave', 'Ambient', 'Pop', 'Rock',
      'Electronic', 'Chill', 'Ambient', 'Workout', 'Hip Hop',
      'Chill', 'Electronic', 'Synthwave', 'Ambient', 'Rock',
      'Pop', 'Jazz', 'Workout', 'Hip Hop', 'Chill',
      'Electronic', 'Synthwave', 'Ambient', 'Pop', 'Rock'
    ];

    for (int i = 0; i < 35; i++) {
      final id = '${i + 1}';
      final title = titles[i % titles.length];
      final artist = artists[i % artists.length];
      final album = albums[i % albums.length];
      final category = categories[i % categories.length];
      final trackNum = (i % 16) + 1;
      
      songs.add(
        SongModel(
          id: id,
          title: title,
          artist: artist,
          album: album,
          duration: '${3 + (i % 3)}:${10 + (i * 7) % 50}',
          coverUrl: 'https://picsum.photos/seed/music_track_$id/300/300',
          audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$trackNum.mp3',
          category: category,
        ),
      );
    }
    return songs;
  }

  List<SongModel> getFeaturedSongs() {
    final all = getAllSongs();
    return all.take(10).toList();
  }

  List<SongModel> getRecommendedSongs() {
    final all = getAllSongs();
    return all.skip(10).take(15).toList();
  }

  List<SongModel> getSongsByCategory(String category) {
    final all = getAllSongs();
    if (category == 'All') return all;
    return all.where((s) => s.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
