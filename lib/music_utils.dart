class Song {
  String _path;
  int _id;
  Song(this._path, this._id);

  String get path => _path;
  int get id => _id;
  String get name => getSongName(_path);

  //isolates a song's name given the path to the mp3 file
  String getSongName(String path) {
    String name;
    name = path.substring(path.lastIndexOf('/') + 1, path.indexOf('.mp3'));
    return name;
  }
}
