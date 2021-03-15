import 'package:flutter/material.dart';
import 'package:play_master/widgets/widget_view_switcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentView;

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
      ),
      body: Container(
        child: Center(
          child: _currentView,
        ),
      ),
    );
  }
}
