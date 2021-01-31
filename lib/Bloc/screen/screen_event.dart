part of 'screen_bloc.dart';

@immutable
abstract class ScreenEvent {}

class HomeScreenEvent extends ScreenEvent {}

class ThemeScreenEvent extends ScreenEvent {}

class PlaylistDetailScreenEvent extends ScreenEvent {}
