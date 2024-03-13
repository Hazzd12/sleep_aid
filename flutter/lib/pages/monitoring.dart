import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sleep_aid/pages/HomeWidgets.dart';
import '../util/globalVar.dart';
import '../util/CustomizedUtils.dart';

class MonitoringPage extends StatefulWidget {
  MonitoringPage({Key? key});

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {

  String information = '';
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startMonitoringConnection(timer, this);
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      /*appBar: AppBar(
        title: Text("bluetooth test"),
      ),*/
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          ConnectedMonitoringWidget(screenHeight, screenWidth, this),
          // ElevatedButton(
          //   //test Button
          //   onPressed: () async {
          //     //isConnected = !isConnected;
          //     setState(() {});
          //   },
          //   child:
          //       CustomizedText('test', font_size: 20, font_color: Colors.black),
          // ),

        ]),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }
}
