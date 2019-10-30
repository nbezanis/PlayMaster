import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:async';

void main() => runApp(PlayMaster());

class PlayMaster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Master',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String mp3URI = '';
  AudioPlayer player = AudioPlayer();
  bool paused = true;
  Icon buttonIcon = Icon(Icons.pause);

  void _loadSound() async {
    final ByteData data = await rootBundle.load('assets/Clock.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/Clock.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3URI = tempFile.uri.toString();
  }

  @override
  void initState() {
    super.initState();
    _loadSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Master'),
      ),
      body: Center(
        child: IconButton(
          onPressed: () {
            if (paused) {
              player.play(mp3URI);
              setState(() {
                buttonIcon = Icon(Icons.pause);
              });
            } else {
              player.pause();
              setState(() {
                buttonIcon = Icon(Icons.play_arrow);
              });
            }
            paused = !paused;
          },
          icon: buttonIcon,
        ),
      ),
    );
  }
}
