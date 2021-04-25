import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

enum PlayerState { stopped, playing, paused }

class AudioManager extends BackgroundAudioTask {
  AudioPlayer _player = AudioPlayer();
  Completer _completer = Completer();
  static BehaviorSubject<PlayerState> _state = BehaviorSubject<PlayerState>();
  static PlayerState get state => _state.value ?? PlayerState.stopped;
  static ValueStream<PlayerState> get playbackStateStream => _state.stream;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    onPrepareFromMediaId(params['path']);
    await _completer.future;
  }

  @override
  Future<void> onPrepareFromMediaId(String path) {
    _player.setFilePath(path);
    onPlay();
  }

  @override
  Future<void> onPlay() {
    //for notifications to show up
    // AudioServiceBackground.setState(playing: true);
    _state.add(PlayerState.playing);
    print('INFO--------------------------------------------------------------');
    print(_state.value);
    print(state);
    _player.play();
  }

  @override
  Future<void> onPause() {
    _state.add(PlayerState.paused);
    _player.pause();
  }

  @override
  Future<void> onStop() {
    _state.add(PlayerState.stopped);
    _completer.complete();
    return super.onStop();
  }
}
