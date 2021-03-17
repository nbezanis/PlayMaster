import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:play_master/utils/selectable.dart';
import 'package:play_master/utils/song.dart';

class Playlist extends Selectable {
  String name;
  int id;
  SplayTreeSet<Song> songs;
  List<Song> activeSongs;
  HashSet<int> excludedIds;
  Song _songPlaying;

  Playlist(this.name, this.id, this.songs);

  void startFrom(Song s) {
    if (!songs.contains(s)) {
      print('song ${s.name} not in playlist $name');
      return;
    }
    //prepare the playlist to play
    activeSongs.add(s);
    _songPlaying = s;
    //in order
    songs.forEach((song) {
      if (song != s) activeSongs.add(song);
    });
  }

  void unshuffle() => activeSongs = songs.toList();

  void shuffle() {
    HashSet<Song> songsToAdd = HashSet<Song>();
    songsToAdd.addAll(activeSongs);
    songsToAdd.remove(_songPlaying);
    activeSongs.clear();
    //make sure the current playing song is first in the new list
    activeSongs.add(_songPlaying);
    Random r = Random();
    int hashSetLength = songsToAdd.length;
    //randomly add songs to the new list until there are no songs left
    for (int i = 0; i < hashSetLength; i++) {
      int index = r.nextInt(songsToAdd.length);
      Song s = songsToAdd.elementAt(index);
      activeSongs.add(s);
      songsToAdd.remove(s);
    }
  }

  String toJson() {
    return jsonEncode({
      'name': name,
      'id': id,
      'songs': songs.toList(),
    });
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(json['name'], json['id'], json['songs']);
  }

  @override
  void delete() {}
}
