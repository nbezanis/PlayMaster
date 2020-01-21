import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

//class used to keep track of what color is currently selected
class ColorInfo extends ChangeNotifier {
  Color _color = PlayMaster.accentColor;

  Color get color => _color;

  set color(Color c) {
    _color = c;
    PlayMaster.accentColor = c;
    PlayMaster.getSupportingColors();
    notifyListeners();
  }
}

//class used to house the grid display of each color that the user can select
class ThemeChanger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ColorInfo(),
      child: Scaffold(
        backgroundColor: PlayMaster.accentColor,
        appBar: AppBar(
          title: Text('Select a Color'),
        ),
        body: Container(
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              ColorObject('blue'),
              ColorObject('red'),
              ColorObject('green'),
              ColorObject('orange'),
              ColorObject('purple'),
              ColorObject('pink'),
              ColorObject('yellow'),
              ColorObject('teal'),
            ],
          ),
        ),
      ),
    );
  }
}

//class containing each color option
class ColorObject extends StatefulWidget {
  final String name;

  ColorObject(this.name);

  @override
  State<StatefulWidget> createState() {
    return _ColorObjectState();
  }
}

class _ColorObjectState extends State<ColorObject> {
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ColorInfo>(context);
    Color color = PlayMaster.colorMap[widget.name];
    return GestureDetector(
      onTap: () {
        PlayMaster.putStrInPrefs('color', widget.name);
        info.color = color;
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: info.color == color ? _getBorder() : null,
        ),
        margin: EdgeInsets.all(16.0),
      ),
    );
  }

  Border _getBorder() => Border.all(color: Colors.black, width: 3.0);
}
