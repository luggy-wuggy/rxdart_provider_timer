import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:timer_rx/model/timer_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //Create a new instance of the timer for the stateful widget
  late TimerBloc _timerBloc;

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerBloc>(context);

    return Center(
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          size: 220,
          infoProperties: InfoProperties(modifier: (double d) {
            Duration time = Duration(seconds: d.round());

            final String _inMinutes =
                (time.inMinutes % 60).toString().padLeft(2, '0');
            final String _inSeconds =
                (time.inSeconds % 60).toString().padLeft(2, '0');

            return "$_inMinutes:$_inSeconds";
          }),
        ),
        min: 0,
        max: 600,
        onChange: (double d) {
          Duration time = Duration(seconds: d.round());

          final String _inMinutes =
              (time.inMinutes % 60).toString().padLeft(2, '0');
          final String _inSeconds =
              (time.inSeconds % 60).toString().padLeft(2, '0');

          final String timeDisplay = '$_inMinutes:$_inSeconds';
          _timerBloc.setTimer(timeDisplay);
        },
      ),
    );
  }
}
