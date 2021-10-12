import 'dart:async';
import 'package:rxdart/rxdart.dart';

class TimerBloc {
  final Stopwatch _timer = Stopwatch();

  late BehaviorSubject<String> _subjectTimeDisplay;
  late BehaviorSubject<String> _subjectRoundTimeDisplay;
  late BehaviorSubject<String> _subjectBreakTimeDisplay;
  late BehaviorSubject<String> _subjectTotalTimeDisplay;
  late BehaviorSubject<String> _subjectSetsSettingDisplay;
  late BehaviorSubject<String> _subjectSetsTimerDisplay;

  late BehaviorSubject<bool> _subjectTimerIsPlaying;
  late BehaviorSubject<bool> _subjectTimerIsRound;

  String initialTimeDisplay = "0:07";
  String initialRoundTimeDisplay = "0:07";
  String initialBreakTimeDisplay = "0:04";
  String initialSetsSettingDisplay = "3";
  String initialTotalTimeDisplay = "0:30";
  String initialSetsTimerDisplay = "1";

  int roundCounter = 1;

  TimerBloc() {
    _subjectTimeDisplay = BehaviorSubject<String>.seeded(initialTimeDisplay);
    _subjectRoundTimeDisplay =
        BehaviorSubject<String>.seeded(initialRoundTimeDisplay);
    _subjectBreakTimeDisplay =
        BehaviorSubject<String>.seeded(initialBreakTimeDisplay);
    _subjectTotalTimeDisplay =
        BehaviorSubject<String>.seeded(initialTotalTimeDisplay);
    _subjectSetsSettingDisplay =
        BehaviorSubject<String>.seeded(initialSetsSettingDisplay);
    _subjectSetsTimerDisplay =
        BehaviorSubject<String>.seeded(initialSetsTimerDisplay);
    _subjectTimerIsPlaying = BehaviorSubject<bool>.seeded(false);
    _subjectTimerIsRound = BehaviorSubject<bool>.seeded(false);
  }

  Stream<String> get timeObservable => _subjectTimeDisplay.stream;
  Stream<String> get roundTimeObservable => _subjectRoundTimeDisplay.stream;
  Stream<String> get breakTimeObservable => _subjectBreakTimeDisplay.stream;
  Stream<String> get totalTimeObservable => _subjectTotalTimeDisplay.stream;
  Stream<String> get setSettingObservable => _subjectSetsSettingDisplay.stream;
  Stream<String> get setsTimerObservable => _subjectSetsTimerDisplay.stream;
  Stream<bool> get isPlayingObservable => _subjectTimerIsPlaying.stream;
  Stream<bool> get isTimerRoundObservable => _subjectTimerIsRound.stream;

  void startTimer() {
    _subjectTimerIsPlaying.value = true;
    _subjectTimerIsRound.sink.add(true);
    _timer.start();
    _startTimer();
  }

  void pauseTimer() {
    _subjectTimerIsPlaying.value = false;
    _timer.stop();
  }

  void setSet(String s) {
    _subjectSetsSettingDisplay.value = s;
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

  void _startTimer() {
    Timer(const Duration(seconds: 1), _keepRunning);
  }

  void _keepRunning() async {
    await _elapseTime();

    if (_timer.isRunning) {
      _startTimer();
    }
  }

  Future<void> _toggleRoundBreak() async {
    /// Round to Break
    if (_subjectTimerIsRound.value) {
      if (_subjectTimeDisplay.value == '0:00') {
        _subjectTimerIsRound.sink.add(!_subjectTimerIsRound.value);
        _subjectTimeDisplay.sink.add(_subjectBreakTimeDisplay.value);
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    /// Break to Round
    else {
      if (_subjectTimeDisplay.value == '0:00') {
        _subjectSetsTimerDisplay.sink
            .add((int.parse(_subjectSetsTimerDisplay.value) + 1).toString());
        _subjectTimerIsRound.sink.add(!_subjectTimerIsRound.value);
        _subjectTimeDisplay.sink.add(_subjectRoundTimeDisplay.value);
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  Future<void> _elapseTime() async {
    await _toggleRoundBreak();

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

  void _updateTotalTime() {
    int set = int.parse(_subjectSetsSettingDisplay.value);
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
    _subjectSetsSettingDisplay.close();
  }
}
