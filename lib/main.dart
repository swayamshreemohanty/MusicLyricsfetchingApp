import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:song_lyrics/provider/lyrics_provider.dart';
import 'package:song_lyrics/screens/lyrics_track_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:song_lyrics/screens/song_details_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => LyricsDataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          brightness: Brightness.light,
        ),
        home: const LyricsTrackListScreen(),
        routes: {
          SongDetailsScreen.routeName: (ctx) => SongDetailsScreen(),
        },
      ),
    );
  }
}
