import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:clean_ui_timer_rx/model/timer_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TimerBloc _timerBloc;
  late FixedExtentScrollController _setsScrollController;
  late Duration roundDurationTime;
  late Duration breakDurationTime;

  // ignore: todo
  /// TODO : MAKE this boolean into a stream
  bool isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    _timerBloc.dispose();
    _setsScrollController.dispose();
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
              'Interval Timer',
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
          StreamBuilder<Object>(
              stream: _timerBloc.setObservable,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () async {
                    _setsScrollController = FixedExtentScrollController(
                        initialItem: setsList.indexOf("${snapshot.data}"));

                    await showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 370,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(12, 13, 12, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 220,
                                  child: CupertinoPicker(
                                    scrollController: _setsScrollController,
                                    itemExtent: 40,
                                    onSelectedItemChanged: (int index) {},
                                    children: setsList.map((e) {
                                      return Text(
                                        e,
                                        style: kTitleTabStyle,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _timerBloc.setSet(setsList[
                                        _setsScrollController.selectedItem]);
                                  },
                                  child: Container(
                                    height: 55,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(17),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue[600] as Color,
                                            Colors.blue[300] as Color,
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.blueGrey[900] as Color,
                                            blurRadius: 10,
                                            blurStyle: BlurStyle.normal,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Set',
                                      style: kTitleTabStyle,
                                    ),
                                  ),
                                ),
                                // ElevatedButton(
                                //   child: const Text('Close BottomSheet'),
                                //   onPressed: () => Navigator.pop(context),
                                // )
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
                      Text(
                        '${snapshot.data}',
                        style: kTitleTabStyle,
                      ),
                    ],
                  ),
                );
              }),
          StreamBuilder<Object>(
            stream: _timerBloc.roundTimeObservable,
            builder: (context, snapshot) {
              String roundStringTime = "${snapshot.data}";

              return GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 370,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(12, 13, 12, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 220,
                                alignment: Alignment.center,
                                child: CupertinoTheme(
                                  data: CupertinoThemeData(
                                    textTheme: CupertinoTextThemeData(
                                        pickerTextStyle: kTitleTabStyle),
                                  ),
                                  child: CupertinoTimerPicker(
                                    initialTimerDuration: Duration(
                                      minutes: int.parse(
                                          roundStringTime.split(":")[0]),
                                      seconds: int.parse(
                                          roundStringTime.split(":")[1]),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    onTimerDurationChanged: (Duration d) {
                                      roundDurationTime = d;
                                    },
                                    mode: CupertinoTimerPickerMode.ms,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  roundStringTime =
                                      "${(roundDurationTime.inMinutes % 60).toString()}:${(roundDurationTime.inSeconds % 60).toString().padLeft(2, '0')}";

                                  _timerBloc.setRoundTime(roundStringTime);
                                },
                                child: Container(
                                  height: 55,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(17),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue[600] as Color,
                                          Colors.blue[300] as Color,
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey[900] as Color,
                                          blurRadius: 10,
                                          blurStyle: BlurStyle.normal,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Set',
                                    style: kTitleTabStyle,
                                  ),
                                ),
                              ),
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
                      'ROUND',
                      style: kSubTitleTabStyle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${snapshot.data}',
                      style: kTitleTabStyle,
                    ),
                  ],
                ),
              );
            },
          ),
          StreamBuilder<Object>(
              stream: _timerBloc.breakTimeObservable,
              builder: (context, snapshot) {
                String breakStringTime = '${snapshot.data}';

                return GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 370,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(12, 13, 12, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 220,
                                  alignment: Alignment.center,
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                      textTheme: CupertinoTextThemeData(
                                          pickerTextStyle: kTitleTabStyle),
                                    ),
                                    child: CupertinoTimerPicker(
                                      initialTimerDuration: Duration(
                                        minutes: int.parse(
                                            breakStringTime.split(":")[0]),
                                        seconds: int.parse(
                                            breakStringTime.split(":")[1]),
                                      ),
                                      alignment: Alignment.bottomCenter,
                                      onTimerDurationChanged: (Duration d) {
                                        breakDurationTime = d;
                                      },
                                      mode: CupertinoTimerPickerMode.ms,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    breakStringTime =
                                        "${(breakDurationTime.inMinutes % 60).toString()}:${(breakDurationTime.inSeconds % 60).toString().padLeft(2, '0')}";

                                    _timerBloc.setBreakTime(breakStringTime);
                                  },
                                  child: Container(
                                    height: 55,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(17),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue[600] as Color,
                                            Colors.blue[300] as Color,
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.blueGrey[900] as Color,
                                            blurRadius: 10,
                                            blurStyle: BlurStyle.normal,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Set',
                                      style: kTitleTabStyle,
                                    ),
                                  ),
                                ),
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
                        'BREAK',
                        style: kSubTitleTabStyle,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${snapshot.data}',
                        style: kTitleTabStyle,
                      ),
                    ],
                  ),
                );
              }),
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
