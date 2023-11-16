import 'package:clean_ui_timer_rx/bloc/timer_provider.dart';
import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:clean_ui_timer_rx/model/timer_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubHeaderWidget extends StatefulWidget {
  const SubHeaderWidget({Key? key}) : super(key: key);

  @override
  State<SubHeaderWidget> createState() => _SubHeaderWidgetState();
}

class _SubHeaderWidgetState extends State<SubHeaderWidget> {
  late TimerBloc _timerBloc;
  late FixedExtentScrollController _setsScrollController;
  late Duration roundDurationTime;
  late Duration breakDurationTime;

  @override
  void dispose() {
    super.dispose();
    _timerBloc.dispose();
    _setsScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerProvider>(context).bloc;

    return StreamBuilder<bool>(
      stream: _timerBloc.isTimerStartedObservable,
      builder: (context, snapshot) {
        bool isStarted = snapshot.hasData ? snapshot.data as bool : false;

        return IgnorePointer(
          ignoring: isStarted,
          child: SizedBox(
            height: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<String>(
                  stream: _timerBloc.setSettingObservable,
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () async {
                        _setsScrollController =
                            FixedExtentScrollController(initialItem: setsList.indexOf("${snapshot.data}"));
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
                                          return Text(e, style: kTitleTabStyle);
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        _timerBloc.setSet(setsList[_setsScrollController.selectedItem]);
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
                                          ],
                                        ),
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
                          Text('SETS', style: kSubTitleTabStyle),
                          const SizedBox(height: 6),
                          Text('${snapshot.data}', style: kTitleTabStyle),
                        ],
                      ),
                    );
                  },
                ),
                StreamBuilder<String>(
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
                                          textTheme: CupertinoTextThemeData(pickerTextStyle: kTitleTabStyle),
                                        ),
                                        child: CupertinoTimerPicker(
                                          initialTimerDuration: Duration(
                                            minutes: int.parse(roundStringTime.split(":")[0]),
                                            seconds: int.parse(roundStringTime.split(":")[1]),
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
                          Text('ROUND', style: kSubTitleTabStyle),
                          const SizedBox(height: 6),
                          Text('${snapshot.data}', style: kTitleTabStyle),
                        ],
                      ),
                    );
                  },
                ),
                StreamBuilder<String>(
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
                                          textTheme: CupertinoTextThemeData(pickerTextStyle: kTitleTabStyle),
                                        ),
                                        child: CupertinoTimerPicker(
                                          initialTimerDuration: Duration(
                                            minutes: int.parse(breakStringTime.split(":")[0]),
                                            seconds: int.parse(breakStringTime.split(":")[1]),
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
                                              color: Colors.blueGrey[900] as Color,
                                              blurRadius: 10,
                                              blurStyle: BlurStyle.normal,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
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
                          Text('BREAK', style: kSubTitleTabStyle),
                          const SizedBox(height: 6),
                          Text('${snapshot.data}', style: kTitleTabStyle),
                        ],
                      ),
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL TIME', style: kSubTitleTabStyle),
                    const SizedBox(height: 6),
                    StreamBuilder<String>(
                      stream: _timerBloc.totalTimeObservable,
                      builder: (context, snapshot) {
                        return Text('${snapshot.data}', style: kTitleTabStyle);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
