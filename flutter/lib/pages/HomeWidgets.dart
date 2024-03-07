import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../util/CustomizedUtils.dart';
import '../util/PlatformService.dart';
import 'dart:async';

List<int> val =[1,2,3];

Widget buildConnectedWidget(double screenHeight, double screenWidth,
    BoolWrapper isRunning, BluetoothCharacteristic? c, State state) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        mySpace(screenHeight*0.2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white
          ),
          child: CustomizedText('Device Connected', font_color: Colors.green),
        ),
        mySpace(screenHeight*0.1),
        isRunning.getVal()?CustomizedText('Monitoring'):CustomizedText('Sleep aid V1'),
        mySpace(screenHeight*0.1),
        ElevatedButton(
          onPressed: () {
            isRunning.getVal()?
              stopMonitoring(isRunning, c):
              startMonitoring(isRunning, c);
            state.setState(() {});
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ),
          child: isRunning.getVal()?
            CustomizedText('STOP',font_color: Colors.red, font_size: 35):
            CustomizedText('START',font_color: Colors.red, font_size: 35),
        ),
        CustomizedText(val.toString())
      ],
    ),
  );
}

Widget buildDisconnectedWidget(double screenHeight, double screenWidth,
    BoolWrapper isRunning, BluetoothCharacteristic? c, State state) {
  return Center(
    child: Column(
      children: <Widget>[
        mySpace(screenHeight*0.2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white
          ),
          child: CustomizedText('No Device', font_color: Colors.red),
        ),
        mySpace(screenHeight*0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomizedText('Click'),
            ElevatedButton(
              onPressed: (){
                SystemSettingsLauncher.openSystemSettings();
              },// => AppSettings.openAppSettings(type: AppSettingsType.location),
              child: Icon(Icons.bluetooth),
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(12)
              ),
            ),
            CustomizedText('to find the device'),
          ],
        ),
        mySpace(screenHeight*0.1),
        ElevatedButton(
          onPressed:null, // 按钮禁用
          child: isRunning.getVal()?CustomizedText('STOP',font_color: Colors.grey, font_size: 35)
          :CustomizedText('START',font_color: Colors.grey, font_size: 35),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ).copyWith(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return Colors.white; // 按钮可点击时的背景颜色，默认值
            },),
          ),),

      ],
    ),
  );
}


Future<void> startMonitoring(BoolWrapper isRunning, BluetoothCharacteristic? c) async {
  isRunning.setVal(true);
  List<int> data = [];
  if(c!=null) {
    await c.write(data);
  }
  else{
    print('No device detected');
  }
}

Future<void> stopMonitoring(BoolWrapper isRunning, BluetoothCharacteristic? c) async {
  isRunning.setVal(false);
  if (c!.properties.read) {
    List<int> value = await c.read();
    print(value);
    val = value;
  }
}