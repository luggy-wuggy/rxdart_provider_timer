import 'dart:async';
import 'package:rxdart/rxdart.dart';

class TimerBloc {
  final Stopwatch _timer = Stopwatch();

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

  void startTimer() {
    _subjectTimerIsPlaying.value = true;
    _timer.start();
    _startTimer();
  }

  void pauseTimer() {
    _subjectTimerIsPlaying.value = false;
    _timer.stop();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 1), _keepRunning);
  }

  void _keepRunning() {
    if (_timer.isRunning) {
      _startTimer();
    }

    _elapseTime();
  }

  void _elapseTime() {
    Duration displayTime = Duration(
            minutes: int.parse(_subjectTimeDisplay.value.split(":")[0]),
            seconds: int.parse(_subjectTimeDisplay.value.split(":")[1])) -
        const Duration(seconds: 1);

    Duration displayTotalTime = Duration(
            minutes: int.parse(_subjectTotalTimeDisplay.value.split(":")[0]),
            seconds: int.parse(_subjectTotalTimeDisplay.value.split(":")[1])) -
        const Duration(seconds: 1);

    final String stringDisplayTime =
        "${(displayTime.inMinutes % 60).toString()}:${(displayTime.inSeconds % 60).toString().padLeft(2, '0')}";

    final String stringTotalTime =
        "${(displayTotalTime.inMinutes % 60).toString()}:${(displayTotalTime.inSeconds % 60).toString().padLeft(2, '0')}";

    _subjectTimeDisplay.sink.add(stringDisplayTime);
    _subjectTotalTimeDisplay.sink.add(stringTotalTime);
  }

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

    _subjectTotalTimeDisplay.sink.add(stringTotalTime);
  }

  void dispose() {
    _subjectTimeDisplay.close();
    _subjectRoundTimeDisplay.close();
    _subjectBreakTimeDisplay.close();
    _subjectTotalTimeDisplay.close();
    _subjectSetsDisplay.close();
  }
}
