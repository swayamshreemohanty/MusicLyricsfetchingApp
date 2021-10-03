import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:song_lyrics/models/song_track_model.dart';
import 'package:http/http.dart' as http;

class LyricsDataProvider with ChangeNotifier {
  List<SongTrackModel> _songscard = [];

  List<SongTrackModel> get songscard {
    return [..._songscard];
  }

  var emptyLyrics = true;

  final String apiKey = "f253441f9bb90fde34eb5c53da5bdbf0";

  Future<dynamic> fetchAndSetTrackdetails(int trackId) async {
    // print("provider Track ID");
    // print(trackId);
    var url = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackId&apikey=$apiKey");

    try {
      print("Fetching Data........");
      final response = await http.get(url);
      var extractedTrackData =
          json.decode(response.body)['message']['body']['track'];

      // final List<SongTrackModel> loadedTracks = []; //empty temporary list
      print("Extracted track Data");
      print(extractedTrackData);
      if (extractedTrackData.isEmpty) {
        return emptyLyrics = true;
      } else {
        emptyLyrics = false;
        notifyListeners();
        return extractedTrackData;
      }
    } catch (error) {
      // print("Lyrics fetching Error");
      return emptyLyrics = true;
    }
  }

  Future<dynamic> fetchAndSetSongsLyrics(int trackId) async {
    // print("provider Track ID");
    // print(trackId);
    var url = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=$apiKey");

    try {
      // print("Fetching Data........");
      final response = await http.get(url);
      var extractedLyricsData =
          json.decode(response.body)['message']['body']['lyrics'];

      // final List<SongTrackModel> loadedTracks = []; //empty temporary list

      if (extractedLyricsData.isEmpty) {
        return emptyLyrics = true;
      } else {
        emptyLyrics = false;
        notifyListeners();
        return extractedLyricsData;
      }
      // print("Extracted Lyrics Data");

    } catch (error) {
      // print("Lyrics fetching Error");
      return emptyLyrics = true;
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
      // print(extractedData);

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
      // print("Chart fetching Error");
      _songscard = [];
    }
    notifyListeners();
  }
}

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  startMonitoring() async {
    await initConenctivity();
    _connectivity.onConnectivityChanged.listen(
      (event) async {
        if (event == ConnectivityResult.none) {
          _isOnline = false;
          notifyListeners();
        } else {
          await _updateConnectionStatus().then((bool isConnected) {
            _isOnline = isConnected;
            notifyListeners();
          });
        }
      },
    );
    print("Internet Status");
    print(_isOnline);
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected = true;

    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  Future<void> initConenctivity() async {
    try {
      var status = await _connectivity.checkConnectivity();
      if (status == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        _isOnline = true;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("PlatformException: ${e.toString()}");
    }
  }
}
