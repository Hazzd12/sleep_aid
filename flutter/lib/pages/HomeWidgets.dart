import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sleep_aid/util/globalVar.dart';
import '../util/CustomizedUtils.dart';
import 'dart:async';

List<int> val = [1, 2, 3];

Widget buildConnectedWidget(
    double screenHeight, double screenWidth, State state) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        mySpace(screenHeight * 0.2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white),
          child: CustomizedText('Device Connected', font_color: Colors.green),
        ),
        mySpace(screenHeight * 0.1),
        CustomizedText('Sleep aid V1'),
        mySpace(screenHeight * 0.1),
        ElevatedButton(
          onPressed: () async {
            if(await startMonitoring()){
              Navigator.pushNamed(state.context, '/monitor');}
            else{
              print('fail to start, please check the device');
            }
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ),
          child: CustomizedText('START', font_color: Colors.red, font_size: 35),
        ),
        CustomizedText(val.toString())
      ],
    ),
  );
}

Widget buildDisconnectedWidget(
    double screenHeight, double screenWidth, State state) {
  return Center(
    child: Column(
      children: <Widget>[
        mySpace(screenHeight * 0.2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white),
          child: CustomizedText('No Device', font_color: Colors.red),
        ),
        mySpace(screenHeight * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomizedText('Click'),
            bluetoothButton(),
            CustomizedText('to find the device'),
            ElevatedButton(
              onPressed: () async {
                rr += isConnected.toString();
                checkBluetoothConnection(state);
                if(isConnected){
                  Navigator.popAndPushNamed(state.context, '/connected');
                }
                List<BluetoothDevice> list= [];
                // list = await FlutterBluePlus.systemDevices;
                // list+=FlutterBluePlus.connectedDevices;
                // list+=await FlutterBluePlus.bondedDevices;
                for(BluetoothDevice d in list){
                  rr += d.platformName.toString();
                }
                state.setState(() {

                });
              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(
                      12)), // => AppSettings.openAppSettings(type: AppSettingsType.location),
              child: const Icon(Icons.refresh),
            )
          ],
        ),
        mySpace(screenHeight * 0.1),
        ElevatedButton(
          onPressed: null, // 按钮禁用
          child:
              CustomizedText('START', font_color: Colors.grey, font_size: 35),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Colors.white; // 按钮可点击时的背景颜色，默认值
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget ConnectedMonitoringWidget(
    double screenHeight, double screenWidth, State state) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        mySpace(screenHeight * 0.2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white),
          child: CustomizedText('Device Connected', font_color: Colors.green),
        ),
        mySpace(screenHeight * 0.1),
        CustomizedText('Monitoring'),
        mySpace(screenHeight * 0.1),
        ElevatedButton(
          onPressed: () {
            stopMonitoring();
            isRunning = false;
            Navigator.pop(state.context);
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ),
          child: CustomizedText('STOP', font_color: Colors.red, font_size: 35),
        ),
      ],
    ),
  );
}

Widget DisconnectedMonitoringWidget(
    double screenHeight, double screenWidth, State state) {
  return Center(
    child: Column(
      children: <Widget>[
        mySpace(screenHeight * 0.2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white),
          child: CustomizedText('No Device', font_color: Colors.red),
        ),
        mySpace(screenHeight * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomizedText('Click'),
            bluetoothButton(),
            CustomizedText('to find the device'),

          ],
        ),
        mySpace(screenHeight * 0.1),
        ElevatedButton(
          onPressed: null, // 按钮禁用
          child: CustomizedText('STOP', font_color: Colors.grey, font_size: 35),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Colors.white; // 按钮可点击时的背景颜色，默认值
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Future<bool> startMonitoring() async {
  // List<int> data = [0x70,0x75,0x73];
  // print(write.properties.write);
  // if (write.properties.write) {
  //   await write.write(data, withoutResponse: false);
  //   isRunning = true;
  //     return true;
  // } else {
  //   print('No device detected');
  //   return false;
  // }
  isRunning = true;
  return true;
}

Future<void> stopMonitoring() async {
  List<int> data =[];
  if (characteristic != null) {
    await write?.write(data, withoutResponse: false);
  } else {
    print('No device detected');
  }
  if (characteristic!.properties.read) {
    List<int> value = await characteristic!.read();
    print(value);
    val = value;
  }
}
