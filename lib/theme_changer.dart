// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'main.dart';
// import 'app_utils.dart';
//
// //class used to house the provider so that the color of the appbar can be updated
// //when the user clicks on a color
// class ThemeChanger extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => ColorInfo(),
//       child: ColorObjectHolder(),
//     );
//   }
// }
//
// //class used to house the grid display of each color that the user can select
// class ColorObjectHolder extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ColorObjectHolderState();
//   }
// }
//
// class _ColorObjectHolderState extends State<ColorObjectHolder> {
//   List<ColorObject> _getColors() {
//     List<ColorObject> colors = [];
//     PlayMaster.colorMap.forEach((name, color) {
//       colors.add(ColorObject(name));
//     });
//     return colors;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var info = Provider.of<ColorInfo>(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: info.color,
//         title: Text('Select a Color'),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: GridView.count(
//           crossAxisCount: 2,
//           children: _getColors(),
//         ),
//       ),
//     );
//   }
// }
//
// //class containing each color option
// class ColorObject extends StatefulWidget {
//   final String name;
//
//   ColorObject(this.name);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _ColorObjectState();
//   }
// }
//
// class _ColorObjectState extends State<ColorObject> {
//   @override
//   Widget build(BuildContext context) {
//     var info = Provider.of<ColorInfo>(context);
//     Color color = PlayMaster.colorMap[widget.name];
//     return GestureDetector(
//       onTap: () {
//         //change color to selected color
//         PlayMaster.putStrInPrefs('color', widget.name);
//         info.color = color;
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: color,
//           border: info.color == color ? _getBorder() : null,
//         ),
//         margin: EdgeInsets.all(16.0),
//       ),
//     );
//   }
//
//   Border _getBorder() => Border.all(color: Colors.black, width: 3.0);
// }
