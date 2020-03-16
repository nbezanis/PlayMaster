import 'package:flutter/material.dart';

import 'music_utils.dart';
import 'main.dart';
import 'music_list_display.dart';

class MainPlayListDisplay extends StatefulWidget {
  final Playlist pl;

  MainPlayListDisplay(this.pl);

  @override
  _MainPlayListDisplayState createState() => _MainPlayListDisplayState();
}

class _MainPlayListDisplayState extends State<MainPlayListDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlayMaster.accentColor,
        title: Text(widget.pl.name),
      ),
      body: ListView.builder(
        itemCount: widget.pl.length,
        itemBuilder: (context, index) =>
            MusicListDisplay(widget.pl.songs[index]),
      ),
    );
  }
}
