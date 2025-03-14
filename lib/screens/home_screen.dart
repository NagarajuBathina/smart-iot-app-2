import 'package:flutter/material.dart';
import 'package:smart_iot_app2/screens/swarm_robots_screen.dart';
import 'package:smart_iot_app2/screens/syrange_infusion_screen.dart';
import 'package:smart_iot_app2/screens/trash_collector_screen.dart';

import '../app/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Color> _bgColor = [buttonColor, limeColor, greenColor];
  final List<String> _screenNames = [
    'Syrange Infusion',
    'Swarm Robots',
    'Water Trash Collector'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: 3,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SyrangeInfusinoScreen()));
                } else if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SwarmRobotsScreen()));
                } else if (index == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const WaterTrashCollectorScreen()));
                }
              },
              child: Container(
                decoration: BoxDecoration(color: _bgColor[index]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(_iconPath[index], height: 100),
                    Text(
                      _screenNames[index],
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
