import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:play_master/utils/playlist.dart';
import 'package:play_master/utils/song.dart';

part 'media_event.dart';

part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  MediaBloc(MediaState initialState) : super(initialState);

  MediaState get initialState => MediaStoppedState();

  @override
  Stream<MediaState> mapEventToState(MediaEvent event) async* {
    if (event is MediaStartEvent) {
      event.playlist.startFrom(event.startSong);
      yield MediaStartedState(event.playlist);
    }
  }
}
