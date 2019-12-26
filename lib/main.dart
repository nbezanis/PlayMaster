import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:stereo/stereo.dart';
import 'package:audioplayers/audioplayers.dart';

import 'music_list_display.dart';
import 'sp_view_switcher.dart';

void main() => runApp(PlayMaster());

//main class for the entire app. any static variables here are
//intended to be used throughout the entire app.
class PlayMaster extends StatelessWidget {
  static AudioPlayer player = AudioPlayer();
  static List<MusicListDisplay> music = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Master',
      home: HomePage(),
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
  Color _songsColor = Colors.blue;
  Color _plColor = Colors.transparent;
  Color _selected = Colors.blue;
  Color _unselected = Colors.transparent;
  //used to set each music object's id
  int idTotal = 0;

  //returns a widget that allows user to switch between
  //the list of their songs and the list of their playlists
  Widget _getSPViewSwitcher() {
    return Container(
      color: Colors.black12,
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
                    style: TextStyle(fontSize: 20.0),
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
                  style: TextStyle(fontSize: 20.0),
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
              itemBuilder: (context, index) => ListTile(
                title: PlayMaster.music[index],
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'PLAYLISTS HERE',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MLDInfo(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Play Master'),
            actions: <Widget>[
              //this icon button is used to add playlists
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
                              .add(MusicListDisplay(path, name, idTotal));
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
              _getSPViewSwitcher(),
              _displayContent(displaySongs)
            ],
          )),
    );
  }
}

//isolates a song's name given the path to the mp3 file
String getSongName(String path) {
  String name;
  name = path.substring(path.lastIndexOf('/') + 1, path.indexOf('.mp3'));
  return name;
}

//uses flutter file picker to allow the user to import audio files from elsewhere
//on their device
Future<Map<String, String>> pickFiles() async {
  Map<String, String> filePaths;
  filePaths = await FilePicker.getMultiFilePath(type: FileType.AUDIO);
  return filePaths;
}
