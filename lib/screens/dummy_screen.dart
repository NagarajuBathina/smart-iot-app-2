import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_iot_app2/app/constants.dart';
import 'package:smart_iot_app2/app/extensions.dart';

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  final String docPath = "home/IjBn0aZifjzlmUij2EMu";

  int? dummy;
  int? lastDummyValue;
  DateTime lastDummyChangeTime = DateTime.now();
  bool deviceOnline = false;

  Timer? heartbeatTimer;

  @override
  void initState() {
    super.initState();
    // 🔥 Check device status every 1 second
    heartbeatTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = DateTime.now().difference(lastDummyChangeTime);

      // If dummy didn't change for 5 seconds → offline
      bool nowOnline = diff.inSeconds < 10;

      print(nowOnline);

      if (nowOnline != deviceOnline) {
        setState(() {
          deviceOnline = nowOnline;
          FirebaseFirestore.instance.doc(docPath).update({'is_wifi': false});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F1A),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.doc(docPath).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.tealAccent),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            bool relay1 = data["relay1"] ?? false;
            bool relay2 = data["relay2"] ?? false;
            dummy = data["dummy"] ?? 0;

            // FIRESTORE STREAM → TRACK HEARTBEAT CHANGE
            // ----------------------------------------------------
            if (lastDummyValue == null || lastDummyValue != dummy) {
              lastDummyValue = dummy;
              lastDummyChangeTime = DateTime.now();
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Smart Home Control",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: mWhiteColor),
                      ),
                      Icon(Icons.wifi,
                          color: deviceOnline ? mWhiteColor : Colors.grey[800])
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFuturisticCard(
                      title: "Light 1",
                      status: relay1,
                      onToggle: () {
                        if (deviceOnline) {
                          _update("relay1", !relay1);
                        } else {
                          context.showError('Device not connected');
                        }
                      }),
                  const SizedBox(height: 25),
                  _buildFuturisticCard(
                      title: "Light 2",
                      status: relay2,
                      onToggle: () {
                        if (deviceOnline) {
                          _update("relay2", !relay2);
                        } else {
                          context.showError('Device not connected');
                        }
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  Future<void> _update(String field, bool value) async {
    await FirebaseFirestore.instance.doc(docPath).update({field: value});
  }

  // ----------------------------------------------------------
  Widget _buildFuturisticCard({
    required String title,
    required bool status,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF131629), Color(0xFF0D0F1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: status ? Colors.tealAccent.withOpacity(.4) : Colors.black54,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: status ? Colors.tealAccent : Colors.grey,
            size: 40,
          ),
          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status ? "ON" : "OFF",
                  style: TextStyle(
                    color: status ? Colors.tealAccent : Colors.redAccent,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Toggle Button
          InkWell(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: status
                    ? Colors.tealAccent.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: status ? 35 : 5,
                    top: 5,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status ? Colors.tealAccent : Colors.redAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
