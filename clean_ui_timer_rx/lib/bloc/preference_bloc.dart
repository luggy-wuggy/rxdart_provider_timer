import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  late TimerBloc _timerBloc;

  TimerProvider() {
    _timerBloc = TimerBloc();
    _timerBloc.loadPreferences();
  }

  TimerBloc get bloc => _timerBloc;
}
