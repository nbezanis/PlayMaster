import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'music_list_display.dart';
import 'music_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class _MainMusicDisplayState extends State<MainMusicDisplay>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> scale;
  Animation<Offset> slide;

  bool _isSmall = true;
  double _topOffset = 0.0;
  bool _displayPlayer = true;
  Color _playerColor = PlayMaster.accentColor;
  Color _plColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    scale = Tween<double>(begin: 0, end: 1).animate(animController);
    slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(animController);
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<MLDInfo>(context);
    return _isSmall ? _getSmall(info) : _getLarge(info);
  }

  //display the right icon depending on whether the song is playing or paused
  Icon _getButtonIcon(double size, bool playing) {
    return playing
        ? Icon(
            Icons.pause,
            size: size,
          )
        : Icon(
            Icons.play_arrow,
            size: size,
          );
  }

  //returns the small version of this widget
  Widget _getSmall(MLDInfo info) {
    final double ICON_SIZE = 35.0;
    Icon _buttonIcon = _getButtonIcon(ICON_SIZE, info.playing);
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSmall = false;
          });
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
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 25.0),
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
                          //skips to the next song in the playlist
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
                        info.playing = false;
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

  Widget _getPPViewSwitcher() {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Container(
            child: Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _playerColor,
                      width: 3.0,
                    ),
                  ),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    'Player',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _displayPlayer = true;
                      _playerColor = PlayMaster.accentColor;
                      _plColor = Colors.transparent;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _plColor, width: 3.0),
                ),
              ),
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  'Play List',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _displayPlayer = false;
                    _plColor = PlayMaster.accentColor;
                    _playerColor = Colors.transparent;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPlayer(MLDInfo info, Icon buttonIcon) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
            child: Text(
              widget.pl.song.name,
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.7,
          height: MediaQuery.of(context).size.width / 1.8,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(5.0, -5.0),
                blurRadius: 5.0,
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.9],
              colors: [PlayMaster.accentColor, PlayMaster.accentColorGradient],
            ),
          ),
          child: Padding(
            child: SvgPicture.asset(
              'assets/music_note.svg',
              semanticsLabel: '${widget.pl.song.name}',
            ),
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 16.0),
          ),
        ),
        MusicSlider(),
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/shuffle.svg',
                  semanticsLabel: 'previous',
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/rewind.svg',
                  semanticsLabel: 'previous',
                  width: 35.0,
                  height: 35.0,
                ),
                onTap: () {
                  //TODO implement rewind
                  widget.pl.prev();
                  info.song = widget.pl.song;
                },
              ),
              GestureDetector(
                child: buttonIcon,
                onTap: () {
                  //pause or play the song depending on if the song is
                  //currently paused or playing
                  info.playing ? info.pause() : info.play();
                  info.playing = !info.playing;
                  info.update();
                },
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/skip.svg',
                  semanticsLabel: 'previous',
                  width: 35.0,
                  height: 35.0,
                ),
                onTap: () {
                  //skips to the next song in the playlist
                  widget.pl.next();
                  info.song = widget.pl.song;
                },
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/repeat.svg',
                  semanticsLabel: 'previous',
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.volume_mute,
                size: 50.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.6,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 2.0),
                  child: Slider.adaptive(
                    inactiveColor: Colors.black12,
                    onChanged: (value) {
                      //TODO implement change volume
                    },
                    value: 0.0, //TODO make current volume
                    min: 0.0,
                    max: 1.0, //TODO make max volume
                  ),
                ),
              ),
              Icon(
                Icons.volume_up,
                size: 50.0,
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 0.0), //EXTREMELY TEMPORARY
          child: Container(
            width: double.infinity,
            height: 50.0,
            color: PlayMaster.fadedGrey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 0.0),
              child: Text(
                widget.pl.nextSong == null
                    ? 'Last Track In Play List'
                    : 'Next Track: ${widget.pl.nextSong.name}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getPlayList() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Expanded(
        child: ListView.builder(
          itemCount: widget.pl.songs.length,
          itemBuilder: (context, index) => MusicListDisplay(
            widget.pl.songs[index],
          ),
        ),
      ),
    );
  }

  //returns the large version of this widget
  Widget _getLarge(MLDInfo info) {
    Icon _buttonIcon = _getButtonIcon(100.0, info.playing);
    animController.forward();
    return Positioned.fill(
      top: 40.0 + _topOffset,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          //update the topOffset so that the widget goes down with the user's finger
          setState(() {
            _topOffset += details.delta.dy;
          });
        },
        onVerticalDragEnd: (details) {
          //if the widget is close to where it originally was, we can assume
          //the user wants to cancel their drag so we return it to it's initial
          //location
          if (_topOffset < 100.0) {
            setState(() {
              _topOffset = 0;
            });
            return;
          }
          //reverse the animation and switch back to the small version of the
          //widget
          setState(() {
            animController.reverse();
            _isSmall = true;
          });
          _topOffset = 0;
        },
        child: SlideTransition(
          position: slide,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -5.0),
                  blurRadius: 5.0,
                )
              ],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
            ),
            child: Column(
              //look into slivers to solve the scrolling problem
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: PlayMaster.fadedGrey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 5.0,
                          margin: EdgeInsets.fromLTRB(150.0, 10.0, 150.0, 0.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      _getPPViewSwitcher(),
                    ],
                  ),
                ),
                _displayPlayer ? _getPlayer(info, _buttonIcon) : _getPlayList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MusicSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MusicSliderState();
  }
}

class _MusicSliderState extends State<MusicSlider> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        children: <Widget>[
          Text(
            '0:30', //TODO add functionality
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.4,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(trackHeight: 5.0),
              child: Slider.adaptive(
                inactiveColor: Colors.black12,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                value: _sliderValue,
                min: 0.0,
                max: 100.0, //TODO make length of song
              ),
            ),
          ),
          Text(
            '3:00', //TODO add functionality
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
