// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'dart:collection';
//
// import 'main.dart';
// import 'music_list_display.dart';
// import 'app_utils.dart';
// import 'music_utils.dart';
//
// //class to hold the providers required for music list display to work
// class PlaylistCreator extends StatelessWidget {
//   final MusicInfo musicInfo;
//   final SelectInfo selectInfo;
//
//   PlaylistCreator(this.musicInfo, this.selectInfo);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: musicInfo,
//       child: ChangeNotifierProvider.value(
//           value: selectInfo, child: PlaylistContainer()),
//     );
//   }
// }
//
// //class that holds the display of the plalylist creator
// class PlaylistContainer extends StatelessWidget {
//   //shows a dialog asking for the name of the playlist
//   //passes back the name the user inputted
//   Future<String> createNameDialog(BuildContext context) {
//     TextEditingController controller = TextEditingController();
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Enter Playlist Name'),
//             content: TextField(
//               controller: controller,
//             ),
//             actions: <Widget>[
//               MaterialButton(
//                 elevation: 5.0,
//                 child: Text('Done'),
//                 onPressed: () {
//                   Navigator.of(context).pop(controller.text.toString());
//                 },
//               ),
//             ],
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var selectInfo = Provider.of<SelectInfo>(context);
// //    if (selectInfo.selectedMusic.isEmpty) {
// //      selectInfo.selecting = true;
// //    }
//
//     void _addPlaylist() {
//       //shows dialog asking for name when pressed
//       createNameDialog(context).then((name) {
//         int plIdTotal;
//         //sends back the playlist that was created
//         SplayTreeSet<Song> songs = selectInfo.finishSongSelect();
//         //if the user didn't select anything, don't ceate a playlist
//         if (songs.length == 0) {
//           //show a toast prompting the user to select music
//           Fluttertoast.showToast(
//               msg: "Please select music and try again",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIos: 1,
//               backgroundColor: PlayMaster.accentColor,
//               textColor: Colors.white,
//               fontSize: 16.0);
//           selectInfo.selecting = true;
//           return;
//         }
//         //get id for playlist
//         PlayMaster.getIntFromPrefs('plIdTotal').then((val) {
//           plIdTotal = val ?? 0;
//           Navigator.of(context)
//               .pop(Playlist.name(songs.toList(), name, plIdTotal));
//           //increase id total
//           plIdTotal++;
//         }).then((val) {
//           //save id total in prefs
//           PlayMaster.putIntInPrefs('plIdTotal', plIdTotal);
//         });
//       });
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: PlayMaster.accentColor,
//         title: Text('Add Play List'),
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
//             child: ButtonTheme(
//               padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
//               minWidth: 0,
//               height: 0,
//               child: RaisedButton(
//                 color: Colors.white,
//                 onPressed: () => selectInfo.type == Select.all
//                     ? selectInfo.deselectAll()
//                     : selectInfo.selectAll(PlayMaster.music),
//                 child: Text(
//                   selectInfo.type == Select.all ? 'deselect all' : 'select all',
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
//             child: ButtonTheme(
//               padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
//               minWidth: 0,
//               height: 0,
//               child: RaisedButton(
//                 color: Colors.white,
//                 onPressed: _addPlaylist,
//                 child: Text(
//                   'Add',
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: PlayMaster.music.length,
//         itemBuilder: (BuildContext context, int index) =>
//             MusicListDisplay(PlayMaster.music.elementAt(index)),
//       ),
//     );
//   }
// }
