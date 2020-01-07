import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:stereo/stereo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

import 'main.dart';
import 'music_utils.dart';

//this widget is used as an item in the user's list of widgets
class MusicListDisplay extends StatefulWidget {
  final Song song;

  MusicListDisplay(this.song);

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

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<MLDInfo>(context);

    //if the widget that is currently playing music is this widget, change the
    //background color to grey, else make sure the background color is white
    if (info.song.id == widget.song.id) {
      //this handles the edge case where the widget is unloaded and everything
      //gets reinitialized yet the music is still playing
      if (info.playing) {
        _paused = false;
      } else {
        _paused = true;
      }
      bgColor = PlayMaster.musicbg;
    } else {
      bgColor = Colors.white;
      _paused = true;
    }
    return GestureDetector(
      onTap: () {
        //pause or play the music depending on if the music is playing or not
        //and set the id of the current playing song to this one
        info.song = widget.song;
        if (_paused) {
          info.play();
          info.playing = true;
        } else {
          info.pause();
          info.playing = false;
        }
        _paused = !_paused;
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                child: Icon(Icons.music_note),
              ),
              Text(
                widget.song.name,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
            color: bgColor,
          ),
        ),
      ),
    );
  }
}
