


import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sleep_aid/util/decoder.dart';
import '../util/CustomizedUtils.dart';
import '../util/globalVar.dart';
import 'HomeWidgets.dart';

class ConnectedPage extends StatefulWidget {

  ConnectedPage({Key? key});

  @override
  _ConnectedPageState createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {
  Timer? timer;

  Future<void> setListener() async {
    subscription = connection.input?.listen((Uint8List data) {
      // 处理接收到的数据
      String receivedData = String.fromCharCodes(data);
      print(receivedData);
      receivedData = receivedData.replaceAll(RegExp(r'\n|\r'), '');
      if(isRunning) {
        if(receivedData.isNotEmpty && receivedData[0] == "2"){
          String sub = receivedData.substring(1);
          realTimeDecoder(sub);
          reportDecoder(sub);
          print("now: ${realTime}");
        }
        else if(receivedData.length>=3&&receivedData.substring(0,3) == "r_r:"){
          realTime[3] = receivedData.substring(4);
          amoutBre += double.parse(receivedData.substring(4));
          count++;
        }
      }
    });
    subscription.onDone(() {print('remotely disconect');});
  }


  void stopMonitoringConnection() {
    timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startMonitoringConnection(timer, this);
    setListener();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
    connection.dispose();

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
            buildConnectedWidget(screenHeight, screenWidth, this),
            mySpace(screenHeight * 0.1),
          ])),
    );
  }



}