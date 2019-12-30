import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'music_list_display.dart';
import 'music_utils.dart';

//this is used for displying all the information about the song that is currently
//playing such as whether it's paused, what song is next in the playlist etc. It
//also allows functinoality like skip, seek, etc. There is a small version
//which displays at the bottom of the screen and allows you to pause/play the
//song, skip to the next song, and stop the song, there is also a large version
//which takes up all of the screen and has all the other information
class MainMusicDisplay extends StatefulWidget {
  final Playlist pl;
  final int index;

  MainMusicDisplay(this.pl, this.index) {
    pl.index = index;
  }

  @override
  _MainMusicDisplayState createState() => _MainMusicDisplayState();
}

class _MainMusicDisplayState extends State<MainMusicDisplay> {
  final double ICON_SIZE = 35.0;

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<MLDInfo>(context);
    //display the right icon depending on whether the song is playing or paused
    Icon _buttonIcon = info.playing
        ? Icon(
            Icons.pause,
            size: ICON_SIZE,
          )
        : Icon(
            Icons.play_arrow,
            size: ICON_SIZE,
          );
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: GestureDetector(
        onTap: () {
          //TODO implement large version of this widget
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Text(
                  widget.pl.song.name,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'roboto',
                      fontSize: 25.0,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                      child: GestureDetector(
                        onTap: () {
                          //pause or play the song depending on if the song is
                          //currently paused or playing
                          info.playing ? info.pause() : info.play();
                          info.playing = !info.playing;
                          info.update();
                        },
                        child: _buttonIcon,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.pl.next();
                          info.song = widget.pl.song;
                        },
                        child: Icon(
                          Icons.skip_next,
                          size: ICON_SIZE,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //stop the music and set name, path, and id back to their
                        //default values. setting info.song to Song.init() also
                        // removes this widget from the stack since the homepage
                        // gets rebuilt
                        PlayMaster.player.stop();
                        info.song = Song.init();
                        info.update();
                      },
                      child: Icon(
                        Icons.clear,
                        size: ICON_SIZE,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
