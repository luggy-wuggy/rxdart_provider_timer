import 'dart:async';
import 'package:rxdart/rxdart.dart';

class TimerBloc {
  late BehaviorSubject<String> _subjectTimeDisplay;
  late BehaviorSubject<String> _subjectRoundTimeDisplay;
  late BehaviorSubject<String> _subjectBreakTimeDisplay;
  late BehaviorSubject<String> _subjectTotalTimeDisplay;
  late BehaviorSubject<String> _subjectSetsDisplay;

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
  }

  Stream<String> get timeObservable => _subjectTimeDisplay.stream;
  Stream<String> get roundTimeObservable => _subjectRoundTimeDisplay.stream;
  Stream<String> get breakTimeObservable => _subjectBreakTimeDisplay.stream;
  Stream<String> get totalTimeObservable => _subjectTotalTimeDisplay.stream;
  Stream<String> get setObservable => _subjectSetsDisplay.stream;

  void dispose() {
    _subjectTimeDisplay.close();
    _subjectRoundTimeDisplay.close();
    _subjectBreakTimeDisplay.close();
    _subjectTotalTimeDisplay.close();
    _subjectSetsDisplay.close();
  }
}
