import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager extends BackgroundAudioTask {
  AudioPlayer _player = AudioPlayer();
  Completer _completer = Completer();

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    print('onStart');
    onPrepareFromMediaId(params['path']);
    await _completer.future;
  }

  @override
  Future<void> onPrepareFromMediaId(String path) {
    print('preparing $path');
    _player.setFilePath(path);
    onPlay();
  }

  @override
  Future<void> onPlay() {
    print('playing');
    _player.play();
  }

  @override
  Future<void> onStop() {
    _completer.complete();
    return super.onStop();
  }
}
