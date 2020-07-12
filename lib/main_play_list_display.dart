import 'package:flutter/material.dart';
import 'package:play_master/main_music_display.dart';
import 'package:provider/provider.dart';

import 'app_utils.dart';
import 'music_utils.dart';
import 'main.dart';
import 'music_list_display.dart';

//splitting this into 2 different classes because we need to use the providers in the build method
class MainPlayListDisplay extends StatelessWidget {
  final Playlist pl;
  final MusicInfo musicInfo;
  final SelectInfo selectInfo;

  MainPlayListDisplay(this.pl, this.musicInfo, this.selectInfo);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: musicInfo,
      child: ChangeNotifierProvider.value(
          value: selectInfo, child: MainPlaylistDisplayContainer(pl)),
    );
  }
}

class MainPlaylistDisplayContainer extends StatefulWidget {
  final Playlist pl;

  MainPlaylistDisplayContainer(this.pl);

  @override
  State<StatefulWidget> createState() => _MainPlaylistDisplayContainerState();
}

class _MainPlaylistDisplayContainerState
    extends State<MainPlaylistDisplayContainer> {
  Widget _getMainMusicDisplay(MusicInfo musicInfo) =>
      musicInfo.song.id != -1 ? MainMusicDisplay() : Container();

  @override
  Widget build(BuildContext context) {
    MusicInfo musicInfo = Provider.of<MusicInfo>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlayMaster.accentColor,
        title: Text(
          widget.pl.name,
          style: TextStyle(fontSize: 30.0),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.pl.length,
        itemBuilder: (context, index) =>
            MusicListDisplay(widget.pl.songs[index]),
      ),
    );
  }
}
