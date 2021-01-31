// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'main.dart';
// import 'music_list_display.dart';
// import 'music_utils.dart';
// import 'app_utils.dart';
//
// //this is used for displying all the information about the song that is currently
// //playing such as whether it's paused, what song is next in the playlist etc. It
// //also allows functinoality like skip, seek, etc. There is a small version
// //which displays at the bottom of the screen and allows you to pause/play the
// //song, skip to the next song, and stop the song, there is also a large version
// //which takes up all of the screen and has all the other information
// class MainMusicDisplay extends StatefulWidget {
//   MainMusicDisplay();
//
//   @override
//   _MainMusicDisplayState createState() => _MainMusicDisplayState();
// }
//
// class _MainMusicDisplayState extends State<MainMusicDisplay>
//     with SingleTickerProviderStateMixin {
//   AnimationController animController;
//   Animation<double> scale;
//   Animation<Offset> slide;
//
//   var completion;
//
//   bool _isSmall = true;
//   double _topOffset = 0.0;
//   bool _displayPlayer = true;
//   Color _playerColor = PlayMaster.accentColor;
//   Color _plColor = Colors.transparent;
//
//   @override
//   void initState() {
//     super.initState();
//     var info = Provider.of<MusicInfo>(context, listen: false);
//     animController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 100),
//     );
//
//     scale = Tween<double>(begin: 0, end: 1).animate(animController);
//     slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
//         .animate(animController);
//
//     completion = PlayMaster.player.onPlayerCompletion.listen((event) {
//       _handleSongCompletion(info);
//     });
//   }
//
//   //handles what to do after a song is completed
//   void _handleSongCompletion(MusicInfo info) {
//     if (info.repeat == Repeat.off || info.repeat == Repeat.all) {
//       bool success = info.pl.next(info.repeat);
//       info.setSong(info.pl.song);
// //      if (!success && info.repeat == Repeat.all) {
// //        info.setSong(info.pl.songs[0]);
// //      } else if (success) {
// //        info.setSong(info.pl.song);
// //      }
//     } else {
//       //if we're repeating the current song, reset the song and play
//       PlayMaster.player.seek(Duration(microseconds: 0));
//       info.play();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var info = Provider.of<MusicInfo>(context);
//     //when the app rebuilds after picking a color we need to make sure the
//     //correct color is displaying
//     if (_displayPlayer) {
//       _playerColor = PlayMaster.accentColor;
//       _plColor = Colors.transparent;
//     } else {
//       _playerColor = Colors.transparent;
//       _plColor = PlayMaster.accentColor;
//     }
//     return _isSmall ? _getSmall(info) : _getLarge(info);
//   }
//
//   @override
//   void dispose() {
//     completion.cancel();
//     super.dispose();
//   }
//
//   //display the right icon depending on whether the song is playing or paused
//   Icon _getButtonIcon(double size, bool playing) {
//     return playing
//         ? Icon(
//             Icons.pause,
//             size: size,
//           )
//         : Icon(
//             Icons.play_arrow,
//             size: size,
//           );
//   }
//
//   //returns the small version of this widget
//   Widget _getSmall(MusicInfo info) {
//     final double ICON_SIZE = 35.0;
//     Icon _buttonIcon = _getButtonIcon(ICON_SIZE, info.playing);
//     return Align(
//       alignment: FractionalOffset.bottomCenter,
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             _isSmall = false;
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             border: Border(
//               top: BorderSide(color: Colors.grey),
//             ),
//             color: Colors.white,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Expanded(
//                 flex: 6,
//                 child: Text(
//                   info.song.name,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(fontSize: 25.0),
//                 ),
//               ),
//               Expanded(
//                 flex: 4,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           //pause or play the song depending on if the song is
//                           //currently paused or playing
//                           info.playing ? info.pause() : info.play();
//                           info.playing = !info.playing;
//                           info.update();
//                         },
//                         child: _buttonIcon,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           //skips to the next song in the playlist
//                           info.pl.next(info.repeat);
//                           info.setSong(info.pl.song);
//                         },
//                         child: Icon(
//                           Icons.skip_next,
//                           size: ICON_SIZE,
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         //stops music
//                         info.stop();
//                       },
//                       child: Icon(
//                         Icons.clear,
//                         size: ICON_SIZE,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _getPPViewSwitcher() {
//     return Container(
//       color: Colors.transparent,
//       child: Row(
//         children: <Widget>[
//           Container(
//             child: Expanded(
//               flex: 5,
//               child: Container(
//                 margin: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: _playerColor,
//                       width: 3.0,
//                     ),
//                   ),
//                 ),
//                 child: FlatButton(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   child: Text(
//                     'Player',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _displayPlayer = true;
//                       _playerColor = PlayMaster.accentColor;
//                       _plColor = Colors.transparent;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Container(
//               margin: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: _plColor, width: 3.0),
//                 ),
//               ),
//               child: FlatButton(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 child: Text(
//                   'Play List',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _displayPlayer = false;
//                     _plColor = PlayMaster.accentColor;
//                     _playerColor = Colors.transparent;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getRepeatColor(Repeat repeat) =>
//       repeat == Repeat.all || repeat == Repeat.one
//           ? PlayMaster.accentColor
//           : Colors.black;
//
//   String _getRepeatSVG(Repeat repeat) =>
//       repeat == Repeat.off || repeat == Repeat.all
//           ? 'assets/repeat.svg'
//           : 'assets/repeatOne.svg';
//
//   Widget _getPlayer(MusicInfo info, Icon buttonIcon) {
//     return Container(
//       //give the column a height that is equal to the height of the main music display player section
//       height: MediaQuery.of(context).size.height - 106.0 - _topOffset,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
//                   child: Text(
//                     info.song.name,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(fontSize: 32.0),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width / 1.7,
//                 height: MediaQuery.of(context).size.width / 1.8,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       offset: Offset(5.0, -5.0),
//                       blurRadius: 5.0,
//                     )
//                   ],
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     stops: [0.1, 0.9],
//                     colors: [
//                       PlayMaster.accentColor,
//                       PlayMaster.accentColorGradient
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                   child: SvgPicture.asset(
//                     'assets/music_note.svg',
//                     semanticsLabel: '${info.song.name}',
//                   ),
//                   padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 16.0),
//                 ),
//               ),
//               MusicSlider(info),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     GestureDetector(
//                       child: SvgPicture.asset(
//                         'assets/shuffle.svg',
//                         semanticsLabel: 'previous',
//                         color: info.shuffle
//                             ? PlayMaster.accentColor
//                             : Colors.black,
//                         width: 30.0,
//                         height: 30.0,
//                       ),
//                       onTap: () {
//                         setState(() {
//                           if (info.shuffle) {
//                             //reorder the playlist if the shuffle option is unselected
//                             info.pl.index = 0;
//                             info.pl.reorder(0);
//                             info.shuffle = false;
//                           } else {
//                             //shuffle the playlist if the shuffle option is selected
//                             info.pl.shuffle();
//                             info.shuffle = true;
//                           }
//                         });
//                       },
//                     ),
//                     GestureDetector(
//                       child: SvgPicture.asset(
//                         'assets/rewind.svg',
//                         semanticsLabel: 'previous',
//                         width: 35.0,
//                         height: 35.0,
//                       ),
//                       onTap: () {
//                         info.pl.prev();
//                         info.setSong(info.pl.song);
//                       },
//                     ),
//                     GestureDetector(
//                       child: buttonIcon,
//                       onTap: () {
//                         //pause or play the song depending on if the song is
//                         //currently paused or playing
//                         info.playing ? info.pause() : info.play();
//                         info.playing = !info.playing;
//                         info.update();
//                       },
//                     ),
//                     GestureDetector(
//                       child: SvgPicture.asset(
//                         'assets/skip.svg',
//                         semanticsLabel: 'skip',
//                         width: 35.0,
//                         height: 35.0,
//                       ),
//                       onTap: () {
//                         //skips to the next song in the playlist
//                         info.pl.next(info.repeat);
//                         info.setSong(info.pl.song);
//                       },
//                     ),
//                     GestureDetector(
//                       child: SvgPicture.asset(
//                         _getRepeatSVG(info.repeat),
//                         semanticsLabel: 'repeat',
//                         color: _getRepeatColor(info.repeat),
//                         width: 30.0,
//                         height: 30.0,
//                       ),
//                       onTap: () {
//                         setState(() {
//                           //set the repeat icon to the next value in the repeat enum
//                           info.repeat =
//                               Repeat.values[(info.repeat.index + 1) % 3];
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
//                 child: Row(
//                   children: <Widget>[
//                     Icon(
//                       Icons.volume_mute,
//                       size: 50.0,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width / 1.6,
//                       child: SliderTheme(
//                         data:
//                             SliderTheme.of(context).copyWith(trackHeight: 2.0),
//                         child: Slider.adaptive(
//                           activeColor: PlayMaster.accentColor,
//                           inactiveColor: Colors.black12,
//                           onChanged: (value) {
//                             //TODO implement change volume
//                           },
//                           value: 0.0, //TODO make current volume
//                           min: 0.0,
//                           max: 1.0, //TODO make max volume
//                         ),
//                       ),
//                     ),
//                     Icon(
//                       Icons.volume_up,
//                       size: 50.0,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             width: double.infinity,
//             height: 50.0,
//             color: PlayMaster.fadedGrey,
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 0.0),
//               child: Text(
//                 info.pl.nextSong == null
//                     ? 'Last Track In Play List'
//                     : 'Next Track: ${info.repeat == Repeat.one ? info.song.name : info.pl.nextSong.name}',
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _getPlayList(MusicInfo info) {
//     info.pl.activeSongs = info.pl.songs;
//     return MediaQuery.removePadding(
//       context: context,
//       removeTop: true,
//       child: Expanded(
//         child: ListView.builder(
//           itemCount: info.pl.activeSongs.length,
//           itemBuilder: (context, index) => Dismissible(
//             key: Key(info.pl.activeSongs[index].id.toString()),
//             direction: DismissDirection.endToStart,
//             background: Container(color: Colors.red),
//             onDismissed: (direction) {
//               setState(() {
//                 //exclude the song that was swiped
//                 info.pl.exclude(info.pl.activeSongs[index]);
//                 //if the song that was swiped is the current song,
//                 //skip to the next song
//                 if (info.pl.activeSongs[index].id == info.song.id) {
//                   bool success = info.pl.next(info.repeat);
//                   info.setSong(info.pl.song);
//                   //if this is the last song in the playlist,
//                   //stop the music and close the music display
//                   if (!success) {
//                     info.stop();
//                     info.setSong(Song.init());
//                   }
//                 }
//               });
//             },
//             child: MusicListDisplay(info.pl.activeSongs[index]),
//           ),
//         ),
//       ),
//     );
//   }
//
//   //returns the large version of this widget
//   Widget _getLarge(MusicInfo info) {
//     Icon _buttonIcon = _getButtonIcon(100.0, info.playing);
//     animController.forward();
//     return Positioned.fill(
//       top: 40.0 + _topOffset,
//       child: GestureDetector(
//         onVerticalDragUpdate: (details) {
//           //update the topOffset so that the widget goes down with the user's finger
//           setState(() {
//             _topOffset += details.delta.dy;
//           });
//         },
//         onVerticalDragEnd: (details) {
//           //if the widget is close to where it originally was, we can assume
//           //the user wants to cancel their drag so we return it to it's initial
//           //location
//           if (_topOffset < 100.0) {
//             setState(() {
//               _topOffset = 0;
//             });
//             return;
//           }
//           //reverse the animation and switch back to the small version of the
//           //widget
//           setState(() {
//             animController.reverse();
//             _isSmall = true;
//           });
//           _topOffset = 0;
//         },
//         child: SlideTransition(
//           position: slide,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   offset: Offset(0.0, -5.0),
//                   blurRadius: 5.0,
//                 )
//               ],
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(15.0),
//                 topLeft: Radius.circular(15.0),
//               ),
//             ),
//             child: Column(
//               children: <Widget>[
//                 //grey box at top
//                 Container(
//                   decoration: BoxDecoration(
//                     color: PlayMaster.fadedGrey,
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(15.0),
//                       topLeft: Radius.circular(15.0),
//                     ),
//                   ),
//                   //white bar + ppViewSwitcher
//                   child: Column(
//                     children: <Widget>[
//                       Center(
//                         child: Container(
//                           height: 5.0,
//                           margin: EdgeInsets.fromLTRB(150.0, 10.0, 150.0, 0.0),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                       _getPPViewSwitcher(),
//                     ],
//                   ),
//                 ),
//                 _displayPlayer
//                     ? _getPlayer(info, _buttonIcon)
//                     : _getPlayList(info),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MusicSlider extends StatefulWidget {
//   final MusicInfo info;
//
//   MusicSlider(this.info);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _MusicSliderState();
//   }
// }
//
// class _MusicSliderState extends State<MusicSlider> {
//   double _sliderValue = PlayMaster.sliderValue;
//   var positionStream;
//   bool _sliding = false;
//
//   //init music slider in build function of main music display and see if that helps
//   @override
//   void initState() {
//     super.initState();
//     positionStream = PlayMaster.player.onAudioPositionChanged.listen((p) {
//       if (!_sliding) {
//         setState(() {
//           _sliderValue =
//               p.inMicroseconds > widget.info.song.duration.inMicroseconds
//                   ? widget.info.song.duration.inMicroseconds.toDouble()
//                   : p.inMicroseconds.toDouble();
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var info = Provider.of<MusicInfo>(context);
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width * 0.1,
//             child: FittedBox(
//               child: Text(
//                 '${Time.fromMicro(_sliderValue).toString()}',
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.71,
//             child: SliderTheme(
//               data: SliderTheme.of(context).copyWith(trackHeight: 5.0),
//               child: Slider(
//                 activeColor: PlayMaster.accentColor,
//                 inactiveColor: Colors.black12,
//                 onChangeStart: (value) {
//                   info.pause();
//                   _sliding = true;
//                 },
//                 onChangeEnd: (value) {
//                   if (info.playing) {
//                     info.play();
//                   }
//                   PlayMaster.player.seek(Duration(microseconds: value.floor()));
//                   _sliding = false;
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     _sliderValue = value;
//                   });
//                 },
//                 value: _sliderValue > widget.info.song.duration.inMicroseconds
//                     ? widget.info.song.duration.inMicroseconds.toDouble()
//                     : _sliderValue,
//                 min: 0.0,
//                 max: widget.info.song.duration.inMicroseconds.toDouble(),
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.1,
//             child: FittedBox(
//               child: Text(
//                 '${Time.fromMicro(widget.info.song.duration.inMicroseconds - _sliderValue).toString()}',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     PlayMaster.sliderValue = _sliderValue;
//     positionStream.cancel();
//     super.dispose();
//   }
// }
