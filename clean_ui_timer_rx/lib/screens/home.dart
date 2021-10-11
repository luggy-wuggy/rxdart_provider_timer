import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:clean_ui_timer_rx/model/timer_settings.dart';
import 'package:clean_ui_timer_rx/widgets/bottom_bar.dart';
import 'package:clean_ui_timer_rx/widgets/subheader.dart';
import 'package:clean_ui_timer_rx/widgets/timer.dart';
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
            const SubHeaderWidget(),
            const Spacer(),
            TimerWidget(isPlaying),
            const Spacer(),
            BottomBarWidget(isPlaying),
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
}
