import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timer_rx/model/timer_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Create a new instance of the timer for the stateful widget
  late TimerBloc _timerBloc;

  @override
  void dispose() {
    super.dispose();
    _timerBloc.dispose();
  }

  bool tapDown = false;
  bool startTapped = false;

  @override
  Widget build(BuildContext context) {
    _timerBloc = Provider.of<TimerBloc>(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 120, left: 25, right: 25),
      //child: initialMenu()
      child: StreamBuilder<Object>(
        stream: _timerBloc.isTimedObservable,
        builder: (context, snapshot) {
          bool _running = snapshot.hasData ? snapshot.data as bool : false;
          return _running ? runningMenu() : initialMenu();
          //return runningMenu();
        },
      ),
    );
  }

  Widget runningMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<Object>(
          stream: _timerBloc.roundObservable,
          builder: (context, snapshot) {
            return Text(
              'ROUND ${snapshot.data}',
              style: GoogleFonts.comfortaa(
                fontSize: 55,
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
            );
          },
        ),
        const SizedBox(height: 25),
        StreamBuilder(
          stream: _timerBloc.timerRoundObservable,
          builder: (context, snapshot) {
            ///Checking if the Stream has data
            ///
            ///For some reason, the seeded option isn't working in the BLOC
            ///
            return snapshot.hasData
                ? Text(
                    '${snapshot.data}',
                    style: GoogleFonts.comfortaa(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const Text('ERROR');
          },
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ///Using a StreamBuilder to build the Pause button
            ///
            ///I build another bool, similar to the strart button, to check whether the
            ///button should be enabled.
            StreamBuilder(
              stream: _timerBloc.isRunningObservable,
              builder: (context, snapshot) {
                bool _running =
                    snapshot.hasData ? snapshot.data as bool : false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: _running
                            ? _timerBloc.pauseTimer
                            : _timerBloc.startTimer,
                        child: _running
                            ? const Text('Pause')
                            : const Text('Resume')),
                  ],
                );
              },
            ),

            ///Seperating the Pause and Stop button by 30 pixels
            const SizedBox(
              width: 30,
            ),

            ///Reset button, always enabled
            ElevatedButton(
              onPressed: _timerBloc.stopTimer,
              child: const Text('Stop'),
            ),
          ],
        )
      ],
    );
  }

  Widget initialMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${_timerBloc.finalRound} ROUNDS',
          style: GoogleFonts.comfortaa(
            fontSize: 55,
            fontWeight: FontWeight.w800,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 25),
        StreamBuilder<Object>(
            stream: _timerBloc.timerRoundObservable,
            builder: (context, snapshot) {
              return Text(
                'Round: ${snapshot.data}',
                style: GoogleFonts.comfortaa(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              );
            }),
        const SizedBox(height: 25),
        Text(
          'Break: ${_timerBloc.initialRoundDurationDisplay}',
          style: GoogleFonts.comfortaa(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 50),
        StreamBuilder(
          stream: _timerBloc.isRunningObservable,
          builder: (context, snapshot) {
            bool _running = snapshot.hasData ? snapshot.data as bool : false;
            return GestureDetector(
                onTap: _running ? null : _timerBloc.startTimer,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(
                    color: tapDown
                        ? Colors.lightGreenAccent
                        : Colors.lightGreenAccent[700],
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      'START',
                      style: GoogleFonts.comfortaa(
                        fontSize: tapDown ? 63 : 65,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                ));
          },
        ),
        // GestureDetector(
        //   onTap: () {
        //     _timerBloc.startTimer;
        //     print('what');
        //   },
        // child: AnimatedContainer(
        //   duration: const Duration(milliseconds: 500),
        //   height: 100,
        //   width: 400,
        //   decoration: BoxDecoration(
        //     color: tapDown
        //         ? Colors.lightGreenAccent
        //         : Colors.lightGreenAccent[700],
        //     borderRadius: const BorderRadius.all(Radius.circular(8)),
        //   ),
        //   child: Center(
        //     child: Text(
        //       'START',
        //       style: GoogleFonts.comfortaa(
        //         fontSize: tapDown ? 63 : 65,
        //         fontWeight: FontWeight.w800,
        //         letterSpacing: -2,
        //       ),
        //     ),
        //   ),
        //   ),
        //)
      ],
    );
  }

  Widget model() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
            stream: _timerBloc.roundObservable,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ROUND: '),
                  const SizedBox(
                    width: 2,
                  ),
                  snapshot.hasData
                      ? Text('${snapshot.data}')
                      : const Text('ERROR')
                ],
              );
            },
          ),

          ///Stream builder to watch the timer observable stream from the BLOC
          StreamBuilder(
            stream: _timerBloc.timerRoundObservable,
            builder: (context, snapshot) {
              ///Checking if the Stream has data
              ///
              ///For some reason, the seeded option isn't working in the BLOC
              if (snapshot.hasData) {
                return Text('${snapshot.data}');
              } else {
                return const Text('ERROR');
              }
            },
          ),
          const SizedBox(
            height: 40,
          ),

          ///The start button built using a StreamBuilder
          ///
          ///Checked if the timer is running and sets a seperate bool. The button then
          ///checks this bool and either allows the startTimer function to be ran or
          ///simple disabled the button
          StreamBuilder(
            stream: _timerBloc.isRunningObservable,
            builder: (context, snapshot) {
              bool _running = snapshot.hasData ? snapshot.data as bool : false;
              return ElevatedButton(
                onPressed: _running ? null : _timerBloc.startTimer,
                child: const Text('Start'),
              );
            },
          ),

          ///A row for containing the StreamBuilder for the Pause button and a
          ///regular Reset button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///Using a StreamBuilder to build the Pause button
              ///
              ///I build another bool, similar to the strart button, to check whether the
              ///button should be enabled.
              StreamBuilder(
                stream: _timerBloc.isRunningObservable,
                builder: (context, snapshot) {
                  bool _running =
                      snapshot.hasData ? snapshot.data as bool : false;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _running ? _timerBloc.pauseTimer : null,
                        child: const Text('Pause'),
                      ),
                    ],
                  );
                },
              ),

              ///Seperating the Pause and Stop button by 30 pixels
              const SizedBox(
                width: 30,
              ),

              ///Reset button, always enabled
              ElevatedButton(
                onPressed: _timerBloc.stopTimer,
                child: const Text('Stop'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
