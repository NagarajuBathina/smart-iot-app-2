import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SwarmRobotsScreen extends StatefulWidget {
  const SwarmRobotsScreen({super.key});

  @override
  State<SwarmRobotsScreen> createState() => _SwarmRobotsScreenState();
}

class _SwarmRobotsScreenState extends State<SwarmRobotsScreen> {
  bool _robot1Active = true;
  bool _robot2Active = true;

  double _robot1Temperature = 0.0;
  double _robot1Humidity = 0.0;
  double _robot2Temperature = 0.0;

  @override
  void initState() {
    super.initState();
    _getSnapshotData();
  }

  void _getSnapshotData() async {
    FirebaseFirestore.instance
        .collection('test1')
        .doc('0Hvf1CZFwwvivKwstCt8')
        .snapshots()
        .listen((event) {
      setState(() {
        var data = event.data();
        if (data != null) {
          _robot1Active = data['robot1Active'] ?? true;
          _robot2Active = data['robot2Active'] ?? false;
          _robot1Temperature = data['robot1Temperature'] ?? 0.0;
          _robot1Humidity = data['robot1Humidity'] ?? 0.0;
          _robot2Temperature = data['robot2Temperature'] ?? 0.0;
        }
      });
    }, onError: (error) => print("Listen failed: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swarm Robots'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildRobotStatusCard(
                robotName: 'Robot 1',
                isActive: _robot1Active,
                temperature: _robot1Temperature,
                humidity: _robot1Humidity,
              ),
              const SizedBox(height: 16),
              _buildRobotStatusCard(
                robotName: 'Robot 2',
                isActive: _robot2Active,
                temperature: _robot2Temperature,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRobotStatusCard({
    required String robotName,
    required bool isActive,
    required double temperature,
    double? humidity,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  robotName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const CircleAvatar(
                      child: Icon(
                        Icons.send_rounded,
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 16,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Temperature: $temperature°C',
              style: const TextStyle(fontSize: 16),
            ),
            if (humidity != null) ...[
              const SizedBox(height: 8),
              Text(
                'Humidity: $humidity%',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
