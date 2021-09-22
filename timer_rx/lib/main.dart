import 'package:flutter/material.dart';
import 'package:timer_rx/model/timer_bloc.dart';
import 'package:provider/provider.dart';

import '../model/destination.dart';

void main() {
  runApp(const TimerApp());
}

class TimerApp extends StatefulWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => TimerBloc(),
      child: MaterialApp(
        home: Scaffold(
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _currentIndex,
              children: allDestinations.map<Widget>((Destination destination) {
                return DestinationView(destination: destination);
              }).toList(),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: allDestinations.map((Destination d) {
              return BottomNavigationBarItem(
                icon: Icon(d.icon),
                label: d.title,
                backgroundColor: d.color,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
