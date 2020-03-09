import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:collection';

import 'main.dart';
import 'music_list_display.dart';
import 'app_utils.dart';
import 'music_utils.dart';

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
  //shows a dialog asking for the name of the playlist
  //passes back the name the user inputted
  Future<String> createNameDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Playlist Name'),
            content: TextField(
              controller: controller,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop(controller.text.toString());
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var selectInfo = Provider.of<SelectInfo>(context);
//    if (selectInfo.selectedMusic.isEmpty) {
//      selectInfo.selecting = true;
//    }
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
                //shows dialog asking for name when pressed
                createNameDialog(context).then((name) {
                  //sends back the playlist that was created
                  HashSet<Song> songs = selectInfo.finishSongSelect();
                  int plIdTotal;
                  //get id for playlist
                  PlayMaster.getIntFromPrefs('plIdTotal').then((val) {
                    plIdTotal = val ?? 0;
                    Navigator.of(context)
                        .pop(Playlist.name(songs.toList(), name, plIdTotal));
                    //increase id total
                    plIdTotal++;
                  }).then((val) {
                    //save id total in prefs
                    PlayMaster.putIntInPrefs('plIdTotal', plIdTotal);
                  });
                });
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
