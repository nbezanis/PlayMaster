import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:collection';

import 'main.dart';
import 'music_utils.dart';

//this class is used along with provider to store info about which song is
//playing
class MusicInfo extends ChangeNotifier {
  Playlist _pl = Playlist.init();
  Song _song = Song.init();
  bool _playing = false;
  bool _stopped = false;
  bool _shuffle = false;
  Repeat _repeat = Repeat.off;

  Song get song => _song;
  Playlist get pl => _pl;
  bool get playing => _playing;
  bool get stopped => _stopped;
  bool get shuffle => _shuffle;
  Repeat get repeat => _repeat;

  set playing(bool playing) => _playing = playing;
  set pl(Playlist pl) => _pl = pl;
  set repeat(Repeat repeat) => _repeat = repeat;
  set shuffle(bool shuff) {
    _shuffle = shuff;
    notifyListeners();
  }

  void setSong(Song song) async {
    _pl.index = song.index;
    _song = song;
    _playing = true;
    PlayMaster.player.setUrl(song.path, isLocal: true);
    if (song.id != -1) {
      play();
    }
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  //plays the audio of this widget
  void play() async {
    await PlayMaster.player.resume();
  }

  //pauses the audio of this widget
  void pause() async {
    await PlayMaster.player.pause();
  }

  //stop the music and set name, path, and id back to their
  //default values. setting info.song to Song.init() also
  // removes this widget from the stack since the homepage
  // gets rebuilt
  void stop() async {
    await PlayMaster.player.stop();
    _playing = false;
    _song = Song.init();
    _pl = Playlist.init();
    PlayMaster.sliderValue = 0.0;
    notifyListeners();
  }
}

//class used to keep track of what color is currently selected
class ColorInfo extends ChangeNotifier {
  Color _color = PlayMaster.accentColor;

  Color get color => _color;

  set color(Color c) {
    _color = c;
    PlayMaster.accentColor = c;
    PlayMaster.getSupportingColors();
    notifyListeners();
  }
}

//class used to keep track of selected items
class SelectInfo extends ChangeNotifier {
  bool _selecting = false;
  //keeps track of selected songs
  SplayTreeSet<Song> _selectedMusic = SplayTreeSet<Song>(Song.compare);
  Select _type = Select.choose;

  bool get selecting => _selecting;
  Select get type => _type;
  SplayTreeSet<Song> get selectedMusic => _selectedMusic;

  set selecting(bool selecting) {
    _selecting = selecting;
    notifyListeners();
  }

  set type(Select type) {
    _type = type;
    notifyListeners();
  }

  void selectAll(SplayTreeSet<Song> songs) {
    _type = Select.all;
    for (int i = 0; i < songs.length; i++) {
      _selectedMusic.add(songs.elementAt(i));
    }
    notifyListeners();
  }

  void deselectAll() {
    _type = Select.none;
    notifyListeners();
  }

  void addMusic(Song s) => _selectedMusic.add(s);
  void removeMusic(Song s) => _selectedMusic.remove(s);

  //returns all the songs that were selected
  SplayTreeSet<Song> finishSongSelect() {
    _selecting = false;
    //make sure the select mode is set to none
    deselectAll();
    return _selectedMusic;
  }
}
