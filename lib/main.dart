// import 'dart:collection';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:file_picker/file_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:play_master/main_play_list_display.dart';
// import 'package:provider/provider.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:audio_service/audio_service.dart';
//
// import 'background_audio_manager.dart';
// import 'music_list_display.dart';
// import 'main_music_display.dart';
// import 'music_utils.dart';
// import 'app_utils.dart';
// import 'theme_changer.dart';
// import 'playlist_creator.dart';
// import 'playlist_list_display.dart';
//
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:play_master/Bloc/media/media_bloc.dart';
import 'package:provider/provider.dart';

import 'Bloc/screen/screen_bloc.dart';
import 'Pages/home_page.dart';

void main() => runApp(PlayMaster());
//
// enum Repeat { off, all, one }
// enum Select { all, none, choose }
// enum PLType { temp, name }
//
// //void backgroundTaskEntrypoint() async {
// //  AudioServiceBackground.run(
// //      () => BackgroundAudioManager(PlayMaster.music.elementAt(0)));
// //}
//
// //main class for the entire app. any static variables here are
// //intended to be used throughout the entire app.
// class PlayMaster extends StatefulWidget {
//   static AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
//
//   static MediaControl playControl = MediaControl(
//     androidIcon: 'drawable/ic_action_play_arrow',
//     label: 'Play',
//     action: MediaAction.play,
//   );
//   static MediaControl pauseControl = MediaControl(
//     androidIcon: 'drawable/ic_action_pause',
//     label: 'Pause',
//     action: MediaAction.pause,
//   );
//   static MediaControl stopControl = MediaControl(
//     androidIcon: 'drawable/ic_action_stop',
//     label: 'Stop',
//     action: MediaAction.stop,
//   );
//
//   static double sliderValue = 0.0;
//
//   //DEBUG
//   static int deletedItems = 0;
//
//   static SplayTreeSet<Song> music = SplayTreeSet<Song>(Song.compare);
//   static SplayTreeSet<Playlist> playlists =
//       SplayTreeSet<Playlist>(Playlist.compare);
//   static Color accentColor;
//   static Color accentColorGradient;
//   static Color musicbg;
//   static Color fadedGrey = Color.fromRGBO(232, 232, 232, 1);
//
//   static final HashMap<String, Color> colorMap = HashMap<String, Color>();
//
//   static String songStr = '';
//
//   static void putIntInPrefs(String key, int value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(key, value);
//   }
//
//   static Future<int> getIntFromPrefs(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(key);
//   }
//
//   static void putStrInPrefs(String key, String value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key, value);
//   }
//
//   static Future<String> getStrFromPrefs(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }
//
//   //DEBUG ONLY
//   static void clearPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//   }
//
//   static void getSupportingColors() {
//     accentColorGradient = _getGradientColor(accentColor);
//     musicbg = Color.fromRGBO(
//         accentColor.red, accentColor.green, accentColor.blue, 0.1);
//   }
//
//   static Color _getGradientColor(Color color) {
//     HSVColor hsv = HSVColor.fromColor(color);
//     double hue = (hsv.hue - 0.06 < 0 ? 0 : hsv.hue - 0.06);
//     double sat = (hsv.saturation - 0.38 < 0 ? 0 : hsv.saturation - 0.38);
//     double val = (hsv.value - 0.02 < 0 ? 0 : hsv.value - 0.02);
//     HSVColor newColor = HSVColor.fromAHSV(1, hue, sat, val);
//     return newColor.toColor();
//   }
//
//   void _initiateColorMap() {
//     //most of these colors are temp
//     colorMap['blue'] = Colors.blue;
//     colorMap['red'] = Colors.red;
//     colorMap['green'] = Colors.green;
//     colorMap['orange'] = Colors.orange;
//     colorMap['purple'] = Colors.purple;
//     colorMap['pink'] = Colors.pink;
//     colorMap['yellow'] = Colors.yellow;
//     colorMap['teal'] = Colors.teal;
//   }
//
//   //isolates a song's name given the path to the mp3 file
//   static String isolateSongName(String path) {
//     String name;
//     name = path.substring(path.lastIndexOf('/') + 1, path.indexOf('.mp3'));
//     return name;
//   }
//
//   @override
//   State<StatefulWidget> createState() {
//     return _PlayMasterState();
//   }
// }
//
// class _PlayMasterState extends State<PlayMaster> {
//   @override
//   void initState() {
//     super.initState();
//     //    PlayMaster.music.add(Song('/test error.mp3', 100, 100));
// //    PlayMaster.clearPrefs(); DEBUG
//     widget._initiateColorMap();
//     PlayMaster.getStrFromPrefs('color').then((color) {
//       PlayMaster.accentColor = PlayMaster.colorMap[color ?? 'blue'];
//       PlayMaster.getSupportingColors();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Play Master',
//       home: AudioServiceWidget(
//         child: ChangeNotifierProvider(
//           create: (context) => MusicInfo(),
//           child: ChangeNotifierProvider(
//             create: (BuildContext context) => SelectInfo(),
//             child: HomePage(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() async {
//     await PlayMaster.player.dispose();
//     super.dispose();
//   }
// }
//
// //homepage that houses the lists of the user's
// //songs and playlists
// class HomePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomePageState();
//   }
// }
//
// class _HomePageState extends State<HomePage> {
//   //tells us which list to display
//   bool displaySongs = true;
//   Color _songsColor = Colors.white;
//   Color _plColor = Colors.transparent;
//   Color _selected = Colors.white;
//   Color _unselected = Colors.transparent;
//   //used to set each music object's id
//   int musicIdTotal = 0;
//   int plIdTotal = 0;
//
//   //returns a widget that allows user to switch between
//   //the list of their songs and the list of their playlists
//   Widget _getSPViewSwitcher() {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           GestureDetector(
//             child: Container(
//               height: 56.0, //height of appbar
//               width: MediaQuery.of(context).size.width / 4.5,
//               margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: _songsColor, width: 3.0),
//                 ),
//               ),
//               child: FittedBox(
//                 child: Text(
//                   'Songs',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             onTap: () {
//               setState(() {
//                 displaySongs = true;
//                 _songsColor = _selected;
//                 _plColor = _unselected;
//               });
//             },
//           ),
//           GestureDetector(
//             child: Container(
//               height: 56.0, //height of appbar
//               width: MediaQuery.of(context).size.width / 3.5,
//               margin: EdgeInsets.fromLTRB(24.0, 0.0, 16.0, 0.0),
//               decoration: BoxDecoration(
//                   border:
//                       Border(bottom: BorderSide(color: _plColor, width: 3.0))),
//               child: FittedBox(
//                 child: Text(
//                   'Play Lists',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             onTap: () {
//               setState(() {
//                 displaySongs = false;
//                 _plColor = _selected;
//                 _songsColor = _unselected;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   //adds all songs in music splaytree to sharedprefs string
//   void _updateSongsInPrefs() {
//     String strForPrefs = '';
//     for (int i = 0; i < PlayMaster.music.length; i++) {
//       strForPrefs += PlayMaster.music.elementAt(i).toString();
//     }
//     PlayMaster.putStrInPrefs('songs', strForPrefs);
//   }
//
//   //remove song's file from app documents
//   Future<void> _deleteFromPath(String path) async {
//     File file = File(path);
//     await file.delete();
//     PlayMaster.deletedItems++;
//   }
//
//   //returns list of songs if displaySongs is true and
//   //list of playlists if it's false
//   Widget _displayContent(bool displaySongs) {
//     return displaySongs
//         ? Expanded(
//             child: ListView.builder(
//               itemCount: PlayMaster.music.length,
//               itemBuilder: (context, index) => Dismissible(
//                 key: Key(PlayMaster.music.elementAt(index).path),
//                 direction: DismissDirection.endToStart,
//                 background: Container(
//                   color: Colors.red,
//                 ),
//                 onDismissed: (direction) {
//                   setState(() {
//                     //remove the file from, remove swiped song from music splaytree
//                     // the app's documents, and update the string containing all
//                     // the songs in sharedprefs
//                     _deleteFromPath(PlayMaster.music.elementAt(index).path);
//                     PlayMaster.music.remove(PlayMaster.music.elementAt(index));
//                     _updateSongsInPrefs();
//                   });
//                 },
//                 child: MusicListDisplay(
//                   PlayMaster.music.elementAt(index),
//                 ),
//               ),
//             ),
//           )
//         : Expanded(
//             child: ListView.builder(
//               itemCount: PlayMaster.playlists.length,
//               itemBuilder: (context, index) =>
//                   PlaylistListDisplay(PlayMaster.playlists.elementAt(index)),
//             ),
//           );
//   }
//
//   Future<void> _deleteSongs(SplayTreeSet<Song> selectedMusic) async {
//     for (int i = 0; i < selectedMusic.length; i++) {
//       //remove file from device
//       await _deleteFromPath(selectedMusic.elementAt(i).path).then((_) {
//         //after that, remove it from the music splaytree
//         PlayMaster.music.remove(selectedMusic.elementAt(i));
//       });
//     }
//   }
//
//   Widget _getSelectingTools(SelectInfo selectInfo) {
//     return Row(
//       children: <Widget>[
//         GestureDetector(
//           child: Icon(Icons.delete),
//           onTap: () {
//             SplayTreeSet<Song> selectedMusic = selectInfo.finishSongSelect();
//             _deleteSongs(selectedMusic).then((_) {
//               setState(() {
//                 //for debug purposes
//                 Fluttertoast.showToast(
//                   msg: "deleted ${PlayMaster.deletedItems} items",
//                   toastLength: Toast.LENGTH_LONG,
//                   gravity: ToastGravity.BOTTOM,
//                   timeInSecForIos: 5,
//                   backgroundColor: PlayMaster.accentColor,
//                   textColor: Colors.white,
//                   fontSize: 16.0,
//                 );
//                 PlayMaster.deletedItems = 0;
//                 //update prefs to reflect the deleted songs
//                 _updateSongsInPrefs();
//               });
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   //opens playlist creator page
//   Future<Playlist> _createPlaylist(MusicInfo musicInfo, SelectInfo selectInfo) {
//     selectInfo.selecting = true;
//     return Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PlaylistCreator(musicInfo, selectInfo),
//       ),
//     );
//   }
//
//   //adds the created playlist to the splaytree
//   void _addPlaylist(Playlist p, SelectInfo selectInfo) {
//     PlayMaster.getIntFromPrefs('plIdTotal').then((val) {
//       if (p != null) {
//         PlayMaster.playlists.add(p);
//       }
//       selectInfo.selecting = false;
//     });
//     //add to shared preferences too
//   }
//
//   void _addSongs() {
//     //pick files from phone and add them to list of music
//     pickFiles().then((files) {
//       //if the user didn't pick any files, reutrn
//       if (files == null) {
//         return;
//       }
//       //use shared preferences fro idTotal so that we're not giving
//       //repeat IDs
//       PlayMaster.getIntFromPrefs('idTotal').then((val) {
//         musicIdTotal = val ?? 0;
//         String songs = '';
//         getApplicationDocumentsDirectory().then((dir) {
//           for (File file in files) {
//             //make copy the file to the app's permanent directory
//             file
//                 .copy(
//                     '${dir.path}/${PlayMaster.isolateSongName(file.path)}.mp3')
//                 .then((newFile) {
//               Song s = Song(
//                   newFile.absolute.path, musicIdTotal, PlayMaster.music.length);
//               PlayMaster.music.add(s);
//               //add this song a string containing all the songs that
//               //were just added
//               songs += s.toString();
//               //add 1 to idTotal so that every song gets its own id
//               musicIdTotal++;
//             }).then((value) {
//               //call set state to immediately update the display
//               setState(() {
//                 //store the songs and idTotal in prefs
//                 PlayMaster.putStrInPrefs('songs', PlayMaster.songStr + songs);
//                 PlayMaster.songStr += songs;
//                 PlayMaster.putIntInPrefs('idTotal', musicIdTotal);
//               });
//             });
//           }
//         });
//       });
//     });
//   }
//
//   List<Widget> _getActions(SelectInfo selectInfo, MusicInfo musicInfo) {
//     if (selectInfo.selecting) {
//       return <Widget>[
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
//           child:
// //              GestureDetector(
// //              onTap: () => selectInfo.type == Select.all
// //                  ? selectInfo.deselectAll()
// //                  : selectInfo.selectAll(),
// //              child: selectInfo.type == Select.all
// //                  ? Icon(Icons.tab_unselected)
// //                  : Icon(Icons.select_all),
// //            )
//
//               ButtonTheme(
//             padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
//             minWidth: 0,
//             height: 0,
//             child: RaisedButton(
//               color: Colors.white,
//               onPressed: () => selectInfo.type == Select.all
//                   ? selectInfo.deselectAll()
//                   : selectInfo.selectAll(PlayMaster.music),
//               child: Text(
//                 selectInfo.type == Select.all ? 'deselect all' : 'select all',
//                 style: TextStyle(fontSize: 18.0),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
//           child: ButtonTheme(
//             padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
//             minWidth: 0,
//             height: 0,
//             child: RaisedButton(
//               color: Colors.white,
//               onPressed: () {
//                 selectInfo.selecting = false;
//                 selectInfo.deselectAll();
//               },
//               child: Text(
//                 'Done',
//                 style: TextStyle(fontSize: 18.0),
//               ),
//             ),
//           ),
//         ),
//       ];
//     } else {
//       return <Widget>[
//         //this icon button is used to add songs and playlists
//         //using flutter file picker
//         IconButton(
//           icon: Icon(
//             Icons.add,
//             size: 40.0,
//           ),
//           onPressed: () {
//             displaySongs
//                 ? _addSongs()
//                 : _createPlaylist(musicInfo, selectInfo)
//                     .then((p) => _addPlaylist(p, selectInfo));
//           },
//         ),
//         PopupMenuButton<String>(
//           icon: Icon(
//             Icons.more_vert,
//             size: 35.0,
//           ),
//           itemBuilder: (context) {
//             return ['Change Theme', 'Select', 'test audio', 'stop']
//                 .map((choice) {
//               return PopupMenuItem<String>(
//                 value: choice,
//                 child: Text(choice),
//               );
//             }).toList();
//           },
//           onSelected: (choice) {
//             if (choice == 'Change Theme') {
//               _launchThemeChanger();
//             } else if (choice == 'Select') {
//               _launchSelector(selectInfo);
//             } else if (choice == 'test audio') {
// //              AudioService.start(
// //                      backgroundTaskEntrypoint: backgroundTaskEntrypoint)
// //                  .then((value) => print(value))
// //                  .catchError((e) => print(e.toString()));
//             } else if (choice == 'stop') {
//               AudioService.stop();
//             }
//           },
//         ),
//       ];
//     }
//   }
//
//   //returns the main page which should always be the bototm of the stack widget
//   Widget _getBottomOfStack(SelectInfo selectInfo, MusicInfo musicInfo) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: PlayMaster.accentColor,
//         title: selectInfo.selecting
//             ? _getSelectingTools(selectInfo)
//             : _getSPViewSwitcher(),
//         actions: _getActions(selectInfo, musicInfo),
//       ),
//       body: Column(
//         children: <Widget>[
//           //list of songs or playlists
//           _displayContent(displaySongs),
//         ],
//       ),
//     );
//   }
//
//   void _launchThemeChanger() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ThemeChanger(),
//       ),
//       //use .then so that we can update the state once the page returns to the homescreen
//     ).then((value) {
//       setState(() {});
//     });
//   }
//
//   void _launchSelector(SelectInfo selectInfo) {
//     selectInfo.selecting = true;
//   }
//
//   //loads the user's songs from prefs and puts them in the music splaytree
//   void _loadMusicFromPrefs(MusicInfo info) {
//     PlayMaster.getStrFromPrefs('songs').then((str) {
//       if (str == null) {
//         return;
//       }
//       PlayMaster.songStr = str;
//       for (int i = 0; i < str.length;) {
//         String path;
//         int id;
//         int index;
//         //path
//         int separation = str.indexOf('§', i);
//         path = str.substring(i, separation);
//         i = separation + 1;
//         //id
//         separation = str.indexOf('§', i);
//         id = int.tryParse(str.substring(i, separation)) ?? 0;
//         i = separation + 1;
//         //index
//         separation = str.indexOf('§', i);
//         index = int.tryParse(str.substring(i, separation)) ?? 0;
//         i = separation + 1;
//         PlayMaster.music.add(Song(path, id, index));
//       }
//       info.update();
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     var info = Provider.of<MusicInfo>(context, listen: false);
//     _loadMusicFromPrefs(info);
//   }
//
//   //show main music display if music is playing
//   Widget _getMainMusicDisplay(MusicInfo musicInfo) =>
//       musicInfo.song.id != -1 ? MainMusicDisplay() : Container();
//
//   Widget _getMainPlaylistDisplay(SelectInfo selectInfo, MusicInfo musicInfo) =>
//       musicInfo.mpdActive ? MainPlaylistDisplay(musicInfo.pl) : Container();
//
//   @override
//   Widget build(BuildContext context) {
//     var musicInfo = Provider.of<MusicInfo>(context);
//     var selectInfo = Provider.of<SelectInfo>(context);
//
//     List<Song> selectedSongs =
//         displaySongs ? PlayMaster.music.toList() : musicInfo.pl.displaySongs;
//     if (musicInfo.song.id != -1) {
//       if (!musicInfo.shuffle) {
//         //if the playlist isn't in shuffle mode, set the plalylist equal
//         //to the list of the selected songs in order
//         Playlist inOrderPl = Playlist.inOrder(
//             selectedSongs,
//             musicInfo.song.index,
//             musicInfo.pl.excludedIds,
//             PLType.temp,
//             musicInfo.pl.id,
//             musicInfo.pl.name);
//         inOrderPl.resetIndexes(musicInfo.song.id);
//         musicInfo.pl = inOrderPl;
// //        musicInfo.pl.reorder(musicInfo.song.id);
//       } else if (!musicInfo.plPlaying) {
//         //if the playlist is in shuffle mode and the user does not currently
//         //have a plalylist running (info.pl.songs[0].id == -1), create a playlist
//         //and shuffle it before setting info.pl equal to it
//         Playlist shuffledPl = Playlist.id(selectedSongs, musicInfo.song.id,
//             PLType.temp, musicInfo.pl.id, musicInfo.pl.name);
//         shuffledPl.shuffle();
//         musicInfo.pl = shuffledPl;
//       }
//     }
//     return Material(
//       child: Stack(
//         children: [
//           _getBottomOfStack(selectInfo, musicInfo),
//           _getMainPlaylistDisplay(selectInfo, musicInfo),
//           _getMainMusicDisplay(musicInfo),
//         ],
//       ),
//     );
//   }
// }
//
// //uses flutter file picker to allow the user to import audio files from elsewhere
// //on their device
// //Future<Map<String, String>> pickFiles() async {
// //  Map<String, String> filePaths;
// //  filePaths = await FilePicker.getMultiFilePath(fileExtension: 'mp3');
// //  return filePaths;
// //}
//
// Future<List<File>> pickFiles() async {
//   List<File> files;
//   files = await FilePicker.getMultiFile(fileExtension: 'mp3');
//   return files;
// }

class PlayMaster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayMasterState();
}

class _PlayMasterState extends State<PlayMaster> {
  BlocProvider _screenBlocProvider;

  BlocProvider _mediaBlocProvider;

  BlocListener _screenBlocListener;

  BlocListener _mediaBlocListener;

  Widget _currentPage;

  void _listenForScreenEvents(BuildContext context, ScreenState state) {
    if (state is HomeScreenState) {
      setState(() {
        _currentPage = HomePage();
      });
    }
  }

  void _listenForMediaEvents(BuildContext context, MediaState state) {}

  @override
  void initState() {
    super.initState();
    _screenBlocProvider = BlocProvider(
        create: (BuildContext context) => ScreenBloc(HomeScreenState()));

    _mediaBlocProvider = BlocProvider(
        create: (BuildContext context) => MediaBloc(InitialMediaState()));

    _screenBlocListener =
        BlocListener<ScreenBloc, ScreenState>(listener: _listenForScreenEvents);

    _mediaBlocListener =
        BlocListener<MediaBloc, MediaState>(listener: _listenForMediaEvents);

    _currentPage = HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [_screenBlocProvider, _mediaBlocProvider],
      child: MultiBlocListener(
        listeners: [_screenBlocListener, _mediaBlocListener],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Play Master',
          home: Stack(
            children: [
              _currentPage,
            ],
          ),
        ),
      ),
    );
  }
}
