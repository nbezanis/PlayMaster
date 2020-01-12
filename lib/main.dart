import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'music_list_display.dart';
import 'main_music_display.dart';
import 'music_utils.dart';

void main() => runApp(PlayMaster());

enum Repeat { off, all, one }

//main class for the entire app. any static variables here are
//intended to be used throughout the entire app.
class PlayMaster extends StatelessWidget {
  static AudioPlayer player = AudioPlayer();

  //these are temporary until I implement shared preferences
  static int sliderValue = 0;
  static int songDuration = 0;

  static SplayTreeSet<Song> music = SplayTreeSet<Song>(Song.compare);
  static Color accentColor = Colors.blue;
  static Color accentColorGradient = Color.fromRGBO(119, 192, 229, 1);
  static Color fadedGrey = Color.fromRGBO(232, 232, 232, 1);
  static Color musicbg = Color.fromRGBO(33, 150, 255, 0.1);

  static void putIntInPrefs(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
    prefs.clear();
  }

  static Future<int> getIntFromPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Master',
      home: ChangeNotifierProvider(
        create: (context) => MusicInfo(),
        child: HomePage(),
      ),
    );
  }
}

//this class is used along with provider to store info about which song is
//playing
class MusicInfo extends ChangeNotifier {
  Playlist _pl = Playlist.init();
  Song _song = Song.init();
  bool _playing = false;
  bool _stopped = false;
  bool _shuffle = false;
  Repeat _repeat = Repeat.off;

  Song get song => _song;
  Playlist get pl => _pl;
  bool get playing => _playing;
  bool get stopped => _stopped;
  bool get shuffle => _shuffle;
  Repeat get repeat => _repeat;

  set playing(bool playing) => _playing = playing;
  set pl(Playlist pl) => _pl = pl;
  set repeat(Repeat repeat) => _repeat = repeat;
  set shuffle(bool shuff) {
    _shuffle = shuff;
    notifyListeners();
  }

  set song(Song song) {
    _pl.index = song.index;
    _song = song;
    _playing = true;
    if (song.id != -1) {
      play();
    }
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  //plays the audio of this widget
  void play() async {
    await PlayMaster.player.play(song.path, isLocal: true);
  }

  //pauses the audio of this widget
  void pause() async {
    await PlayMaster.player.pause();
  }

  //stop the music and set name, path, and id back to their
  //default values. setting info.song to Song.init() also
  // removes this widget from the stack since the homepage
  // gets rebuilt
  void stop() {
    PlayMaster.player.stop();
    _playing = false;
    _song = Song.init();
    _pl = Playlist.init();
    PlayMaster.sliderValue = 0;
    PlayMaster.songDuration = 0;
    notifyListeners();
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
              itemBuilder: (context, index) => MusicListDisplay(
                PlayMaster.music.elementAt(index),
              ),
            ),
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
                  //use shared preferences fro idTotal so that we're not giving
                  //repeat IDs
                  PlayMaster.getIntFromPrefs('idTotal').then((val) {
                    idTotal = val ?? 0;
                    setState(() {
                      map.forEach((name, path) {
                        PlayMaster.music
                            .add(Song(path, idTotal, PlayMaster.music.length));
                        //add 1 to idTotal so that every song gets its own id
                        idTotal++;
                      });

                      PlayMaster.putIntInPrefs('idTotal', idTotal);
                      print(idTotal);
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
    var info = Provider.of<MusicInfo>(context);
    //use a stack so that we can display the main music display above
    //the main app display. The stack should only ever have at most 2 widgets
    //in it at any given time
    stack.clear();
    stack.add(_getBottomOfStack());
    List<Song> selectedSongs = displaySongs ? PlayMaster.music.toList() : [];
    if (info.song.id != -1) {
      if (!info.shuffle) {
        //if the playlist isn't in shuffle mode, set the plalylist equal
        //to the list of the selected songs in order
        Playlist inOrderPl = Playlist.index(selectedSongs, info.song.index);
        inOrderPl.resetIndexes(info.song.id);
        info.pl = inOrderPl;
      } else if (info.pl.songs[0].id == -1) {
        //if the playlist is in shuffle mode and the user does not currently
        //have a plalylist running (info.pl.songs[0].id == -1), create a playlist
        //and shuffle it before setting info.pl equal to it
        Playlist shuffledPl = Playlist.id(selectedSongs, info.song.id);
        shuffledPl.shuffle();
        info.pl = shuffledPl;
      }
      //add main music display widget to stack if a song is playing
      stack.add(MainMusicDisplay());
    }
    return Material(
      child: Stack(
        children: stack,
      ),
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
