import 'package:clean_ui_timer_rx/bloc/timer_provider.dart';
import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  late bool isPlaying;
  late TimerBloc _timerBloc;

  @override
  void dispose() {
    super.dispose();
    _timerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerProvider>(context).bloc;

    return SizedBox(
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              await _timerBloc.stopTimer();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[900],
              ),
              alignment: Alignment.center,
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          StreamBuilder<Object>(
            stream: _timerBloc.isPlayingObservable,
            builder: (context, snapshot) {
              isPlaying = snapshot.hasData ? snapshot.data as bool : false;

              return StreamBuilder<Object>(
                stream: _timerBloc.isTimerStartedObservable,
                builder: (context, started) {
                  bool isStarted = started.hasData ? started.data as bool : false;

                  return GestureDetector(
                    onTap: () {
                      isPlaying
                          ? _timerBloc.pauseTimer()
                          : isStarted
                              ? _timerBloc.resumeTimer()
                              : _timerBloc.startTimer();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        boxShadow: [
                          !isPlaying
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
                            !isPlaying ? Colors.green[700] as Color : Colors.grey[800] as Color,
                            !isPlaying ? Colors.green[200] as Color : Colors.grey[800] as Color,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          GestureDetector(
            onTap: () async {
              await _timerBloc.rewindTimer();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[900],
              ),
              child: const Icon(
                Icons.settings_backup_restore_rounded,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
