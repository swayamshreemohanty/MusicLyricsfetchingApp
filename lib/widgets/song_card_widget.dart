import 'package:flutter/material.dart';
import 'package:song_lyrics/screens/song_details_screen.dart';

class SongTrackCard extends StatelessWidget {
  final int trackId;
  final String? name;
  final String? artist;
  final String? albumName;
  final String? trackname;
  final String? explicit;
  final String? rating;
  SongTrackCard({
    required this.trackId,
    required this.name,
    required this.artist,
    required this.albumName,
    required this.trackname,
    required this.explicit,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // print("Card tapped");
          Navigator.of(context)
              .pushNamed(SongDetailsScreen.routeName, arguments: trackId);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.library_music,
              size: 25,
              color: Colors.red,
            ),
            const SizedBox(width: 19),
            Container(
              // color: Colors.amber,
              alignment: Alignment.centerLeft,
              width: 220,
              height: 80,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trackname!,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      albumName!,
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
                artist!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
