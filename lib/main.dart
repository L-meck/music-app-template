import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'image_art.dart';
import 'logic.dart';

typedef OnError = void Function(Exception exception);

const songurl =
    'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3';

void main() {
  runApp(const MaterialApp(home: MyMusicPlayer()));
}

class MyMusicPlayer extends StatefulWidget {
  const MyMusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MyMusicPlayer> {
  AudioPlayer advancedPlayer = AudioPlayer();

  Widget remoteUrl() {
    return Column(
      //   mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        // ImageSong("assets/images/thumbnail.png"),

        const Text(
          ' 🌳🐰🌳 ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const Text(
          'lets work together',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        PlayerWidget(url: songurl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: const Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          body: Center(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.black54, Colors.purple],
                ),
              ),
              // child: remoteUrl(),
              child: Container(
                child: Column(
                  //   mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    // ImageSong("assets/images/thumbnail.png"),
                    Container(
                      constraints: const BoxConstraints.expand(height: 400.0),
                      // decoration: BoxDecoration(),
                      child: const Center(child: Text('Song 1')),
                    ),
                    const Text(
                      'Rihanna',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Give me my money ',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    PlayerWidget(
                        url:
                            'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
