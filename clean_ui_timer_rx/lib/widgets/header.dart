import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late TimerBloc _timerBloc;

  @override
  void dispose() {
    super.dispose();
    _timerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerBloc>(context);

    return StreamBuilder<Object>(
      stream: _timerBloc.isTimerStartedObservable,
      builder: (context, snapshot) {
        bool isStarted = snapshot.hasData ? snapshot.data as bool : false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Interval Timer',
              style: kTitleStyle,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              height: 40,
              width: 40,
              decoration: isStarted
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                    )
                  : BoxDecoration(
                      color: Colors.grey[900],
                      shape: BoxShape.circle,
                    ),
              alignment: Alignment.center,
              child: isStarted
                  ? null
                  : const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 25,
                    ),
            ),
          ],
        );
      },
    );
  }
}
