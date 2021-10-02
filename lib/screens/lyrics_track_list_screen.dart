import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:song_lyrics/models/song_track_model.dart';
import 'package:song_lyrics/provider/lyrics_provider.dart';
import 'package:song_lyrics/screens/song_details_screen.dart';

class LyricsTrackListScreen extends StatefulWidget {
  const LyricsTrackListScreen({Key? key}) : super(key: key);

  @override
  State<LyricsTrackListScreen> createState() => _LyricsTrackListScreenState();
}

class _LyricsTrackListScreenState extends State<LyricsTrackListScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _isEmpty = false;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<LyricsDataProvider>(context, listen: false)
          .fetchAndSetSongsChart()
          .then(
        (value) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final songList = Provider.of<LyricsDataProvider>(context).songscard;
    if (songList.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      setState(() {
        _isEmpty = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Trending")),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : _isEmpty
              ? const Center(child: Text("No data found"))
              : ListView.builder(
                  itemCount: songList.length,
                  itemBuilder: (ctx, i) => Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        // print("Card tapped");
                        Navigator.of(context).pushNamed(
                            SongDetailsScreen.routeName,
                            arguments: songList[i]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.library_music,
                            size: 25,
                          ),
                          const SizedBox(width: 19),
                          Container(
                            // color: Colors.amber,
                            alignment: Alignment.centerLeft,
                            width: 220,
                            height: 80,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    songList[i].trackname!,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    songList[i].albumName!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              width: double.infinity,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            // color: Colors.red,
                            width: 100,
                            height: 80,
                            child: Text(
                              songList[i].artist!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
