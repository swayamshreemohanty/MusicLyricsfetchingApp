import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_lyrics/models/song_track_model.dart';
import 'package:song_lyrics/provider/lyrics_provider.dart';

class SongDetailsScreen extends StatefulWidget {
  static const routeName = '/songDetails';

  @override
  _SongDetailsScreenState createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends State<SongDetailsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _lyrics;

  @override
  void didChangeDependencies() async {
    final trackId =
        ModalRoute.of(context)!.settings.arguments as SongTrackModel;
    SongTrackModel songData = trackId;

    print("songData");

    print(songData.albumName);

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<LyricsDataProvider>(context, listen: false)
          .fetchAndSetSongsLyrics(songData.trackId)
          .then((value) {
        // print("Rx Lyrics");
        // print(value);
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
      appBar: AppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Text("${_lyrics['lyrics_body']}"),
                  Divider(),
                  Text("${_lyrics['lyrics_copyright']}"),
                ]),
              ),
            ),
    );
  }
}
