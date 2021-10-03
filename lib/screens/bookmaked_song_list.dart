import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_lyrics/provider/central_provider.dart';
import 'package:song_lyrics/screens/no_internet_screen.dart';
import 'package:song_lyrics/widgets/song_card_widget.dart';

// ignore: use_key_in_widget_constructors
class BookmarkedSongsList extends StatefulWidget {
  static const routeName = '/favorite_list';

  @override
  State<BookmarkedSongsList> createState() => _BookmarkedSongsListState();
}

class _BookmarkedSongsListState extends State<BookmarkedSongsList> {
  var _isEmpty = false;

  @override
  void didChangeDependencies() async {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedsongList =
        Provider.of<LyricsDataProvider>(context).bookmarkedsongscard;
    if (bookmarkedsongList.isEmpty) {
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
        title: const Text("Bookmarks"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
      ),
      body: Consumer<ConnectivityProvider>(
        builder: (ctx, model, _) {
          if (model.isOnline) {
            return _isEmpty
                ? const Center(child: Text("No book marked song found"))
                : ListView.builder(
                    itemCount: bookmarkedsongList.length,
                    itemBuilder: (ctx, i) {
                      return SongTrackCard(
                        trackId: bookmarkedsongList[i].trackId,
                        name: bookmarkedsongList[i].name,
                        artist: bookmarkedsongList[i].artist,
                        albumName: bookmarkedsongList[i].albumName,
                        trackname: bookmarkedsongList[i].trackname,
                        explicit: bookmarkedsongList[i].explicit,
                        rating: bookmarkedsongList[i].rating,
                      );
                    },
                  );
          } else {
            return NoInternetScreen();
          }
        },
      ),
    );
  }
}
