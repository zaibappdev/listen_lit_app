class SongModel {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String duration;
  final String coverUrl;
  final String audioUrl;
  bool isFavorite;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.coverUrl,
    required this.audioUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'album': album,
        'duration': duration,
        'coverUrl': coverUrl,
        'audioUrl': audioUrl,
        'isFavorite': isFavorite,
      };

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        artist: json['artist'] ?? '',
        album: json['album'] ?? '',
        duration: json['duration'] ?? '3:45',
        coverUrl: json['coverUrl'] ?? '',
        audioUrl: json['audioUrl'] ?? '',
        isFavorite: json['isFavorite'] ?? false,
      );
}
