import 'package:clean_ui_timer_rx/bloc/timer_provider.dart';
import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:clean_ui_timer_rx/model/timer_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late TimerBloc _timerBloc;

  late FixedExtentScrollController _roundWarningScrollController;
  late FixedExtentScrollController _breakWarningScrollController;

  @override
  void dispose() {
    super.dispose();
    _timerBloc.dispose();
    _roundWarningScrollController.dispose();
    _breakWarningScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerProvider>(context).bloc;

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
                  : GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                              height: MediaQuery.of(context).size.height * 0.35,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(12, 13, 12, 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(45),
                                  topRight: Radius.circular(45),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Settings',
                                        style: kSubTitleStyle,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  StreamBuilder<String>(
                                      stream: _timerBloc.roundWarningObservable,
                                      builder: (context, snapshot) {
                                        _roundWarningScrollController = FixedExtentScrollController(initialItem: warningList.indexOf("${snapshot.data}"));

                                        return GestureDetector(
                                          onTap: () {
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
                                                        SizedBox(
                                                          height: 220,
                                                          child: CupertinoPicker(
                                                            scrollController: _roundWarningScrollController,
                                                            itemExtent: 40,
                                                            onSelectedItemChanged: (int index) {},
                                                            children: warningList.map((e) {
                                                              return Text(e, style: kTitleTabStyle);
                                                            }).toList(),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 15),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                            _timerBloc.setRoundWarning(warningList[_roundWarningScrollController.selectedItem]);
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
                                              Text(
                                                'Round Warning Notice',
                                                style: kHeaderStyle,
                                              ),
                                              Text(
                                                '${snapshot.data}',
                                                style: kSubHeaderStyle,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                  const SizedBox(height: 15),
                                  Container(
                                    height: 1,
                                    width: 75,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 15),
                                  StreamBuilder<Object>(
                                    stream: _timerBloc.breakWarningObservable,
                                    builder: (context, snapshot) {
                                      _breakWarningScrollController = FixedExtentScrollController(initialItem: warningList.indexOf("${snapshot.data}"));
                                      return GestureDetector(
                                        onTap: () {
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
                                                      SizedBox(
                                                        height: 220,
                                                        child: CupertinoPicker(
                                                            scrollController: _breakWarningScrollController,
                                                            itemExtent: 40,
                                                            onSelectedItemChanged: (int index) {},
                                                            children: warningList.map((e) {
                                                              return Text(e, style: kTitleTabStyle);
                                                            }).toList()),
                                                      ),
                                                      const SizedBox(height: 15),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          _timerBloc.setBreakWarning(warningList[_breakWarningScrollController.selectedItem]);
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
                                            Text(
                                              'End Warning Notice',
                                              style: kHeaderStyle,
                                            ),
                                            Text(
                                              '${snapshot.data}',
                                              style: kSubHeaderStyle,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
