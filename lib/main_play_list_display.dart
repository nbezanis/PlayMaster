import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_utils.dart';
import 'music_utils.dart';
import 'main.dart';
import 'music_list_display.dart';

class MainPlaylistDisplay extends StatefulWidget {
  final Playlist pl;

  MainPlaylistDisplay(this.pl);

  @override
  State<StatefulWidget> createState() => _MainPlaylistDisplayState();
}

class _MainPlaylistDisplayState extends State<MainPlaylistDisplay> {
  Widget _getAppBarTitle(SelectInfo selectInfo, MusicInfo musicInfo) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              musicInfo.mpdActive = false;
            },
            child: Icon(
              Icons.arrow_back,
              size: 30.0,
            ),
          ),
        ),
        Text(
          widget.pl.name,
          style: TextStyle(fontSize: 30.0),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MusicInfo musicInfo = Provider.of<MusicInfo>(context);
    SelectInfo selectInfo = Provider.of<SelectInfo>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlayMaster.accentColor,
        title: _getAppBarTitle(selectInfo, musicInfo),
      ),
      body: ListView.builder(
        itemCount: widget.pl.length,
        itemBuilder: (context, index) =>
            MusicListDisplay(widget.pl.songs[index]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
