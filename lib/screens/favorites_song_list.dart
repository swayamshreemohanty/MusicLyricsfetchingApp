import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_lyrics/provider/lyrics_provider.dart';
import 'package:song_lyrics/screens/no_internet_screen.dart';
import 'package:song_lyrics/widgets/song_card_widget.dart';

class FavoriteSongsList extends StatefulWidget {
  static const routeName = '/favorite_list';

  @override
  State<FavoriteSongsList> createState() => _FavoriteSongsListState();
}

class _FavoriteSongsListState extends State<FavoriteSongsList> {
  var _isEmpty = false;

  @override
  void didChangeDependencies() async {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesongList =
        Provider.of<LyricsDataProvider>(context).favoritesongscard;
    if (favoritesongList.isEmpty) {
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
        title: const Text("Favorites"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
      ),
      body: Consumer<ConnectivityProvider>(
        builder: (ctx, model, _) {
          if (model.isOnline) {
            return _isEmpty
                ? const Center(child: Text("No favorite song found"))
                : ListView.builder(
                    itemCount: favoritesongList.length,
                    itemBuilder: (ctx, i) {
                      return SongTrackCard(
                        trackId: favoritesongList[i].trackId,
                        name: favoritesongList[i].name,
                        artist: favoritesongList[i].artist,
                        albumName: favoritesongList[i].albumName,
                        trackname: favoritesongList[i].trackname,
                        explicit: favoritesongList[i].explicit,
                        rating: favoritesongList[i].rating,
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
