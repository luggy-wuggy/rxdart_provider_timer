import 'package:audioplayers/audioplayers.dart';

class AudioTimer {
  AudioPlayer player = AudioPlayer();

  AudioTimer() {
    player.audioCache.prefix = 'assets/audio/';
    player.audioCache.loadAll([
      'start_timer_sx.mp3',
      'warning_sx.mp3',
      'start_round_sx.wav',
      'end_round_sx.wav',
    ]);
  }

  playWarning() async {
    player.play(AssetSource('warning_sx.mp3'));
  }

  playStartTimer() async {
    player.play(AssetSource('start_timer_sx.mp3'));
  }

  playRoundStart() async {
    player.play(AssetSource('start_round_sx.wav'));
  }

  playRoundEnd() async {
    player.play(AssetSource('end_round_sx.wav'));
  }
}
