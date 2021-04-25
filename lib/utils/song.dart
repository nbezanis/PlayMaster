import 'dart:convert';
import 'dart:io';

import 'package:play_master/utils/selectable.dart';

class Song extends Selectable {
  String path;
  late String name;
  int id;
  late Duration duration;
  // File _file;

  Song(this.path, this.id) {
    name = path.substring(path.lastIndexOf('/') + 1, path.indexOf('.mp3'));
    // _file = File(path);
  }

  String toJson() {
    return jsonEncode({
      'path': path,
      'id': id,
    });
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(json['path'], json['id']);
  }

  //compare function used to make songs compatible with splay tree
  static int compare(Song key1, Song key2) {
    return key1.name.compareTo(key2.name);
  }

  @override
  void delete() {}
}
