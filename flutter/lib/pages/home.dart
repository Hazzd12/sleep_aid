import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sleep_aid/util/decoder.dart';
import 'HomeWidgets.dart';
import '../util/CustomizedUtils.dart';
import '../util/globalVar.dart';
import 'dart:async';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {

  String devices1 = '';



  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
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
            buildDisconnectedWidget(screenHeight, screenWidth, this),
            mySpace(screenHeight * 0.1),
            //CustomizedText('1230 $rr ')
          ])),
    );
  }
}
