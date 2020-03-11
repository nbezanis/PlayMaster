import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_utils.dart';
import 'music_utils.dart';

class PlaylistListDisplay extends StatefulWidget {
  final Playlist pl;

  PlaylistListDisplay(this.pl);

  @override
  _PlaylistListDisplayState createState() => _PlaylistListDisplayState();
}

class _PlaylistListDisplayState extends State<PlaylistListDisplay> {
  @override
  Widget build(BuildContext context) {
    var selectInfo = Provider.of<SelectInfo>(context);
    return GestureDetector(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
            color: Colors.white,
          ),
          child: _getTitle(selectInfo),
        ),
      ),
    );
  }

  Row _getTitle(SelectInfo selectInfo) {
    List<Widget> titleElements = [
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
        child: Icon(Icons.dehaze),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.pl.name,
            style: TextStyle(fontSize: 20.0),
          ),
          Text('${widget.pl.length} songs'),
        ],
      ),
    ];

    return selectInfo.selecting
        ? Row(
            children: titleElements,
          )

//    Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        Row(
//          children: titleElements,
//        ),
//        GestureDetector(
//          onTap: () {
//            _select(selectInfo);
//          },
//          child: Icon(
//            _selected ? Icons.check_box : Icons.check_box_outline_blank,
//            color: _selected ? PlayMaster.accentColor : Colors.black54,
//          ),
//        ),
//      ],
//    )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: titleElements,
              ),
              GestureDetector(
                child: Icon(
                  Icons.play_arrow,
                  size: 30.0,
                ),
              )
            ],
          );
  }
}
