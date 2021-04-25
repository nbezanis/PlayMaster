import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:play_master/main.dart';
import 'package:play_master/utils/internal_database.dart';
import 'package:play_master/utils/song.dart';
import 'package:play_master/widgets/widget_view_switcher.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget _currentView;

  Future<List<PlatformFile>> pickFiles() async {
    List<File> files;
//    files = await FilePicker.getMultiFile(allowedExtensions: ['mp3']);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3']
    );
    return result?.files ?? [];
  }

  String _isolateSongName(String path) {
    String name;
    name = path.substring(path.lastIndexOf('/') + 1, path.indexOf('.mp3'));
    return name;
  }

  void _addSongs() async {
    print('before');
    List<PlatformFile> files = await pickFiles();
    print('after');

    if (files == null) {
      return;
    }

    var miscData = await InternalDatabase.getData('misc');
    int idTotal = miscData['idTotal'] ?? 0;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    for (PlatformFile platformFile in files) {
      File file = File(platformFile.path!);
      File songFile = await file
          .copy('${appDocDir.path}/${_isolateSongName(file.path)}.mp3');
      Song s = Song(songFile.absolute.path, idTotal);
      await InternalDatabase.mutateData(
          'songs', idTotal.toString(), jsonDecode(s.toJson()));
      idTotal++;
      PlayMaster.allSongs.add(s);
    }
    await InternalDatabase.mutateData('misc', 'idTotal', idTotal);
  }

  Widget _getSongs() {
    return Text('songs');
  }

  Widget _getPlaylists() {
    return Text('playlists');
  }

  _switchView(int id) {
    setState(() {
      switch (id) {
        case 0:
          _currentView = _getSongs();
          break;
        case 1:
          _currentView = _getPlaylists();
          InternalDatabase.getData('songs').then((obj) => print(obj));
          break;
        default:
          _currentView = _getSongs();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentView = _getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetViewSwitcher(
          title1: 'Songs',
          title2: 'Playlists',
          width: MediaQuery.of(context).size.width * 0.6,
          height: 56.0,
          fontSize: 25.0,
          onClicked: _switchView,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 40.0,
            ),
            onPressed: () {
              _addSongs();
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: _currentView,
        ),
      ),
    );
  }
}
