import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:clean_ui_timer_rx/screens/home.dart';
import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => TimerBloc(),
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}
