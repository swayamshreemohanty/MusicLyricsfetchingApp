import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:song_lyrics/provider/central_provider.dart';
import 'package:song_lyrics/screens/bookmaked_song_list.dart';
import 'package:song_lyrics/screens/track_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:song_lyrics/screens/no_internet_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LyricsDataProvider()),
        ChangeNotifierProvider(
          create: (ctx) => ConnectivityProvider(),
          child: const LyricsTrackListScreen(),
        )
      ],
      child: Consumer<ConnectivityProvider>(builder: (context, model, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.amber,
            brightness: Brightness.light,
          ),
          home: model.isOnline
              ? const LyricsTrackListScreen()
              : NoInternetScreen(),
          routes: {
            LyricsTrackListScreen.routeName: (ctx) =>
                const LyricsTrackListScreen(),
            SongDetailsScreen.routeName: (ctx) => SongDetailsScreen(),
            BookmarkedSongsList.routeName: (ctx) => BookmarkedSongsList(),
          },
        );
      }),
    );
  }
}
