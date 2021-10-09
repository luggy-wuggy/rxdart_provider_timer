import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TimerBloc _timerBloc;

  // ignore: todo
  /// TODO : MAKE this boolean into a stream
  bool isPlaying = true;

  @override
  void dispose() {
    super.dispose();
    _timerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerBloc>(context);

    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            headerWidget(),
            const SizedBox(
              height: 25,
            ),
            subHeaderWidget(context),
            const Spacer(),
            timerWidget(),
            const Spacer(),
            bottomBarWidget(),
          ],
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<Object>(
          stream: _timerBloc.setObservable,
          builder: (context, snapshot) {
            return Text(
              'Set Timer',
              style: kTitleStyle,
            );
          },
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget subHeaderWidget(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 370,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[400] as Color,
                          Colors.grey[100] as Color
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListWheelScrollView(
                            itemExtent: 42,
                            children: [
                              Text('1'),
                              Text('1'),
                              Text('1'),
                              Text('1'),
                            ],
                          ),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SETS',
                  style: kSubTitleTabStyle,
                ),
                const SizedBox(height: 6),
                StreamBuilder<Object>(
                  stream: _timerBloc.setObservable,
                  builder: (context, snapshot) {
                    return Text(
                      '${snapshot.data}',
                      style: kTitleTabStyle,
                    );
                  },
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ROUND',
                style: kSubTitleTabStyle,
              ),
              const SizedBox(height: 6),
              StreamBuilder<Object>(
                stream: _timerBloc.roundTimeObservable,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: kTitleTabStyle,
                  );
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BREAK',
                style: kSubTitleTabStyle,
              ),
              const SizedBox(height: 6),
              StreamBuilder<Object>(
                stream: _timerBloc.breakTimeObservable,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: kTitleTabStyle,
                  );
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL TIME',
                style: kSubTitleTabStyle,
              ),
              const SizedBox(height: 6),
              StreamBuilder<Object>(
                stream: _timerBloc.totalTimeObservable,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: kTitleTabStyle,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget timerWidget() {
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
            isPlaying ? Colors.green[700] as Color : Colors.grey[800] as Color,
            isPlaying ? Colors.green[200] as Color : Colors.grey[800] as Color,
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
  }

  Widget bottomBarWidget() {
    return SizedBox(
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
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
          GestureDetector(
            onTap: () {
              setState(() {
                isPlaying = !isPlaying;
              });
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
                    !isPlaying
                        ? Colors.green[700] as Color
                        : Colors.grey[800] as Color,
                    !isPlaying
                        ? Colors.green[200] as Color
                        : Colors.grey[800] as Color,
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
          ),
          Container(
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
        ],
      ),
    );
  }
}
