import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomBarWidget extends StatefulWidget {
  BottomBarWidget(this.isPlaying, {Key? key}) : super(key: key);

  bool isPlaying;

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
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
                widget.isPlaying = !widget.isPlaying;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                boxShadow: [
                  !widget.isPlaying
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
                    !widget.isPlaying
                        ? Colors.green[700] as Color
                        : Colors.grey[800] as Color,
                    !widget.isPlaying
                        ? Colors.green[200] as Color
                        : Colors.grey[800] as Color,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Icon(
                widget.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
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
