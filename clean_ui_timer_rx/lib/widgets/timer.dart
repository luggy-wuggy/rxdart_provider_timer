import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TimerWidget extends StatelessWidget {
  TimerWidget({Key? key}) : super(key: key);

  late bool isPlaying;
  late bool isTimerRound;
  late TimerBloc _timerBloc;

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerBloc>(context);

    return StreamBuilder<Object>(
      stream: _timerBloc.isPlayingObservable,
      builder: (context, snapshot) {
        isPlaying = snapshot.hasData ? snapshot.data as bool : false;

        return StreamBuilder<Object>(
          stream: _timerBloc.isTimerRoundObservable,
          builder: (context, snapshot) {
            isTimerRound = snapshot.hasData ? snapshot.data as bool : false;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                boxShadow: [
                  isPlaying
                      ? BoxShadow(
                          color: Colors.blueGrey[800] as Color,
                          blurRadius: 35,
                          blurStyle: BlurStyle.normal,
                          offset: const Offset(0, 3),
                        )
                      : const BoxShadow(),
                ],
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[
                    isPlaying
                        ? isTimerRound
                            ? Colors.green[700] as Color
                            : Colors.amber[700] as Color
                        : Colors.grey[800] as Color,
                    isPlaying
                        ? isTimerRound
                            ? Colors.green[200] as Color
                            : Colors.amber[200] as Color
                        : Colors.grey[800] as Color,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              alignment: Alignment.center,
              child: StreamBuilder<Object>(
                stream: _timerBloc.timeObservable,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: kTimerStyle,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
