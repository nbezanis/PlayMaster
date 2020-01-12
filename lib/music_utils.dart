import 'dart:collection';
import 'dart:math';

class Song {
  String _path;
  String _name;
  int _id;
  int _index;
  Song.init() {
    _path = '';
    _name = '';
    _id = -1;
    _index = -1;
  }
  Song(this._path, this._id, this._index) {
    _name = _getSongName(_path);
  }

  String get path => _path;
  int get id => _id;
  String get name => _name;
  int get index => _index;

  set index(int i) => _index = i;

  //isolates a song's name given the path to the mp3 file
  String _getSongName(String path) {
    String name;
    name = path.substring(path.lastIndexOf('/') + 1, path.indexOf('.mp3'));
    return name;
  }

//  String toJson() {
//    return ''
//  }

  //compare function used to make songs compatible with splay tree
  static int compare(Song key1, Song key2) {
    return key1.name.compareTo(key2.name);
  }
}

class Playlist {
  List<Song> _songs;
  HashSet<int> _excludedIds = HashSet<int>();
  int _index = 0;

  Playlist(this._songs);
  Playlist.index(this._songs, this._index);
  Playlist.id(this._songs, int id) {
    for (int i = 0; i < _songs.length; i++) {
      if (_songs[i].id == id) {
        _index = i;
      }
    }
  }

  Playlist.init() {
    _songs = [Song.init()];
  }

  int get index => _index;
  List<Song> get songs => _songs;
  Song get song => _songs[_index];
  Song get nextSong {
    if (_index == _songs.length - 1) {
      return null;
    }
    bool found = false;
    int nextIndex = 0;
    for (int i = _index + 1; i < _songs.length; i++) {
      if (!_excludedIds.contains(_songs[i].id)) {
        found = true;
        nextIndex = i;
        break;
      }
    }
    return found ? _songs[nextIndex] : null;
  }

  set index(int index) => _index = index;

  //advances the playlist to the next song in the playlist, returns true if the
  //playlist can advance and false if not
  bool next() {
    if (_index == _songs.length - 1) {
      return false;
    }
    bool found = false;
    for (int i = _index + 1; i < _songs.length; i++) {
      if (!_excludedIds.contains(_songs[i].id)) {
        found = true;
        index = i;
        break;
      }
    }
    return found;
  }

  //goes back to the last song in the playlist
  void prev() {
    if (_index == 0) {
      return;
    }
    for (int i = _index - 1; i > -1; i--) {
      if (!_excludedIds.contains(_songs[i].id)) {
        index = i;
        break;
      }
    }
  }

  //shuffles the playlist
  void shuffle() {
    List<Song> newList = [];
    song.index = 0;
    newList.add(song);
    List<int> indexes = [];
    for (int i = 0; i < _songs.length; i++) {
      if (_songs[i] != song && !(_excludedIds.contains(_songs[i]))) {
        indexes.add(i);
      }
    }
    Random r = Random();
    while (indexes.length > 0) {
      int randomNum = r.nextInt(indexes.length);
      int randomIndex = indexes[randomNum];
      _songs[randomIndex].index = newList.length;
      newList.add(_songs[randomIndex]);
      indexes.removeAt(randomNum);
    }
    _songs = newList;
    _index = 0;
  }

  //sets all songs' index to it's position in the list
  void resetIndexes(int songId) {
    for (int i = 0; i < _songs.length; i++) {
      _songs[i].index = i;
      //set the index of the playlist to the index of the song that was
      //playing when the playlist was shuffled
      if (_songs[i].id == songId) {
        _index = i;
      }
    }
  }

  //add the song to the hashset of songs that the user wants to exclude from
  //their playlist
  void exclude(Song s) {
    _excludedIds.add(s.id);
  }
}

//this class is used for displaying times of songs
class Time {
  int _seconds;

  Time(this._seconds);

  //this uses the seconds and returns a normalized way of viewing time
  String toString() {
    if (_seconds >= 3600) {
      String min = _seconds / 60 >= 10
          ? '${(_seconds / 60).floor()}'
          : '0${(_seconds / 60).floor()}';
      String secs =
          _seconds % 3600 >= 10 ? '${_seconds % 3600}' : '0${_seconds % 3600}';
      return '${(_seconds / 3600).floor()}:$min:$secs';
    } else if (_seconds >= 60) {
      return _seconds % 60 >= 10
          ? '${(_seconds / 60).floor()}:${_seconds % 60}'
          : '${(_seconds / 60).floor()}:0${_seconds % 60}';
    } else {
      return _seconds >= 10 ? '0:$_seconds' : '0:0$_seconds';
    }
  }
}
