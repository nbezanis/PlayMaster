import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'screen_event.dart';

part 'screen_state.dart';

class ScreenBloc extends Bloc<ScreenEvent, ScreenState> {
  ScreenBloc(ScreenState initialState) : super(initialState);

  ScreenState get initialState => HomeScreenState();

  @override
  Stream<ScreenState> mapEventToState(ScreenEvent event) async* {
    if (event is HomeScreenEvent) {
      yield HomeScreenState();
    } else if (event is ThemeScreenEvent) {
      yield ThemeScreenState();
    } else if (event is PlaylistDetailScreenEvent) {
      yield PlaylistDetailScreenState();
    }
  }
}
