import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'music_list_display.dart';

//this is used for displying all the information about the song that is currently
//playing such as whether it's paused, what song is next in the playlist etc. It
//also allows functinoality like skip, seek, etc. There is a small version
//which displays at the bottom of the screen and allows you to pause/play the
//song, skip to the next song, and stop the song, there is also a large version
//which takes up all of the screen and has all the other information
class MainMusicDisplay extends StatefulWidget {
  final String name;

  MainMusicDisplay(this.name);

  @override
  _MainMusicDisplayState createState() => _MainMusicDisplayState();
}

class _MainMusicDisplayState extends State<MainMusicDisplay> {
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<MLDInfo>(context);
    //display the right icon depending on whether the song is playing or paused
    Icon _buttonIcon = info.playing
        ? Icon(
            Icons.pause,
            size: 40.0,
          )
        : Icon(
            Icons.play_arrow,
            size: 40.0,
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
              Text(
                widget.name,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'roboto',
                    fontSize: 25.0,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
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
                  GestureDetector(
                    onTap: () {
                      //stop the music and set name, path, and id back to their
                      //default values. setting info.name to '' also removes this
                      //widget from the stack since the homepage gets rebuilt
                      PlayMaster.player.stop();
                      info.name = '';
                      info.path = '';
                      info.id = -1;
                      info.update();
                    },
                    child: Icon(
                      Icons.clear,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
