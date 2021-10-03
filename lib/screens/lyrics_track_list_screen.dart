import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:song_lyrics/provider/lyrics_provider.dart';
import 'package:song_lyrics/widgets/drawer.dart';

import 'package:song_lyrics/widgets/song_card_widget.dart';

class LyricsTrackListScreen extends StatefulWidget {
  const LyricsTrackListScreen({Key? key}) : super(key: key);
  static const routeName = '/trackList';

  @override
  State<LyricsTrackListScreen> createState() => _LyricsTrackListScreenState();
}

class _LyricsTrackListScreenState extends State<LyricsTrackListScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _isEmpty = false;

  @override
  void didChangeDependencies() async {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
      ),
      drawer: MainDrawer(),
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
                  itemBuilder: (ctx, i) {
                    return SongTrackCard(
                      trackId: songList[i].trackId,
                      name: songList[i].name,
                      artist: songList[i].artist,
                      albumName: songList[i].albumName,
                      trackname: songList[i].trackname,
                      explicit: songList[i].explicit,
                      rating: songList[i].rating,
                    );
                  },
                ),
    );
  }
}
