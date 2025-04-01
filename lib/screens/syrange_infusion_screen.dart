import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_iot_app2/app/constants.dart';
import 'package:smart_iot_app2/app/extensions.dart';
import 'package:smart_iot_app2/app/validators.dart';
import 'package:smart_iot_app2/components/custom_textfield.dart';

class SyrangeInfusinoScreen extends StatefulWidget {
  const SyrangeInfusinoScreen({super.key});

  @override
  State<SyrangeInfusinoScreen> createState() => _SyrangeInfusinoScreenState();
}

class _SyrangeInfusinoScreenState extends State<SyrangeInfusinoScreen> {
  int _selectedNumber = 1;
  final List<TextEditingController> _controllers = [];
  final List<TimeOfDay?> _selectedTimes = [];
  final TextEditingController _totalInfusionController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFreezed = false;
  List<int> _timeDurationsInSeconds = [];
  int _currentCountdownIndex = 0;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController());
    _selectedTimes.add(null);
    _totalInfusionController.addListener(_checkInfusionEntered);
  }

  void _checkInfusionEntered() {
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _totalInfusionController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateTextFields(int count) {
    setState(() {
      _controllers.clear();
      _selectedTimes.clear();
      for (int i = 0; i < count; i++) {
        _controllers.add(TextEditingController());
        _selectedTimes.add(null);
      }
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Calculate the total value of all CustomTextField inputs
      double totalDosage = _controllers.fold(
        0,
        (sum, controller) => sum + (double.tryParse(controller.text) ?? 0),
      );

      // Get the total infusion value
      double totalInfusion =
          double.tryParse(_totalInfusionController.text) ?? 0;

      // Check if the total dosage matches the total infusion value
      if (totalDosage != totalInfusion) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'The total dosage ($totalDosage ML) must equal the total infusion value ($totalInfusion ML).',
            ),
          ),
        );
        return;
      }

      // Check if all timers are selected
      if (_selectedTimes.any((time) => time == null)) {
        context.showMessage('Please select all timers');
        return;
      }

      _updateAllFields();

      setState(() {
        _isFreezed = true;
        _timeDurationsInSeconds = [];

        // Populate _timeDurationsInSeconds with the difference in seconds
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
              : (1440 +
                  currentInMinutes -
                  previousInMinutes); // Handle next day

          _timeDurationsInSeconds
              .add(differenceInMinutes * 60); // Convert to seconds
        }

        _currentCountdownIndex = 0;
        _startCountdown(); // Start the countdown
      });
    }
  }

  void _startCountdown() {
    if (_currentCountdownIndex >= _timeDurationsInSeconds.length) {
      _timer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All timers completed!')),
      );
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
        print('hello');
        print(_currentCountdownIndex);
        _updateSpecificField(_currentCountdownIndex);

        if (_currentCountdownIndex < _timeDurationsInSeconds.length - 1) {
          setState(() {
            _currentCountdownIndex++;
          });
          _startCountdown(); // Start the next countdown
        } else {
          _timer?.cancel();
          context.showMessage('All timers completed!');
        }
      }
    });
  }

//update the specific field in the doc
  void _updateSpecificField(int index) async {
    // int sValue = _controllers[index].text.isNotEmpty
    //     ? int.parse(_controllers[index].text)
    //     : 0;
    Map<String, int> fields = {'S': index + 1, 'U': 1};

    await FirebaseFirestore.instance
        .collection('my_collection2')
        .doc('test_doc')
        .update(fields);
  }

//update all the data in to the doc
  void _updateAllFields() async {
    Map<String, int> fields = {
      'Q1':
          _controllers[0].text.isNotEmpty ? int.parse(_controllers[0].text) : 0,
      'Q2':
          _controllers[1].text.isNotEmpty ? int.parse(_controllers[1].text) : 0,
      'Q3':
          _controllers[2].text.isNotEmpty ? int.parse(_controllers[2].text) : 0,
      'Q4':
          _controllers[3].text.isNotEmpty ? int.parse(_controllers[3].text) : 0,
      'N': _selectedNumber,
      'TFluid': int.parse(_totalInfusionController.text),
      'S': 0,
      'U': 0
    };

    await FirebaseFirestore.instance
        .collection('my_collection2')
        .doc('test_doc')
        .update(fields);
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    FocusScope.of(context).unfocus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syrange Infusion'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_isFreezed) ...[
                  const SizedBox(height: 16),
                  Text(
                    '$_currentCountdownIndex Timers completed out of $_selectedNumber',
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
                  const SizedBox(height: defaultPadding),
                ],
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        controller: _totalInfusionController,
                        titleText: 'Enter Total Infusion ML',
                        textInputType: TextInputType.number,
                        readOnly: _isFreezed,
                        onSaved: (p0) {
                          if (int.parse(_totalInfusionController.text) > 50) {
                            context.showError(
                                'Total infusion should be less than 50 ml');
                          }
                        },
                        validators: const [Validator.validateNotEmpty],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: OutlinedDropdown(
                        titleText: 'Dosages',
                        items: List.generate(4, (index) => index + 1)
                            .map((number) => DropdownMenuItem(
                                  value: number,
                                  child: Text(number.toString()),
                                ))
                            .toList(),
                        value: _selectedNumber,
                        onChanged:
                            _totalInfusionController.text.isEmpty || _isFreezed
                                ? null
                                : (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedNumber = value as int;
                                        _updateTextFields(value);
                                      });
                                    }
                                  },
                      ),
                    )
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                if (_totalInfusionController.text.isNotEmpty) ...[
                  ..._controllers.asMap().entries.map((entry) {
                    int index = entry.key;
                    TextEditingController controller = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              controller: controller,
                              titleText: 'Dosage ${index + 1} ML',
                              readOnly: _isFreezed,
                              textInputType: TextInputType.number,
                              validators: const [Validator.validateNotEmpty],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              onPressed: _isFreezed
                                  ? null
                                  : () => _selectTime(context, index),
                              child: Text(
                                _selectedTimes[index] != null
                                    ? _selectedTimes[index]!.format(context)
                                    : 'Select Time',
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
                    child: const Text('Submit'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
