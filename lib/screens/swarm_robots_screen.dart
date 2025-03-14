import 'package:flutter/material.dart';

class SwarmRobotsScreen extends StatefulWidget {
  const SwarmRobotsScreen({super.key});

  @override
  State<SwarmRobotsScreen> createState() => _SwarmRobotsScreenState();
}

class _SwarmRobotsScreenState extends State<SwarmRobotsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swarm Robots'),
        titleSpacing: 0,
      ),
    );
  }
}
