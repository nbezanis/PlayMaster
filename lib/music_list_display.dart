import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'music_utils.dart';
import 'app_utils.dart';

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
  //this bool refers to whether this widget is paused or not
  //differs from the one in MusicInfo because it doesn't necessarily
  //refer to the song that's playing at any given time
  bool _paused = true;
  Color bgColor = Colors.white;
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    var musicInfo = Provider.of<MusicInfo>(context);
    var selectInfo = Provider.of<SelectInfo>(context);

    if (selectInfo.type == Select.all) {
      _selected = true;
      selectInfo.addMusic(widget.song);
    } else if (selectInfo.type == Select.none) {
      _selected = false;
      selectInfo.removeMusic(widget.song);
    }
    //if the widget that is currently playing music is this widget, change the
    //background color to grey, else make sure the background color is white
    if (musicInfo.song.id == widget.song.id) {
      //this handles the edge case where the widget is unloaded and everything
      //gets reinitialized yet the music is still playing
      if (musicInfo.playing) {
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
        if (selectInfo.selecting) {
          _select(selectInfo);
        } else {
          //pause or play the music depending on if the music is playing or not
          //and set the id of the current playing song to this one
          musicInfo.song = widget.song;
          if (_paused) {
            musicInfo.play();
            musicInfo.playing = true;
          } else {
            musicInfo.pause();
            musicInfo.playing = false;
          }
          _paused = !_paused;
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: _getTitle(selectInfo),
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

  void _select(SelectInfo selectInfo) {
    selectInfo.type = Select.choose;
    setState(() {
      _selected = !_selected;
    });
    _selected
        ? selectInfo.addMusic(widget.song)
        : selectInfo.removeMusic(widget.song);
  }

  Row _getTitle(SelectInfo selectInfo) {
    List<Widget> titleElements = [
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
        child: Icon(Icons.music_note),
      ),
      Text(
        widget.song.name,
        style: TextStyle(fontSize: 20.0),
      ),
    ];

    return selectInfo.selecting
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: titleElements,
              ),
              GestureDetector(
                onTap: () {
                  _select(selectInfo);
                },
                child: Icon(
                  _selected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: _selected ? PlayMaster.accentColor : Colors.black54,
                ),
              ),
            ],
          )
        : Row(
            children: titleElements,
          );
  }
}
