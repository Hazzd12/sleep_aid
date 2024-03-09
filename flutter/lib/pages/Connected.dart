


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../util/CustomizedUtils.dart';
import '../util/globalVar.dart';
import 'HomeWidgets.dart';

class ConnectedPage extends StatefulWidget {

  ConnectedPage({Key? key});

  @override
  _ConnectedPageState createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {

  String devices1 = '';
  late BluetoothService localService;
  BluetoothCharacteristic? localCharacteristic;
  late final StreamSubscription<BluetoothConnectionState>
  _deviceStateSubscription;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    monitorConnection();
    setServiceAndChar(localDevice!);
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
            ElevatedButton(
              //test Button
              onPressed: () {
                //isConnected = !isConnected;
                setState(() {});
                print('home ${characteristic.properties.notify}');
               // Navigator.pushReplacementNamed(context, '/home');
              },
              child: CustomizedText('test',
                  font_size: 20, font_color: Colors.black),
            ),
            CustomizedText('1230$rr')
          ])),
    );
  }

  void monitorConnection() {
    _deviceStateSubscription =
        localDevice!.connectionState.listen((BluetoothConnectionState state) async {
          switch (state) {
            case BluetoothConnectionState.connected:
              setState(() {
                isConnected = true;
              });
              print("Device Connected");
              break;
            case BluetoothConnectionState.disconnected:
              print("Device Disconnected");
              isConnected = false;
              if(!isRunning){
                print('running $isRunning');
                Navigator.pushNamed(context, '/home');
              }
              break;
            default:
              print("1Device Disconnected");
              setState(() {
                isConnected = false;
              });
              break;
          }
        });
  }
}