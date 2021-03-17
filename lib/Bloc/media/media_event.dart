part of 'media_bloc.dart';

@immutable
abstract class MediaEvent {}

class MediaStoppedEvent extends MediaEvent {}

class MediaStartEvent extends MediaEvent {
  final Playlist playlist;
  final Song startSong;
  MediaStartEvent(this.playlist, this.startSong);
}
