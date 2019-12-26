import 'package:flutter/material.dart';

class SPViewSwitcher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SPViewSwitcherState();
  }
}

class _SPViewSwitcherState extends State<SPViewSwitcher> {
  Color _songsColor = Colors.blue;
  Color _plColor = Colors.transparent;
  Color _selected = Colors.blue;
  Color _unselected = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0), //temporary
      child: Row(
        children: <Widget>[
          Container(
            child: Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: _songsColor, width: 3.0),
                  ),
                ),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    'Songs',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    setState(() {
                      _songsColor = _selected;
                      _plColor = _unselected;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: _plColor, width: 3.0))),
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  'Play Lists',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  setState(() {
                    _plColor = _selected;
                    _songsColor = _unselected;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
