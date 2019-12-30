import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:stereo/stereo.dart';
import 'package:audioplayers/audioplayers.dart';

import 'music_list_display.dart';
import 'main_music_display.dart';
import 'music_utils.dart';

void main() => runApp(PlayMaster());

//main class for the entire app. any static variables here are
//intended to be used throughout the entire app.
class PlayMaster extends StatelessWidget {
  static AudioPlayer player = AudioPlayer();
  static List<Song> music = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Master',
      home: ChangeNotifierProvider(
        create: (context) => MLDInfo(),
        child: HomePage(),
      ),
    );
  }
}

//homepage that houses the lists of the user's
//songs and playlists
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  //tells us which list to display
  bool displaySongs = true;
  Color _songsColor = Colors.white;
  Color _plColor = Colors.transparent;
  Color _selected = Colors.white;
  Color _unselected = Colors.transparent;
  //used to set each music object's id
  int idTotal = 0;
  List<Widget> stack = [];

  //returns a widget that allows user to switch between
  //the list of their songs and the list of their playlists
  Widget _getSPViewSwitcher() {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Container(
            child: Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: _songsColor, width: 3.0),
                  ),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    'Songs',
                    style: TextStyle(fontSize: 22.0, color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      displaySongs = true;
                      _songsColor = _selected;
                      _plColor = _unselected;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: _plColor, width: 3.0))),
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  'Play Lists',
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    displaySongs = false;
                    _plColor = _selected;
                    _songsColor = _unselected;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //returns list of songs if displaySongs is true and
  //list of playlists if it's false
  Widget _displayContent(bool displaySongs) {
    return displaySongs
        ? Expanded(
            child: ListView.builder(
                itemCount: PlayMaster.music.length,
                itemBuilder: (context, index) =>
                    MusicListDisplay(PlayMaster.music[index])),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'PLAYLISTS HERE',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }

  //returns the main page which should always be the bototm of the stack widget
  Widget _getBottomOfStack() {
    return Scaffold(
      appBar: AppBar(
        title: _getSPViewSwitcher(),
        actions: <Widget>[
          //this icon button is used to add songs and playlists
          //using flutter file picker
          IconButton(
              icon: Icon(Icons.add),
              iconSize: 40.0,
              onPressed: () {
                //pick files from phone and add them to list of music
                pickFiles().then((map) {
                  setState(() {
                    map.forEach((name, path) {
                      PlayMaster.music
                          .add(Song(path, idTotal, PlayMaster.music.length));
                      //add 1 to idTotal so that every song gets its own id
                      idTotal++;
                    });
                  });
                });
              }),
        ],
      ),
      body: Column(
        children: <Widget>[
          //list of songs or playlists
          _displayContent(displaySongs),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<MLDInfo>(context);
    //use a stack so that we can display the main music display above
    //the main app display. The stack should only ever have at most 2 widgets
    //in it at any given time
    stack.clear();
    stack.add(_getBottomOfStack());
    if (info.song.id != -1) {
      stack.add(MainMusicDisplay(Playlist(PlayMaster.music), info.song.index));
    }
    return Stack(
      children: stack,
    );
  }
}

//uses flutter file picker to allow the user to import audio files from elsewhere
//on their device
Future<Map<String, String>> pickFiles() async {
  Map<String, String> filePaths;
  filePaths = await FilePicker.getMultiFilePath(type: FileType.AUDIO);
  return filePaths;
}
