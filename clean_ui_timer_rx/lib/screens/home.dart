import 'package:clean_ui_timer_rx/bloc/timer_bloc.dart';
import 'package:clean_ui_timer_rx/global/text_style.dart';
import 'package:clean_ui_timer_rx/widgets/bottom_bar.dart';
import 'package:clean_ui_timer_rx/widgets/header.dart';
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
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderWidget(),
            const SizedBox(
              height: 25,
            ),
            const SubHeaderWidget(),
            const Spacer(),
            TimerWidget(),
            const Spacer(),
            BottomBarWidget(),
          ],
        ),
      ),
    );
  }
}
