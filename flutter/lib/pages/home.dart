import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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


  late BluetoothService localService;
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
            ElevatedButton(
              //test Button
              onPressed: () async {
                setState(() {

                });
                //Navigator.pushReplacementNamed(context, '/connected');
              },
              child: CustomizedText('test',
                  font_size: 20, font_color: Colors.black),
            ),
            CustomizedText('1230 $rr ')
          ])),
    );
  }
}
