import 'package:flutter/material.dart';
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

  bool _isFreezed = false;

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
    double totalInfusion = double.tryParse(_totalInfusionController.text) ?? 0;
    double sumOfDosages = _controllers.fold(
        0, (sum, controller) => sum + (double.tryParse(controller.text) ?? 0));

    if (sumOfDosages > totalInfusion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Value exceeded')),
      );
    } else {
      setState(() {
        _isFreezed = !_isFreezed;
      });
    }
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _totalInfusionController,
                      titleText: 'Enter Total Infusion ML',
                      textInputType: TextInputType.number,
                      readOnly: _isFreezed,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: OutlinedDropdown(
                      titleText: 'Dosages',
                      items: List.generate(10, (index) => index + 1)
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
                  onPressed: _handleSubmit,
                  child: const Text('Submit'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
