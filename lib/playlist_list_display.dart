import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'app_utils.dart';
import 'music_utils.dart';
import 'main_play_list_display.dart';

class PlaylistListDisplay extends StatefulWidget {
  final Playlist pl;

  PlaylistListDisplay(this.pl);

  @override
  _PlaylistListDisplayState createState() => _PlaylistListDisplayState();
}

class _PlaylistListDisplayState extends State<PlaylistListDisplay> {
  @override
  Widget build(BuildContext context) {
    var selectInfo = Provider.of<SelectInfo>(context);
    var musicInfo = Provider.of<MusicInfo>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPlayListDisplay(widget.pl),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
            color: Colors.white,
          ),
          child: _getTitle(selectInfo, musicInfo),
        ),
      ),
    );
  }

  Row _getTitle(SelectInfo selectInfo, MusicInfo musicInfo) {
    List<Widget> titleElements = [
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
        child: Icon(Icons.dehaze),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.pl.name,
            style: TextStyle(fontSize: 20.0),
          ),
          Text('${widget.pl.length} songs'),
        ],
      ),
    ];

    return selectInfo.selecting
        ? Row(
            children: titleElements,
          )

//    Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        Row(
//          children: titleElements,
//        ),
//        GestureDetector(
//          onTap: () {
//            _select(selectInfo);
//          },
//          child: Icon(
//            _selected ? Icons.check_box : Icons.check_box_outline_blank,
//            color: _selected ? PlayMaster.accentColor : Colors.black54,
//          ),
//        ),
//      ],
//    )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: titleElements,
              ),
              GestureDetector(
                onTap: () {
                  if (!musicInfo.shuffle) {
                    //start the playlist at the first song
                    widget.pl.index = 0;
                    //reorder the playlist in case it was previously shuffled
                    widget.pl.reorder(0);
                  } else {
                    //pick a random song to start with and shuffle the rest of the playlist
                    Random r = Random();
                    int randomIndex = r.nextInt(widget.pl.length);
                    widget.pl.index = randomIndex;
                    widget.pl.shuffle();
                  }
                  musicInfo.setSong(widget.pl.song);
                  musicInfo.pl = widget.pl;
                  musicInfo.playing = true;
                  print(musicInfo.song);
                },
                child: Icon(
                  Icons.play_arrow,
                  size: 30.0,
                ),
              )
            ],
          );
  }
}
