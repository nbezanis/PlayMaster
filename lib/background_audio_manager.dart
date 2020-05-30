import 'package:audio_service/audio_service.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'app_utils.dart';
import 'main.dart';
import 'music_utils.dart';

class BackgroundAudioManager extends BackgroundAudioTask {
  final Completer _completer = Completer();
//  final MusicInfo info;
  final Song song;

  BackgroundAudioManager(this.song) {
    print('constructor');
  }

  @override
  Future<void> onStart() async {
    AudioServiceBackground.setState(
        controls: [PlayMaster.pauseControl, PlayMaster.stopControl],
        basicState: BasicPlaybackState.playing);

    await PlayMaster.player.setUrl(song.path, isLocal: true);
    print('set url');
    await _completer.future;

    AudioServiceBackground.setState(
        controls: [], basicState: BasicPlaybackState.playing);
  }

//  @override
//  void onSkipToNext() {
//    super.onSkipToNext();
//    info.pl.next();
//    info.setSong(info.pl.song);
//  }
//
//  @override
//  void onSkipToPrevious() {
//    super.onSkipToPrevious();
//    info.pl.prev();
//    info.setSong(info.pl.song);
//  }

//  @override
//  void onClick(MediaButton button) {
//    super.onClick(button);
//    if (button == MediaButton.next) {
//      info.pl.next();
//      info.setSong(info.pl.song);
//    } else if (button == MediaButton.previous) {
//      info.pl.prev();
//      info.setSong(info.pl.song);
//    }
//  }

  @override
  void onPlay() async {
    super.onPlay();
    AudioServiceBackground.setState(
        controls: [PlayMaster.pauseControl, PlayMaster.stopControl],
        basicState: BasicPlaybackState.playing);
    PlayMaster.player.resume();
    print('play');
  }

  @override
  void onPause() async {
    super.onPause();
    AudioServiceBackground.setState(
        controls: [PlayMaster.playControl, PlayMaster.stopControl],
        basicState: BasicPlaybackState.playing);
    await PlayMaster.player.pause();
  }

  @override
  void onStop() async {
    await PlayMaster.player.stop();
    print('stop');
    _completer.complete();
  }
}
