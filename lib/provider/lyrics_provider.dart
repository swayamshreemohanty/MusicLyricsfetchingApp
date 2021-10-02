import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:song_lyrics/models/song_track_model.dart';
import 'package:http/http.dart' as http;

class LyricsDataProvider with ChangeNotifier {
  List<SongTrackModel> _songscard = [];

  List<SongTrackModel> get songscard {
    return [..._songscard];
  }

  final String apiKey = "f253441f9bb90fde34eb5c53da5bdbf0";
  Future<dynamic> fetchAndSetSongsLyrics(int trackId) async {
    // print("provider Track ID");
    // print(trackId);
    var url = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=$apiKey");

    try {
      print("Fetching Data........");
      final response = await http.get(url);
      var extractedLyricsData =
          json.decode(response.body)['message']['body']['lyrics'];
      ;
      // final List<SongTrackModel> loadedTracks = []; //empty temporary list

      if (extractedLyricsData.isEmpty) {
        _songscard.clear();
        return "0";
      }
      // print("Extracted Lyrics Data");
      // print(extractedLyricsData);
      notifyListeners();
      return extractedLyricsData;
    } catch (error) {
      // print("Lyrics fetching Error");
    }
  }

  Future<void> fetchAndSetSongsChart() async {
    int songListNum = 10;
    var url = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?chart_name=top&page=1&page_size=songListNum&country=india&f_has_lyrics=1&apikey=$apiKey");

    try {
      // print("Fetching Data........");
      final response = await http.get(url);
      var extractedData =
          await json.decode(response.body)['message']['body']['track_list'];
      final List<SongTrackModel> loadedTracks = []; //empty temporary list

      if (extractedData.isEmpty) {
        _songscard.clear();
        return;
      }
      // print("Extracted Data");
      // print(extractedData);

      for (var i = 0; i < songListNum; i++) {
        loadedTracks.add(
          SongTrackModel(
            trackId: extractedData[i]['track']['track_id'],
            name: extractedData[i]['track']['track_name'].toString(),
            artist: extractedData[i]['track']['artist_name'].toString(),
            albumName: extractedData[i]['track']['album_name'].toString(),
            trackname: extractedData[i]['track']['track_name'].toString(),
            explicit: extractedData[i]['track']['explicit'].toString(),
            rating: extractedData[i]['track']['track_rating'].toString(),
          ),
        );
      }
      _songscard = loadedTracks;
    } catch (error) {
      print("Chart fetching Error");
      _songscard = [];
    }
    notifyListeners();
  }
}
