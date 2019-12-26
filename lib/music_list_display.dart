import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:stereo/stereo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

import 'main.dart';

//this class is used along with provider to store info about which song is
//playing and whether it's paused or not
class MLDInfo extends ChangeNotifier {
  int _id = -1;
  int _prevId = -1;
  bool _playing = false;

  int get id => _id;
  int get prevId => _prevId;
  bool get playing => _playing;

  set playing(bool playing) => _playing = playing;
  set id(int id) {
    _prevId = _id;
    _id = id;
    notifyListeners();
  }
}

//this widget is used as an item in the user's list of widgets
class MusicListDisplay extends StatefulWidget {
  final String _path;
  final String _name;
  final int _id;

  MusicListDisplay(this._path, this._name, this._id);

  int get id => _id;
  String get name => _name;

  @override
  State<StatefulWidget> createState() {
    return _MusicListDisplayState();
  }
}

class _MusicListDisplayState extends State<MusicListDisplay> {
//  Stereo _stereo = Stereo();
  //this bool refers to whether this widget is paused or not
  //differs from the one in MLDInfo because it doesn't necessarily
  //refer to the song that's playing at any given time
  bool _paused = true;
  Icon _buttonIcon = Icon(Icons.play_arrow);
  Color bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
//    print('INITIALIZING ${widget._name}');
//    _loadSong(widget.path);
  }

//  void _loadSong(String path) async {
//    await player.setUrl(widget.path);//use this to implement looping
//      await player.setReleaseMode(ReleaseMode.LOOP);
//  }

  //plays the audio of this widget
  void _play() async {
    await PlayMaster.player.play(widget._path, isLocal: true);
  }

  //pauses the audio of this widget
  void _pause() async {
    await PlayMaster.player.pause();
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<MLDInfo>(context);

    //if the widget that is currently playing music is this widget, change the
    //background color to grey, else make sure the background color is white
    if (info.id == widget._id) {
      //this handles the edge case where the widget is unloaded and everything
      //gets reinitialized yet the music is still playing
      if (info.playing) {
        _buttonIcon = Icon(Icons.pause);
        _paused = false;
      }
      bgColor = Colors.grey;
    } else {
      bgColor = Colors.white;
      _buttonIcon = Icon(Icons.play_arrow);
      _paused = true;
    }
    return GestureDetector(
      onTap: () {
        //pause or play the music depending on if the music is playing or not
        //and set the id of the current playing song to this one
        if (_paused) {
          _play();
          info.playing = true;
          _buttonIcon = Icon(Icons.pause);
        } else {
          _pause();
          info.playing = false;
          _buttonIcon = Icon(Icons.play_arrow);
        }
        _paused = !_paused;
        info.id = widget._id;
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              _buttonIcon,
              Text(widget._name),
            ],
          ),
          decoration: BoxDecoration(border: Border.all(), color: bgColor),
        ),
      ),
    );
  }
}
