import 'package:flutter/material.dart';
import 'package:smart_iot_app2/components/custom_textfield.dart';

class SyrangeInfusinoScreen extends StatefulWidget {
  const SyrangeInfusinoScreen({super.key});

  @override
  State<SyrangeInfusinoScreen> createState() => _SyrangeInfusinoScreenState();
}

class _SyrangeInfusinoScreenState extends State<SyrangeInfusinoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syrange Infusion'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            CustomTextField(
              hintText: '',
              titleText: 'Enter Infusion ML',
            )
          ],
        ),
      ),
    );
  }
}
