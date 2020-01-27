import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'music_list_display.dart';
import 'app_utils.dart';

class PlaylistCreator extends StatelessWidget {
  MusicInfo musicInfo;
  SelectInfo selectInfo;

  PlaylistCreator(this.musicInfo, this.selectInfo);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: musicInfo,
      child: ChangeNotifierProvider.value(
        value: selectInfo,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: PlayMaster.accentColor,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    //TODO launch name dialog
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: PlayMaster.music.length,
            itemBuilder: (BuildContext context, int index) =>
                MusicListDisplay(PlayMaster.music.elementAt(index)),
          ),
        ),
      ),
    );
  }
}
