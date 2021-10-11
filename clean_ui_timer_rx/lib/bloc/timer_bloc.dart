import 'dart:async';
import 'package:rxdart/rxdart.dart';

class TimerBloc {
  late BehaviorSubject<String> _subjectTimeDisplay;
  late BehaviorSubject<String> _subjectRoundTimeDisplay;
  late BehaviorSubject<String> _subjectBreakTimeDisplay;
  late BehaviorSubject<String> _subjectTotalTimeDisplay;
  late BehaviorSubject<String> _subjectSetsDisplay;

  late BehaviorSubject<bool> _subjectTimerIsPlaying;

  String initialTimeDisplay = "3:00";
  String initialRoundTimeDisplay = "3:00";
  String initialBreakTimeDisplay = "1:00";
  String initialSetsDisplay = "12";
  String initialTotalTimeDisplay = "48:00";

  TimerBloc() {
    _subjectTimeDisplay = BehaviorSubject<String>.seeded(initialTimeDisplay);
    _subjectRoundTimeDisplay =
        BehaviorSubject<String>.seeded(initialRoundTimeDisplay);
    _subjectBreakTimeDisplay =
        BehaviorSubject<String>.seeded(initialBreakTimeDisplay);
    _subjectTotalTimeDisplay =
        BehaviorSubject<String>.seeded(initialTotalTimeDisplay);
    _subjectSetsDisplay = BehaviorSubject<String>.seeded(initialSetsDisplay);
    _subjectTimerIsPlaying = BehaviorSubject<bool>.seeded(false);
  }

  Stream<String> get timeObservable => _subjectTimeDisplay.stream;
  Stream<String> get roundTimeObservable => _subjectRoundTimeDisplay.stream;
  Stream<String> get breakTimeObservable => _subjectBreakTimeDisplay.stream;
  Stream<String> get totalTimeObservable => _subjectTotalTimeDisplay.stream;
  Stream<String> get setObservable => _subjectSetsDisplay.stream;
  Stream<bool> get isPlayingObservable => _subjectTimerIsPlaying.stream;

  void setSet(String s) {
    _subjectSetsDisplay.value = s;
    _updateTotalTime();
  }

  void setRoundTime(String s) {
    _subjectRoundTimeDisplay.value = s;
    _subjectTimeDisplay.value = s;
    _updateTotalTime();
  }

  void setBreakTime(String s) {
    _subjectBreakTimeDisplay.value = s;
    _updateTotalTime();
  }

  void toggleIsPlaying() {
    _subjectTimerIsPlaying.value = !(_subjectTimerIsPlaying.value);
  }

  void _updateTotalTime() {
    int set = int.parse(_subjectSetsDisplay.value);
    Duration roundTime = Duration(
        minutes: int.parse(_subjectRoundTimeDisplay.value.split(":")[0]),
        seconds: int.parse(_subjectRoundTimeDisplay.value.split(":")[1]));

    Duration breakTime = Duration(
        minutes: int.parse(_subjectBreakTimeDisplay.value.split(":")[0]),
        seconds: int.parse(_subjectBreakTimeDisplay.value.split(":")[1]));

    Duration totalTime = (roundTime + breakTime) * set;
    String stringTotalTime;

    if (totalTime < const Duration(hours: 1)) {
      stringTotalTime =
          "${(totalTime.inMinutes % 60).toString()}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}";
    } else {
      stringTotalTime =
          "${(totalTime.inHours % 60).toString()}:${(totalTime.inMinutes % 60).toString().padLeft(2, '0')}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}";
    }

    _subjectTotalTimeDisplay.value = stringTotalTime;
  }

  void dispose() {
    _subjectTimeDisplay.close();
    _subjectRoundTimeDisplay.close();
    _subjectBreakTimeDisplay.close();
    _subjectTotalTimeDisplay.close();
    _subjectSetsDisplay.close();
  }
}
