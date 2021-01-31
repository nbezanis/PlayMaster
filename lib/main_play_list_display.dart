// import 'dart:collection';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'app_utils.dart';
// import 'music_utils.dart';
// import 'main.dart';
// import 'music_list_display.dart';
//
// class MainPlaylistDisplay extends StatefulWidget {
//   final Playlist pl;
//
//   MainPlaylistDisplay(this.pl);
//
//   @override
//   State<StatefulWidget> createState() => _MainPlaylistDisplayState();
// }
//
// class _MainPlaylistDisplayState extends State<MainPlaylistDisplay>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//
//   Widget _getAppBarTitle(SelectInfo selectInfo, MusicInfo musicInfo) {
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(right: 16.0),
//           child: GestureDetector(
//             onTap: () async {
//               await _controller.reverse();
//               musicInfo.mpdActive = false;
//             },
//             child: Icon(
//               Icons.arrow_back,
//               size: 30.0,
//             ),
//           ),
//         ),
//         Text(
//           widget.pl.name,
//           style: TextStyle(fontSize: 30.0),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 100));
//     _controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     MusicInfo musicInfo = Provider.of<MusicInfo>(context);
//     SelectInfo selectInfo = Provider.of<SelectInfo>(context);
//     return GestureDetector(
//       //set the offset of the screen equal to where the user drags it
//       onHorizontalDragUpdate: (details) {
//         _controller.value =
//             1 - (details.globalPosition.dx / MediaQuery.of(context).size.width);
//       },
//       //if the screen is more than 100 pixels away form its origin, close the page
//       //otherwise, snap it back to its origin
//       onHorizontalDragEnd: (details) async {
//         if ((1 - _controller.value) * MediaQuery.of(context).size.width > 100) {
//           await _controller.reverse();
//           musicInfo.mpdActive = false;
//         } else {
//           _controller.forward();
//         }
//       },
//       child: AnimatedBuilder(
//           animation: _controller,
//           builder: (context, _) {
//             return Transform.translate(
//               offset: Offset(
//                   MediaQuery.of(context).size.width * (1 - _controller.value),
//                   0.0),
//               child: Scaffold(
//                 appBar: AppBar(
//                   backgroundColor: PlayMaster.accentColor,
//                   title: _getAppBarTitle(selectInfo, musicInfo),
//                 ),
//                 body: ListView.builder(
//                   itemCount: widget.pl.length,
//                   itemBuilder: (context, index) =>
//                       MusicListDisplay(widget.pl.displaySongs[index]),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
