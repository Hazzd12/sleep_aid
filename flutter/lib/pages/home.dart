import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'HomeWidgets.dart';
import '../util/CustomizedUtils.dart';
import 'dart:async';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final String _targetDeviceName = "esp32test";
  final String _targetServiceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String _targetCharacteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  bool isConnected = false;
  BoolWrapper isRunning = BoolWrapper(false);

  late BluetoothDevice localDevice;
  late final StreamSubscription<BluetoothConnectionState> _deviceStateSubscription;
  late BluetoothService localService;
  BluetoothCharacteristic? localCharacteristic;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _checkBluetoothConnection();
    });
  }

  _checkBluetoothConnection() async {
    List<BluetoothDevice> devices = FlutterBluePlus.connectedDevices;
    for (BluetoothDevice device in devices) {
      print(device.platformName);
      if (device.platformName == _targetDeviceName) {
        localDevice = device;
        monitorConnection(localDevice);
        setServiceAndChar(device);
        setState(() {
          isConnected = true;
        });
        return;
      }
    }

  }

  void monitorConnection(BluetoothDevice device) {
    _deviceStateSubscription = device.connectionState.listen((BluetoothConnectionState state) async{
      switch (state) {
        case BluetoothConnectionState.connected:
          setState(() {
            isConnected = true;
          });
          print("Device Connected");
          break;
        case BluetoothConnectionState.disconnected:
          print("Device Disconnected");
          setState(() {
            isConnected = false;
          });
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

  void setServiceAndChar(BluetoothDevice device) async{
    List<BluetoothService> services = await device.discoverServices();
    for(BluetoothService service in services){
      if(service.uuid.toString() == _targetServiceUuid){
        localService = service;
        for(BluetoothCharacteristic c in service.characteristics){
          if(c.uuid.toString() == _targetCharacteristicUuid){
            localCharacteristic = c;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _deviceStateSubscription.cancel();
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
        child:
            Column(
               children:[
                 isConnected? buildConnectedWidget(screenHeight, screenWidth, isRunning, localCharacteristic, this)
                     :buildDisconnectedWidget(screenHeight, screenWidth, isRunning, localCharacteristic, this),
                 mySpace(screenHeight*0.1),
                 ElevatedButton(//test Button
                   onPressed:(){
                     isConnected = !isConnected;
                     setState(() {
                     });
                   },
                   child:CustomizedText('test', font_size: 20, font_color: Colors.black),
                 )
               ]
            )
      ),
    );
  }
}

