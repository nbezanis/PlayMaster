import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WidgetViewSwitcher extends StatefulWidget {
  final String title1;
  final String title2;
  final double width;
  final double height;
  final double fontSize;
  final Function(int) onClicked;

  WidgetViewSwitcher(
      {this.title1,
      this.title2,
      this.width,
      this.height,
      this.fontSize,
      this.onClicked});

  @override
  _WidgetViewSwitcherState createState() => _WidgetViewSwitcherState();
}

class _WidgetViewSwitcherState extends State<WidgetViewSwitcher> {
  int _selectedWidget = 0;
  double _barWidth;
  double _displayWidth;

  @override
  void initState() {
    super.initState();
    _displayWidth = widget.width * 0.5;
    _barWidth = _displayWidth * 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: widget.height, //height of appbar
                  width: widget.width / 2,
                  child: Center(
                    child: AutoSizeText(
                      widget.title1,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.fontSize,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedWidget = 0;
                  });
                  widget.onClicked(0);
                },
              ),
              GestureDetector(
                child: Container(
                  height: widget.height,
                  width: widget.width / 2,
                  child: Center(
                    child: AutoSizeText(
                      widget.title2,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.fontSize,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedWidget = 1;
                  });
                  widget.onClicked(1);
                },
              ),
            ],
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: _barWidth,
            height: 4.0,
            color: Colors.white,
            transform: Matrix4(
              1,
              0,
              0,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              1,
              0,
              //dictates which option to go under
              (_selectedWidget * _displayWidth) +
                  //add half of one display's width (half of widget width)
                  //subtracted by the bar's width to center the bar
                  0.5 * (_displayWidth - _barWidth),
              -4.0,
              0,
              1,
            ),
          ),
        ],
      ),
    );
  }
}
