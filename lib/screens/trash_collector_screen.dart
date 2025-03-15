import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_iot_app2/app/constants.dart';

class WaterTrashCollectorScreen extends StatefulWidget {
  const WaterTrashCollectorScreen({super.key});

  @override
  State<WaterTrashCollectorScreen> createState() =>
      _WaterTrashCollectorScreenState();
}

class _WaterTrashCollectorScreenState extends State<WaterTrashCollectorScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash Collector'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: SvgPicture.asset(
                'assets/stop.svg',
                height: 100,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/up.svg',
                    height: 60,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                        'assets/left.svg',
                        height: 60,
                      ),
                    ),
                    const SizedBox(width: 50),
                    // GestureDetector(
                    //   child: SvgPicture.asset(
                    //     'assets/stop.svg',
                    //     height: 50,
                    //   ),
                    // ),
                    const SizedBox(width: 50),
                    GestureDetector(
                      child: SvgPicture.asset(
                        'assets/right.svg',
                        height: 60,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/down.svg',
                    height: 60,
                  ),
                ),
              ],
            ),
            GestureDetector(
              child: SvgPicture.asset(
                'assets/trash.svg',
                height: 90,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
