import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

///The class for the timer
class TimerBloc {
  ///The Stopwatch object for running the timer
  final Stopwatch _sWatch = Stopwatch();

  ///Creating a BehaviorSubject of type String for the Stopwatch display
  late BehaviorSubject<String> _subjectTimeDisplay;

  ///Creating a BehaviorSubject of type bool for the IsRunning variable
  late BehaviorSubject<bool> _subjectIsRunning;

  ///Creating a BehaviorSubject of type String for the Round display
  late BehaviorSubject<String> _subjectRoundDisplay;

  ///The initial String value for the Stopwatch display
  String initialDisplay = '00:05';

  ///The initial String value for the Round display
  String initialRoundDisplay = '1';

  ///The final String value for the Round display
  String finalRound = '3';

  ///The initial bool value for the IsRunning variable
  bool initialIsRunning = false;

  ///The class builder
  ///Takes in the local initialDisplay and initialIsRunning to seed the
  ///subject behaviours
  TimerBloc() {
    _subjectTimeDisplay = BehaviorSubject<String>.seeded(initialDisplay);
    _subjectIsRunning = BehaviorSubject<bool>.seeded(initialIsRunning);
    _subjectRoundDisplay = BehaviorSubject<String>.seeded(initialRoundDisplay);
  }

  ///A Stream for the Stopwatch String value
  Stream<String> get timerObservable => _subjectTimeDisplay.stream;

  ///A Stream for the IsRunning bool value
  Stream<bool> get isRunningObservable => _subjectIsRunning.stream;

  ///A Stream for the Round String value
  Stream<String> get roundObservable => _subjectRoundDisplay.stream;

  ///Start the timer
  ///
  ///If the timer already has a value, it continues where it left off. Otherwise,
  ///it starts counting from 00:00
  void startTimer() {
    _subjectIsRunning.value = true;
    _sWatch.start();
    _startTimer();
  }

  void setTimer(String s) {
    resetTimer();
    _subjectTimeDisplay.sink.add(s);
  }

  ///Runs the Stopwatch every second
  void _startTimer() {
    Timer(const Duration(seconds: 1), _keepRunning);
  }

  ///Keeps the Stopwatch running and updates the Stopwatch display BehaviourSubject
  void _keepRunning() {
    //Stop the timer from overflowing, max value should be 99:99

    if (_subjectTimeDisplay.value == '00:00' &&
        _subjectRoundDisplay.value != finalRound) {
      _sWatch.reset();
      _subjectRoundDisplay.sink
          .add((int.parse(_subjectRoundDisplay.value) + 1).toString());
      _subjectTimeDisplay.sink.add(initialDisplay);
    }

    if (_subjectRoundDisplay.value == finalRound &&
        _subjectTimeDisplay.value == '00:00') {
      resetTimer();
      return;
    }

    if (_sWatch.isRunning) {
      _startTimer();
    }

    _subjectTimeDisplay.sink.add(_formatStopWatch(_sWatch));
  }

  ///Formats the StopWatch elapsed time into the 00:00 format
  String _formatStopWatch(Stopwatch _swatch) {
    Duration time = Duration(
            minutes: int.parse(_subjectTimeDisplay.value.substring(0, 2)),
            seconds: int.parse(_subjectTimeDisplay.value.substring(3))) -
        const Duration(seconds: 1);

    final String _inMinutes = (time.inMinutes % 60).toString().padLeft(2, '0');
    final String _inSeconds = (time.inSeconds % 60).toString().padLeft(2, '0');

    return "$_inMinutes:$_inSeconds";
  }

  ///Pause the timer and stop on the current display from being changed
  void pauseTimer() {
    _subjectIsRunning.value = false;
    _sWatch.stop();
  }

  ///Reset the timer display and the Stopwatch object
  void resetTimer() {
    _sWatch.stop();
    _sWatch.reset();
    _subjectIsRunning.value = false;
    _subjectRoundDisplay.sink.add(initialRoundDisplay);
    _subjectTimeDisplay.sink.add(initialDisplay);
  }

  ///Resumed the timer and continue updating the Stopwach display
  void resumeTimer() {
    _subjectIsRunning.value = true;
    _sWatch.start();
    _startTimer();
  }

  ///Dispose of the BehaviorSubjects
  void dispose() {
    _subjectTimeDisplay.close();
    _subjectIsRunning.close();
    _subjectRoundDisplay.close();
  }
}
