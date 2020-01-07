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
}

class Playlist {
  List<Song> _songs;
  HashSet<int> _excludedIds = HashSet<int>();
  int _index = 0;

  Playlist(this._songs);
  Playlist.index(this._songs, this._index);
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
    if (found) {
      return _songs[nextIndex];
    } else {
      return null;
    }
  }

  set index(int index) => _index = index;

  //advances the playlist to the next song in the playlist
  void next() {
    print('from play list class (before): ${_index}');
    if (_index == _songs.length - 1) {
      print('playlist ended');
      //TODO figure out what to do when the playlist ends
    }
    bool found = false;
    for (int i = _index + 1; i < _songs.length; i++) {
      if (!_excludedIds.contains(_songs[i].id)) {
        found = true;
        index = i;
        break;
      }
    }
    if (found) {
      print('from play list class (after): ${_index}');
      return;
    } else {
      print('playlist ended');
      //TODO figure out what to do when the playlist ends
    }
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

  void shuffle() {
    List<Song> newList = [];
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

  //add the song to the hashset of songs that the user wants to exclude from
  //their playlist
  void exclude(Song s) {
    _excludedIds.add(s.id);
  }
}
