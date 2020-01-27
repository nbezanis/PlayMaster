import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'music_list_display.dart';
import 'app_utils.dart';

//class to hold the providers required for music list display to work
class PlaylistCreator extends StatelessWidget {
  final MusicInfo musicInfo;
  final SelectInfo selectInfo;

  PlaylistCreator(this.musicInfo, this.selectInfo);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: musicInfo,
      child: ChangeNotifierProvider.value(
          value: selectInfo, child: PlaylistContainer()),
    );
  }
}

//class that holds the display of the plalylist creator
class PlaylistContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var selectInfo = Provider.of<SelectInfo>(context);
    selectInfo.selecting = true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlayMaster.accentColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
            child: RaisedButton(
              color: Colors.white,
              onPressed: () => selectInfo.type == Select.all
                  ? selectInfo.deselectAll()
                  : selectInfo.selectAll(),
              child: Text(
                selectInfo.type == Select.all ? 'deselect all' : 'select all',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
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
    );
  }
}
