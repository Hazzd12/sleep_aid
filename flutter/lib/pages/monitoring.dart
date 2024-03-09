import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sleep_aid/pages/HomeWidgets.dart';
import '../util/globalVar.dart';
import '../util/CustomizedUtils.dart';


class MonitoringPage extends StatefulWidget {

  MonitoringPage({Key? key});

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage>{
  late final StreamSubscription<BluetoothConnectionState>
  _deviceStateSubscription;
  late final subscription;
  String information = '';

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setListener();
    monitorConnection();
  }
  Future<void> setListener() async {
     subscription =characteristic.onValueReceived.listen((value) async {
       print('stream $value');
       setState(() {
        information = 'received $value';
       });
     });
     characteristic.setNotifyValue(true).then((_) {
       // 可以在这里处理通知启用后的逻辑，比如更新UI提示用户
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
          child:
          Column(
              children:[
                isConnected? ConnectedMonitoringWidget(screenHeight, screenWidth, this)
                    :DisconnectedMonitoringWidget(screenHeight, screenWidth, this),
                mySpace(screenHeight*0.1),
                ElevatedButton(//test Button
                  onPressed:() async {
                    //isConnected = !isConnected;
                    print('test ${characteristic.properties.notify}');
                    setState(() {
                    });
                  },
                  child:CustomizedText('test', font_size: 20, font_color: Colors.black),
                ),
                CustomizedText('info'),
                CustomizedText('1 $information', font_size: 12)
              ]
          ),

      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    localDevice?.cancelWhenDisconnected(subscription);
    _deviceStateSubscription.cancel();
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
}



