import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sleep_aid/pages/HomeWidgets.dart';
import '../util/globalVar.dart';
import '../util/CustomizedUtils.dart';

class DisMonitoringPage extends StatefulWidget {
  DisMonitoringPage({Key? key});

  @override
  _DisMonitoringPageState createState() => _DisMonitoringPageState();
}

class _DisMonitoringPageState extends State<DisMonitoringPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          DisconnectedMonitoringWidget(screenHeight, screenWidth, this),
          mySpace(screenHeight * 0.1),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
