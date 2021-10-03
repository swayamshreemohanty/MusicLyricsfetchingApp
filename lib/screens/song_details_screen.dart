import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_lyrics/models/song_track_model.dart';
import 'package:song_lyrics/provider/lyrics_provider.dart';
import 'package:song_lyrics/screens/no_internet_screen.dart';

// ignore: use_key_in_widget_constructors
class SongDetailsScreen extends StatefulWidget {
  static const routeName = '/songDetails';

  @override
  _SongDetailsScreenState createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends State<SongDetailsScreen> {
  var _isInit = true;
  var _isLoading = false;
  dynamic _lyrics;
  dynamic trackId;
  var _emptyList = false;
  SongTrackModel? songDetails;

  @override
  void didChangeDependencies() async {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    trackId = ModalRoute.of(context)!.settings.arguments as SongTrackModel;
    songDetails = trackId;

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<LyricsDataProvider>(context, listen: false)
          .fetchAndSetSongsLyrics(songDetails!.trackId)
          .then((value) {
        if (value == true) {
          setState(() {
            _emptyList = true;
          });
        } else {
          setState(() {
            _emptyList = false;
          });
        }

        _lyrics = value;
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Details")),
      body: Consumer<ConnectivityProvider>(
        builder: (context, model, _) {
          if (model.isOnline) {
            return _emptyList
                ? const Center(
                    child: Text("No Data Found"),
                  )
                : _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Artist",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  songDetails!.artist!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 19),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Album Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  songDetails!.albumName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 19),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Explicit",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  songDetails!.explicit! == "1"
                                      ? "True"
                                      : "False",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Rating",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  songDetails!.rating!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Lyrics",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${_lyrics['lyrics_body']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const Divider(thickness: 2),
                                Text(
                                  "${_lyrics['lyrics_copyright']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ]),
                        ),
                      );
          } else {
            return NoInternetScreen();
          }
        },
      ),
    );
  }
}
