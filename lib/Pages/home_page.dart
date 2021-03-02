import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:play_master/Bloc/media/media_bloc.dart';
import 'package:play_master/Bloc/screen/screen_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BlocListener _screenBlocListener;

  BlocListener _mediaBlocListener;

  void _listenForScreenEvents(BuildContext context, ScreenState state) {
    if (state is HomeScreenState) {
      setState(() {
        // _currentPage = HomePage();
      });
    }
  }

  void _listenForMediaEvents(BuildContext context, MediaState state) {}

  @override
  void initState() {
    super.initState();

    _screenBlocListener =
        BlocListener<ScreenBloc, ScreenState>(listener: _listenForScreenEvents);

    _mediaBlocListener =
        BlocListener<MediaBloc, MediaState>(listener: _listenForMediaEvents);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
