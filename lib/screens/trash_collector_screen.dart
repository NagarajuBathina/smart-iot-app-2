import 'package:flutter/material.dart';

class WaterTrashCollectorScreen extends StatefulWidget {
  const WaterTrashCollectorScreen({super.key});

  @override
  State<WaterTrashCollectorScreen> createState() =>
      _WaterTrashCollectorScreenState();
}

class _WaterTrashCollectorScreenState extends State<WaterTrashCollectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash Collector'),
        titleSpacing: 0,
      ),
    );
  }
}
