import 'package:audioplayers/audioplayers.dart';

class AudioTimer {
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  AudioTimer() {
    player.loadAll([
      'start_timer_sx.mp3',
      'start_round_sx.wav',
      'end_round_sx.wav',
    ]);
  }

  playStartTimer() async {
    player.play('start_timer_sx.mp3');
  }

  playRoundStart() async {
    player.play('start_round_sx.wav');
  }

  playRoundEnd() async {
    player.play('end_round_sx.wav');
  }
}
