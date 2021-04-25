part of 'media_bloc.dart';

@immutable
abstract class MediaState {}

class MediaStoppedState extends MediaState {}

class MediaStartedState extends MediaState {
  final Playlist playlist;
  MediaStartedState(this.playlist);
}
