import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineDispenserScreen extends StatefulWidget {
  const MedicineDispenserScreen({super.key});

  @override
  State<MedicineDispenserScreen> createState() =>
      _MedicineDispenserScreenState();
}

class _MedicineDispenserScreenState extends State<MedicineDispenserScreen> {
  final List<TimeOfDay?> _selectedTimes = List.generate(4, (_) => null);
  bool _isFreezed = false;
  List<int> _timeDurationsInSeconds = [];
  int _currentCountdownIndex = 0;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTimes[index]) {
      setState(() {
        _selectedTimes[index] = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_selectedTimes.any((time) => time == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all timers')),
      );
      return;
    }

    setState(() {
      _isFreezed = true;
      _timeDurationsInSeconds = [];

      for (int i = 0; i < _selectedTimes.length; i++) {
        final current = _selectedTimes[i]!;
        final previous = i == 0
            ? TimeOfDay
                .now() // For the first timer, calculate from the current time
            : _selectedTimes[i - 1]!;

        final currentInMinutes = current.hour * 60 + current.minute;
        final previousInMinutes = previous.hour * 60 + previous.minute;

        final differenceInMinutes = currentInMinutes - previousInMinutes >= 0
            ? currentInMinutes - previousInMinutes
            : (1440 + currentInMinutes - previousInMinutes); // Handle next day

        _timeDurationsInSeconds
            .add(differenceInMinutes * 60); // Convert to seconds
      }

      _currentCountdownIndex = 0;
      _startCountdown();
    });
  }

  void _startCountdown() {
    if (_currentCountdownIndex >= _timeDurationsInSeconds.length) {
      _timer?.cancel();
      return;
    }

    setState(() {
      _remainingSeconds = _timeDurationsInSeconds[_currentCountdownIndex];
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        print("Hello"); // Print "Hello" when the timer completes
        _updateSpecificField(_currentCountdownIndex);

        if (_currentCountdownIndex < _timeDurationsInSeconds.length - 1) {
          setState(() {
            _currentCountdownIndex++;
          });
          _startCountdown(); // Start the next countdown
        } else {
          // When the last countdown finishes, call _makeAllFields0
          Timer(const Duration(seconds: 15), () {
            _makeAllFields0();
          });
          _timer?.cancel();
        }
      }
    });
  }

  void _updateSpecificField(int index) async {
    Map<String, int> fields = {'t1': 0, 't2': 0, 't3': 0, 't4': 0, 'm1': 1};

    // Set the specific field for the current timer to 1
    fields['t${index + 1}'] = 1;

    await FirebaseFirestore.instance
        .collection('my_collection1')
        .doc('test_doc')
        .update(fields);
  }

  void _makeAllFields0() async {
    await FirebaseFirestore.instance
        .collection('my_collection1')
        .doc('test_doc')
        .update({
      's1': 0,
      's2': 0,
      's3': 0,
      's4': 0,
      't1': 0,
      't2': 0,
      't3': 0,
      't4': 0,
      'm1': 0
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _format12HourTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Timers'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set Timers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._selectedTimes.asMap().entries.map((entry) {
                int index = entry.key;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Timer ${index + 1}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextButton(
                          onPressed: _isFreezed
                              ? null
                              : () => _selectTime(context, index),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _selectedTimes[index] != null
                                ? _format12HourTime(_selectedTimes[index]!)
                                : 'Select Time',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isFreezed ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Submit'),
              ),
              if (_isFreezed) ...[
                const SizedBox(height: 16),
                Text(
                  '$_currentCountdownIndex Timers completed out of 4',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
