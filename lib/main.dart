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
import 'app_utils.dart';
import 'theme_changer.dart';
import 'playlist_creator.dart';

void main() => runApp(PlayMaster());

enum Repeat { off, all, one }
enum Select { all, none, choose }

//main class for the entire app. any static variables here are
//intended to be used throughout the entire app.
class PlayMaster extends StatelessWidget {
  static AudioPlayer player = AudioPlayer();

  static int sliderValue = 0;
  static int songDuration = 0;

  static SplayTreeSet<Song> music = SplayTreeSet<Song>(Song.compare);
  static SplayTreeSet<Playlist> playlists = SplayTreeSet<Playlist>();
  static Color accentColor;
  static Color accentColorGradient;
  static Color musicbg;
  static Color fadedGrey = Color.fromRGBO(232, 232, 232, 1);

  static final HashMap<String, Color> colorMap = HashMap<String, Color>();

  static String songStr = '';

  static void putIntInPrefs(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int> getIntFromPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static void putStrInPrefs(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getStrFromPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  //DEBUG ONLY
  static void clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static void getSupportingColors() {
    accentColorGradient = _getGradientColor(accentColor);
    musicbg = Color.fromRGBO(
        accentColor.red, accentColor.green, accentColor.blue, 0.1);
  }

  static Color _getGradientColor(Color color) {
    HSVColor hsv = HSVColor.fromColor(color);
    double hue = (hsv.hue - 0.06 < 0 ? 0 : hsv.hue - 0.06);
    double sat = (hsv.saturation - 0.38 < 0 ? 0 : hsv.saturation - 0.38);
    double val = (hsv.value - 0.02 < 0 ? 0 : hsv.value - 0.02);
    HSVColor newColor = HSVColor.fromAHSV(1, hue, sat, val);
    return newColor.toColor();
  }

  void _initiateColorMap() {
    //most of these colors are temp
    colorMap['blue'] = Colors.blue;
    colorMap['red'] = Colors.red;
    colorMap['green'] = Colors.green;
    colorMap['orange'] = Colors.orange;
    colorMap['purple'] = Colors.purple;
    colorMap['pink'] = Colors.pink;
    colorMap['yellow'] = Colors.yellow;
    colorMap['teal'] = Colors.teal;
  }

  @override
  Widget build(BuildContext context) {
//    PlayMaster.clearPrefs(); DEBUG
    _initiateColorMap();
    PlayMaster.getStrFromPrefs('color').then((color) {
      accentColor = colorMap[color ?? 'blue'];
      getSupportingColors();
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Master',
      home: ChangeNotifierProvider(
        create: (context) => MusicInfo(),
        child: ChangeNotifierProvider(
          create: (BuildContext context) => SelectInfo(),
          child: HomePage(),
        ),
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
              flex: 4,
              child: Container(
                margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
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
            flex: 6,
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

  //adds all songs in music splaytree to sharedprefs string
  void _updateSongsInPrefs() {
    String strForPrefs = '';
    for (int i = 0; i < PlayMaster.music.length; i++) {
      strForPrefs += PlayMaster.music.elementAt(i).toString();
    }
    PlayMaster.putStrInPrefs('songs', strForPrefs);
  }

  //returns list of songs if displaySongs is true and
  //list of playlists if it's false
  Widget _displayContent(bool displaySongs) {
    return displaySongs
        ? Expanded(
            child: ListView.builder(
              itemCount: PlayMaster.music.length,
              itemBuilder: (context, index) => Dismissible(
                key: Key(PlayMaster.music.elementAt(index).path),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (direction) {
                  setState(() {
                    //remove swiped song from music splaytree and update the
                    //string containing all the songs in sharedprefs
                    PlayMaster.music.remove(PlayMaster.music.elementAt(index));
                    _updateSongsInPrefs();
                  });
                },
                child: MusicListDisplay(
                  PlayMaster.music.elementAt(index),
                ),
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

  Widget _getSelectingTools(SelectInfo selectInfo) {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Icon(Icons.delete),
          onTap: () {
            HashSet<Song> selectedMusic = selectInfo.finishSongSelect();
            for (int i = 0; i < selectedMusic.length; i++) {
              PlayMaster.music.remove(selectedMusic.elementAt(i));
            }
            _updateSongsInPrefs();
          },
        ),
      ],
    );
  }

  void _addPlaylists(MusicInfo musicInfo, SelectInfo selectInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistCreator(musicInfo, selectInfo),
      ),
    );
  }

  void _addSongs() {
    //pick files from phone and add them to list of music
    pickFiles().then((map) {
      //use shared preferences fro idTotal so that we're not giving
      //repeat IDs
      PlayMaster.getIntFromPrefs('idTotal').then((val) {
        idTotal = val ?? 0;
        setState(() {
          String songs = '';
          map.forEach((name, path) {
            Song s = Song(path, idTotal, PlayMaster.music.length);
            PlayMaster.music.add(s);
            //add this song a string containing all the songs that
            //were just added
            songs += s.toString();
            //add 1 to idTotal so that every song gets its own id
            idTotal++;
          });
          //store the songs and idTotal in prefs
          PlayMaster.putStrInPrefs('songs', PlayMaster.songStr + songs);
          PlayMaster.songStr += songs;
          PlayMaster.putIntInPrefs('idTotal', idTotal);
        });
      });
    });
  }

  List<Widget> _getActions(SelectInfo selectInfo, MusicInfo musicInfo) {
    if (selectInfo.selecting) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
          child:
//              GestureDetector(
//              onTap: () => selectInfo.type == Select.all
//                  ? selectInfo.deselectAll()
//                  : selectInfo.selectAll(),
//              child: selectInfo.type == Select.all
//                  ? Icon(Icons.tab_unselected)
//                  : Icon(Icons.select_all),
//            )

              RaisedButton(
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
              selectInfo.selecting = false;
              selectInfo.deselectAll();
            },
            child: Text(
              'Done',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ];
    } else {
      return <Widget>[
        //this icon button is used to add songs and playlists
        //using flutter file picker
        IconButton(
            icon: Icon(Icons.add),
            iconSize: 40.0,
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              displaySongs ? _addSongs() : _addPlaylists(musicInfo, selectInfo);
            }),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: 35.0,
          ),
          itemBuilder: (context) {
            return ['Change Theme', 'Select'].map((choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          onSelected: (choice) {
            if (choice == 'Change Theme') {
              _launchThemeChanger();
            } else if (choice == 'Select') {
              _launchSelector(selectInfo);
            }
          },
        ),
      ];
    }
  }

  //returns the main page which should always be the bototm of the stack widget
  Widget _getBottomOfStack(SelectInfo selectInfo, MusicInfo musicInfo) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlayMaster.accentColor,
        title: selectInfo.selecting
            ? _getSelectingTools(selectInfo)
            : _getSPViewSwitcher(),
        actions: _getActions(selectInfo, musicInfo),
      ),
      body: Column(
        children: <Widget>[
          //list of songs or playlists
          _displayContent(displaySongs),
        ],
      ),
    );
  }

  void _launchThemeChanger() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThemeChanger(),
      ),
    );
  }

  void _launchSelector(SelectInfo selectInfo) {
    selectInfo.selecting = true;
  }

  //loads the user's songs from prefs and puts them in the music splaytree
  void _loadMusicFromPrefs(MusicInfo info) {
    PlayMaster.getStrFromPrefs('songs').then((str) {
      if (str == null) {
        return;
      }
      PlayMaster.songStr = str;
      for (int i = 0; i < str.length;) {
        String path;
        int id;
        int index;
        //path
        int separation = str.indexOf('§', i);
        path = str.substring(i, separation);
        i = separation + 1;
        //id
        separation = str.indexOf('§', i);
        id = int.tryParse(str.substring(i, separation)) ?? 0;
        i = separation + 1;
        //index
        separation = str.indexOf('§', i);
        index = int.tryParse(str.substring(i, separation)) ?? 0;
        i = separation + 1;
        PlayMaster.music.add(Song(path, id, index));
      }
      info.update();
    });
  }

  @override
  void initState() {
    super.initState();
    var info = Provider.of<MusicInfo>(context, listen: false);
    _loadMusicFromPrefs(info);
  }

  @override
  Widget build(BuildContext context) {
    var musicInfo = Provider.of<MusicInfo>(context);
    var selectInfo = Provider.of<SelectInfo>(context);
    //use a stack so that we can display the main music display above
    //the main app display. The stack should only ever have at most 2 widgets
    //in it at any given time
    stack.clear();
    stack.add(_getBottomOfStack(selectInfo, musicInfo));
    List<Song> selectedSongs = displaySongs ? PlayMaster.music.toList() : [];
    if (musicInfo.song.id != -1) {
      if (!musicInfo.shuffle) {
        //if the playlist isn't in shuffle mode, set the plalylist equal
        //to the list of the selected songs in order
        Playlist inOrderPl = Playlist.inOrder(
            selectedSongs, musicInfo.song.index, musicInfo.pl.excludedIds);
        inOrderPl.resetIndexes(musicInfo.song.id);
        musicInfo.pl = inOrderPl;
      } else if (musicInfo.pl.songs[0].id == -1) {
        //if the playlist is in shuffle mode and the user does not currently
        //have a plalylist running (info.pl.songs[0].id == -1), create a playlist
        //and shuffle it before setting info.pl equal to it
        Playlist shuffledPl = Playlist.id(selectedSongs, musicInfo.song.id);
        shuffledPl.shuffle();
        musicInfo.pl = shuffledPl;
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
