import 'dart:async';
import 'package:clean_ui_timer_rx/model/audio_timer.dart';
import 'package:clean_ui_timer_rx/bloc/preference_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerBloc {
  final Stopwatch _timer = Stopwatch();
  final AudioTimer _audioTimer = AudioTimer();

  late BehaviorSubject<String> _subjectTimeDisplay;
  late BehaviorSubject<String> _subjectRoundTimeDisplay;
  late BehaviorSubject<String> _subjectBreakTimeDisplay;
  late BehaviorSubject<String> _subjectTotalTimeDisplay;
  late BehaviorSubject<String> _subjectSetsSettingDisplay;
  late BehaviorSubject<String> _subjectSetsTimerDisplay;
  late BehaviorSubject<String> _subjectRoundWarningDisplay;
  late BehaviorSubject<String> _subjectBreakWarningDisplay;

  late BehaviorSubject<bool> _subjectTimerIsPlaying;
  late BehaviorSubject<bool> _subjectTimerIsRound;
  late BehaviorSubject<bool> _subjectTimerStarted;

  String initialTimeDisplay = "3:00";
  String initialRoundTimeDisplay = "3:00";
  String initialBreakTimeDisplay = "1:00";
  String initialSetsSettingDisplay = "12";
  String initialTotalTimeDisplay = "48:00";
  String initialSetsTimerDisplay = "1";
  String initialRoundWarningDisplay = '0:10';
  String initialBreakWarningDisplay = '0:10';

  TimerBloc() {
    _subjectTimeDisplay = BehaviorSubject<String>.seeded(initialTimeDisplay);

    _subjectRoundTimeDisplay = BehaviorSubject<String>.seeded(initialRoundTimeDisplay);

    _subjectBreakTimeDisplay = BehaviorSubject<String>.seeded(initialBreakTimeDisplay);

    _subjectTotalTimeDisplay = BehaviorSubject<String>.seeded(initialTotalTimeDisplay);

    _subjectSetsSettingDisplay = BehaviorSubject<String>.seeded(initialSetsSettingDisplay);

    _subjectRoundWarningDisplay = BehaviorSubject<String>.seeded(initialRoundWarningDisplay);

    _subjectBreakWarningDisplay = BehaviorSubject<String>.seeded(initialBreakWarningDisplay);

    _subjectSetsTimerDisplay = BehaviorSubject<String>.seeded(initialSetsTimerDisplay);

    _subjectTimerIsPlaying = BehaviorSubject<bool>.seeded(false);
    _subjectTimerIsRound = BehaviorSubject<bool>.seeded(false);
    _subjectTimerStarted = BehaviorSubject<bool>.seeded(false);
  }

  Stream<String> get timeObservable => _subjectTimeDisplay.stream;
  Stream<String> get roundTimeObservable => _subjectRoundTimeDisplay.stream;
  Stream<String> get breakTimeObservable => _subjectBreakTimeDisplay.stream;
  Stream<String> get totalTimeObservable => _subjectTotalTimeDisplay.stream;
  Stream<String> get setSettingObservable => _subjectSetsSettingDisplay.stream;
  Stream<String> get setsTimerObservable => _subjectSetsTimerDisplay.stream;
  Stream<String> get roundWarningObservable => _subjectRoundWarningDisplay.stream;
  Stream<String> get breakWarningObservable => _subjectBreakWarningDisplay.stream;

  Stream<bool> get isPlayingObservable => _subjectTimerIsPlaying.stream;
  Stream<bool> get isTimerRoundObservable => _subjectTimerIsRound.stream;
  Stream<bool> get isTimerStartedObservable => _subjectTimerStarted.stream;

  void _initilizeSharedPreferences() async {
    final pref = await SharedPreferences.getInstance();
  }

  void startTimer() {
    _audioTimer.playStartTimer();
    _subjectTimerIsPlaying.value = true;
    _subjectTimerIsRound.sink.add(true);
    _subjectTimerStarted.value = true;
    _timer.start();
    _startTimer();
  }

  void resumeTimer() {
    _audioTimer.playStartTimer();
    _subjectTimerIsPlaying.value = true;
    _timer.start();
    _startTimer();
  }

  Future<void> stopTimer() async {
    _timer.stop();
    _timer.reset();
    _subjectTimerIsPlaying.value = false;
    _subjectTimerStarted.value = false;

    Future.delayed(const Duration(milliseconds: 1000), () {
      _subjectTimeDisplay.sink.add(_subjectRoundTimeDisplay.value);
      _subjectSetsTimerDisplay.sink.add("1");
      _updateTotalTime();
    });
  }

  void pauseTimer() {
    _subjectTimerIsPlaying.value = false;
    _timer.stop();
    _timer.reset();
  }

  Future<void> rewindTimer() async {
    await _updateTotalTimeByRewind();

    if (_subjectTimerIsRound.value) {
      _subjectTimeDisplay.sink.add(_subjectRoundTimeDisplay.value);
    } else if (!_subjectTimerIsRound.value && _subjectSetsTimerDisplay.value != "1") {
      _subjectTimeDisplay.sink.add(_subjectBreakTimeDisplay.value);
    }
  }

  void setRoundWarning(String s) {
    _subjectRoundWarningDisplay.value = s;
  }

  void setBreakWarning(String s) {
    _subjectBreakWarningDisplay.value = s;
  }

  void setSet(String s) async {
    _subjectSetsSettingDisplay.value = s;
    _updateTotalTime();
  }

  void setRoundTime(String s) async {
    _subjectRoundTimeDisplay.value = s;
    _subjectTimeDisplay.value = s;

    _updateTotalTime();
  }

  void setBreakTime(String s) async {
    _subjectBreakTimeDisplay.value = s;

    _updateTotalTime();
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
        _audioTimer.playRoundEnd();
        _subjectTimerIsRound.sink.add(!_subjectTimerIsRound.value);
        _subjectTimeDisplay.sink.add(_subjectBreakTimeDisplay.value);
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    /// Break to Round
    else {
      if (_subjectTimeDisplay.value == '0:00') {
        _audioTimer.playRoundStart();
        _subjectSetsTimerDisplay.sink.add((int.parse(_subjectSetsTimerDisplay.value) + 1).toString());
        _subjectTimerIsRound.sink.add(!_subjectTimerIsRound.value);
        _subjectTimeDisplay.sink.add(_subjectRoundTimeDisplay.value);
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  Future<void> _elapseTime() async {
    await _toggleRoundBreak();

    if (_subjectTimeDisplay.value == _subjectRoundWarningDisplay.value && _subjectTimerIsRound.value) {
      _audioTimer.playWarning();
    } else if (_subjectTimeDisplay.value == _subjectBreakWarningDisplay.value && !_subjectTimerIsRound.value) {
      _audioTimer.playWarning();
    }

    Duration displayTime = Duration(minutes: int.parse(_subjectTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectTimeDisplay.value.split(":")[1])) - const Duration(seconds: 1);

    Duration displayTotalTime =
        Duration(minutes: int.parse(_subjectTotalTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectTotalTimeDisplay.value.split(":")[1])) - const Duration(seconds: 1);

    final String stringDisplayTime = "${(displayTime.inMinutes % 60).toString()}:${(displayTime.inSeconds % 60).toString().padLeft(2, '0')}";

    final String stringTotalTime = "${(displayTotalTime.inMinutes % 60).toString()}:${(displayTotalTime.inSeconds % 60).toString().padLeft(2, '0')}";

    _subjectTimeDisplay.sink.add(stringDisplayTime);
    _subjectTotalTimeDisplay.sink.add(stringTotalTime);
  }

  Future<void> _updateTotalTimeByRewind() async {
    Duration totalTime = Duration(minutes: int.parse(_subjectTotalTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectTotalTimeDisplay.value.split(":")[1]));

    Duration elapsedTime;

    if (_subjectTimerIsRound.value) {
      elapsedTime = Duration(minutes: int.parse(_subjectRoundTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectRoundTimeDisplay.value.split(":")[1])) -
          Duration(minutes: int.parse(_subjectTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectTimeDisplay.value.split(":")[1]));
    } else {
      elapsedTime = Duration(minutes: int.parse(_subjectBreakTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectBreakTimeDisplay.value.split(":")[1])) -
          Duration(minutes: int.parse(_subjectTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectTimeDisplay.value.split(":")[1]));
    }

    totalTime = totalTime + elapsedTime;

    String stringTotalTime;

    if (totalTime < const Duration(hours: 1)) {
      stringTotalTime = "${(totalTime.inMinutes % 60).toString()}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}";
    } else {
      stringTotalTime = "${(totalTime.inHours % 60).toString()}:${(totalTime.inMinutes % 60).toString().padLeft(2, '0')}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}";
    }

    _subjectTotalTimeDisplay.sink.add(stringTotalTime);
  }

  void _updateTotalTime() {
    int set = int.parse(_subjectSetsSettingDisplay.value);
    Duration roundTime = Duration(minutes: int.parse(_subjectRoundTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectRoundTimeDisplay.value.split(":")[1]));

    Duration breakTime = Duration(minutes: int.parse(_subjectBreakTimeDisplay.value.split(":")[0]), seconds: int.parse(_subjectBreakTimeDisplay.value.split(":")[1]));

    Duration totalTime = (roundTime + breakTime) * set;
    String stringTotalTime;

    if (totalTime < const Duration(hours: 1)) {
      stringTotalTime = "${(totalTime.inMinutes % 60).toString()}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}";
    } else {
      stringTotalTime = "${(totalTime.inHours % 60).toString()}:${(totalTime.inMinutes % 60).toString().padLeft(2, '0')}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}";
    }

    _subjectTotalTimeDisplay.sink.add(stringTotalTime);
  }

  void dispose() {
    _subjectTimeDisplay.close();
    _subjectRoundTimeDisplay.close();
    _subjectBreakTimeDisplay.close();
    _subjectTotalTimeDisplay.close();
    _subjectSetsSettingDisplay.close();
    _subjectSetsTimerDisplay.close();
    _subjectRoundWarningDisplay.close();
    _subjectBreakWarningDisplay.close();
  }
}
