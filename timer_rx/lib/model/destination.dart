import 'package:flutter/material.dart';
import 'package:timer_rx/screens/home.dart';
import 'package:timer_rx/screens/preset.dart';
import 'package:timer_rx/screens/settings.dart';

class Destination {
  const Destination(this.title, this.icon, this.color, this.body);
  final String title;
  final IconData icon;
  final MaterialColor color;
  final Widget body;

  // Destination()

}

List<Destination> allDestinations = const <Destination>[
  Destination('Presets', Icons.bookmark, Colors.cyan, PresetPage()),
  Destination('Home', Icons.home, Colors.teal, HomePage()),
  Destination('Setting', Icons.settings, Colors.orange, SettingsPage()),
];

class DestinationView extends StatelessWidget {
  const DestinationView({Key? key, required this.destination})
      : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[100],
      body: destination.body,
    );
  }
}
