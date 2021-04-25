import 'dart:collection';
import 'dart:convert';

import 'package:play_master/utils/selectable.dart';
import 'package:play_master/utils/song.dart';

class Playlist extends Selectable {
  String name;
  int id;
  List<Song> songs;
  List<Song> activeSongs = [];
  HashSet<int> excludedIds = HashSet<int>();

  Playlist(this.name, this.id, this.songs);

  String toJson() {
    return jsonEncode({
      'name': name,
      'id': id,
      'songs': songs,
    });
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(json['name'], json['id'], json['songs']);
  }

  @override
  void delete() {}
}
