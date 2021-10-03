import 'package:flutter/material.dart';
import 'package:song_lyrics/screens/favorites_song_list.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Card(
                child: ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(FavoriteSongsList.routeName);
              },
            )),
          )
        ],
      ),
    );
  }
}
