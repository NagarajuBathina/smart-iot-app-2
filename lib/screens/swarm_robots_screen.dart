import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

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
  double _robot2Moisture = 0.0;

  @override
  void initState() {
    super.initState();
    _getSnapshotData();
  }

  void _getSnapshotData() async {
    FirebaseFirestore.instance
        .collection('my_collection')
        .doc('test_doc')
        .snapshots()
        .listen((event) {
      setState(() {
        var data = event.data();
        if (data != null) {
          _robot1Active = data['robot1Active'] ?? true;
          _robot2Active = data['robot2Active'] ?? true;
          _robot1Temperature = data['temperature'] ?? 0.0;
          _robot1Humidity = data['humidity'] ?? 0.0;
          _robot2Moisture = data['moisture'] ?? 0.0;
        }
      });
    }, onError: (error) => print("Listen failed: $error"));
  }

  void _updateValues({required String key, required double value}) async {
    await FirebaseFirestore.instance
        .collection('my_collection')
        .doc('test_doc')
        .update({key: value});
  }

//  Expanded(
//                     flex: 1,
//                     child: OutlinedDropdown(
//                       titleText: 'Dosages',
//                       items: List.generate(3, (index) => index + 1)
//                           .map((number) => DropdownMenuItem(
//                                 value: number,
//                                 child: Text(number.toString()),
//                               ))
//                           .toList(),
//                       value: _selectedNumber,
//                       onChanged:
//                           _totalInfusionController.text.isEmpty || _isFreezed
//                               ? null
//                               : (value) {
//                                   if (value != null) {
//                                     setState(() {
//                                       _selectedNumber = value as int;
//                                       _updateTextFields(value);
//                                     });
//                                   }
//                                 },
//                     ),
//                   )

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
              _buildRobotStatusCard2(
                  robotName: 'Robot 2',
                  isActive: _robot2Active,
                  moisture: _robot2Moisture),
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
                    onPressed: () {
                      Vibration.vibrate(duration: 100, amplitude: 128);
                      _updateValues(key: 'temperature', value: 20.9);
                    },
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
            const SizedBox(height: 8),
            Text(
              'Humidity: $humidity%',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRobotStatusCard2({
    required String robotName,
    required bool isActive,
    required double moisture,
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
                    onPressed: () {
                      Vibration.vibrate(duration: 100, amplitude: 128);
                      _updateValues(key: 'moisture', value: 22);
                    },
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
              'Moisture: $moisture',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
