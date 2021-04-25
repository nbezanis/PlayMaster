import 'dart:convert';
import 'dart:io';

import 'package:mp3_info/mp3_info.dart';
import 'package:play_master/utils/selectable.dart';

class Song extends Selectable {
  String path;
  late String name;
  int id;
  late Duration duration;
  // File _file;

  Song(this.path, this.id) {
    name = path.substring(path.lastIndexOf('/') + 1, path.indexOf('.mp3'));
    duration = MP3Processor.fromFile(File(path)).duration;
  }

  Song._(this.path, this.id, this.name, int durationMillis) {
    duration = Duration(milliseconds: durationMillis);
  }

  String toJson() {
    return jsonEncode({
      'path': path,
      'id': id,
      'name': name,
      'duration': duration.inMilliseconds,
    });
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song._(json['path'], json['id'], json['name'], json['duration']);
  }

  //compare function used to make songs compatible with splay tree
  static int compare(Song key1, Song key2) {
    return key1.name.compareTo(key2.name);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Song && id == other.id;
  }

  @override
  void delete() {}
}
