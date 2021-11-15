import 'dart:async';
import 'package:clean_ui_timer_rx/model/audio_timer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerBloc {
  final Stopwatch _timer = Stopwatch();
  final AudioTimer _audioTimer = AudioTimer();
  String initialTimeDisplay = "3:00";
  String initialRoundTimeDisplay = "3:00";
  String initialBreakTimeDisplay = "1:00";
  String initialSetSettingDisplay = "12";
  String initialTotalTimeDisplay = "48:00";
  String initialRoundWarningDisplay = '0:10';
  String initialBreakWarningDisplay = '0:10';

  final _subjectTimeDisplay = BehaviorSubject<String>();
  final _subjectRoundTimeDisplay = BehaviorSubject<String>();
  final _subjectBreakTimeDisplay = BehaviorSubject<String>();
  final _subjectTotalTimeDisplay = BehaviorSubject<String>();
  final _subjectSetSettingDisplay = BehaviorSubject<String>();
  final _subjectRoundWarningDisplay = BehaviorSubject<String>();
  final _subjectBreakWarningDisplay = BehaviorSubject<String>();

  final _subjectSetTimerDisplay = BehaviorSubject<String>.seeded('1');
  final _subjectTimerIsPlaying = BehaviorSubject<bool>.seeded(false);
  final _subjectTimerIsRound = BehaviorSubject<bool>.seeded(false);
  final _subjectTimerStarted = BehaviorSubject<bool>.seeded(false);

  /// GETTERS
  Stream<String> get timeObservable => _subjectTimeDisplay.stream;
  Stream<String> get roundTimeObservable => _subjectRoundTimeDisplay.stream;
  Stream<String> get breakTimeObservable => _subjectBreakTimeDisplay.stream;
  Stream<String> get totalTimeObservable => _subjectTotalTimeDisplay.stream;
  Stream<String> get setSettingObservable => _subjectSetSettingDisplay.stream;
  Stream<String> get setTimerObservable => _subjectSetTimerDisplay.stream;
  Stream<String> get roundWarningObservable => _subjectRoundWarningDisplay.stream;
  Stream<String> get breakWarningObservable => _subjectBreakWarningDisplay.stream;
  Stream<bool> get isPlayingObservable => _subjectTimerIsPlaying.stream;
  Stream<bool> get isTimerRoundObservable => _subjectTimerIsRound.stream;
  Stream<bool> get isTimerStartedObservable => _subjectTimerStarted.stream;

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer = prefs.getString('timer');
    String? roundTime = prefs.getString('round_time');
    String? breakTime = prefs.getString('break_time');
    String? totalTime = prefs.getString('total_time');
    String? setSetting = prefs.getString('set_setting');
    String? roundWarning = prefs.getString('round_warning');
    String? breakWarning = prefs.getString('break_warning');

    timer != null ? _subjectTimeDisplay.sink.add(timer) : _subjectTimeDisplay.sink.add(initialTimeDisplay);
    roundTime != null ? _subjectRoundTimeDisplay.sink.add(roundTime) : _subjectRoundTimeDisplay.sink.add(initialRoundTimeDisplay);
    breakTime != null ? _subjectBreakTimeDisplay.sink.add(breakTime) : _subjectBreakTimeDisplay.sink.add(initialBreakTimeDisplay);
    totalTime != null ? _subjectTotalTimeDisplay.sink.add(totalTime) : _subjectTotalTimeDisplay.sink.add(initialTotalTimeDisplay);
    setSetting != null ? _subjectSetSettingDisplay.sink.add(setSetting) : _subjectSetSettingDisplay.sink.add(initialSetSettingDisplay);
    roundWarning != null ? _subjectRoundWarningDisplay.sink.add(roundWarning) : _subjectRoundWarningDisplay.sink.add(initialRoundWarningDisplay);
    breakWarning != null ? _subjectBreakWarningDisplay.sink.add(breakWarning) : _subjectBreakWarningDisplay.sink.add(initialBreakWarningDisplay);
  }

  void startTimer() {
    _audioTimer.playStartTimer();
    _subjectTimerIsPlaying.value = true;
    _subjectTimerIsRound.value = true;
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
      _subjectSetTimerDisplay.sink.add("1");
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
    } else if (!_subjectTimerIsRound.value && _subjectSetTimerDisplay.value != "1") {
      _subjectTimeDisplay.sink.add(_subjectBreakTimeDisplay.value);
    }
  }

  void setRoundWarning(String s) async {
    _subjectRoundWarningDisplay.value = s;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('round_warning', s);
  }

  void setBreakWarning(String s) async {
    _subjectBreakWarningDisplay.value = s;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('break_warning', s);
  }

  void setSet(String s) async {
    _subjectSetSettingDisplay.value = s;
    _updateTotalTime();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('set_setting', s);
  }

  void setRoundTime(String s) async {
    _subjectRoundTimeDisplay.value = s;
    _subjectTimeDisplay.value = s;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('round_time', s);
    await prefs.setString('timer', s);

    _updateTotalTime();
  }

  void setBreakTime(String s) async {
    _subjectBreakTimeDisplay.value = s;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('break_time', s);

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
        _subjectSetTimerDisplay.sink.add((int.parse(_subjectSetTimerDisplay.value) + 1).toString());
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('total_time', stringTotalTime);
  }

  void _updateTotalTime() async {
    int set = int.parse(_subjectSetSettingDisplay.value);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('total_time', stringTotalTime);
  }

  void dispose() {
    _subjectTimeDisplay.close();
    _subjectRoundTimeDisplay.close();
    _subjectBreakTimeDisplay.close();
    _subjectTotalTimeDisplay.close();
    _subjectSetSettingDisplay.close();
    _subjectSetTimerDisplay.close();
    _subjectRoundWarningDisplay.close();
    _subjectBreakWarningDisplay.close();
    _subjectTimerIsPlaying.close();
    _subjectTimerIsRound.close();
    _subjectTimerStarted.close();
  }
}
