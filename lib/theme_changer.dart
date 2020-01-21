import 'package:flutter/material.dart';

import 'main.dart';

class ThemeChanger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlayMaster.accentColor,
      appBar: AppBar(
        title: Text('Select a Color'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            color: Colors.red,
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            color: Colors.red,
          )
        ],
      ),
    );
  }
}

class ColorObject extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ColorObjectState();
  }
}

class _ColorObjectState extends State<ColorObject> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {}, child: Container());
  }
}
