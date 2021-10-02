class SongTrackModel {
  final int trackId;

  final String? name;
  final String? artist;
  final String? albumName;
  final String? trackname;
  final String? explicit;
  final String? rating;

  SongTrackModel({
    required this.trackId,
    required this.name,
    required this.artist,
    required this.albumName,
    required this.trackname,
    required this.explicit,
    required this.rating,
  });
}

class SongTrackLyricsModel {
  final int lyricsId;

  SongTrackLyricsModel({
    required this.lyricsId,
  });
}
