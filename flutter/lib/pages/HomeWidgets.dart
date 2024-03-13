import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sleep_aid/util/globalVar.dart';
import '../util/CustomizedUtils.dart';
import 'dart:async';


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
              await startMonitoring();
              Navigator.pushNamed(state.context, '/monitor');
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ),
          child: CustomizedText('START', font_color: Colors.red, font_size: 35),
        )
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
          child: isConnecting? CustomizedText('Connecting', font_color: Colors.yellow)
              :CustomizedText('No Device', font_color: Colors.red),
        ),
        mySpace(screenHeight * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomizedText('Click'),
            bluetoothButton(),
            CustomizedText('to find'),
            ElevatedButton(
              onPressed: () async {
                await checkBluetoothConnection(state);
                if(isConnected){
                  state.setState(() {});
                  Navigator.popAndPushNamed(state.context, '/connected');
                }

              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(12)), // => AppSettings.openAppSettings(type: AppSettingsType.location),
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
        mySpace(screenHeight * 0.05),
        CustomizedText('Monitoring'),
        mySpace(screenHeight*0.05),
        Container(
            width: 280,
            height: 180,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
                color: Color.fromRGBO(255,255,255,0.2)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [Icon(Icons.location_on, size:30, color: Colors.white,),
                      CustomizedText(':   ', font_color: Colors.white),
                      CustomizedText(' ${realTime[0]}'),],
                  ),
                  mySpace(10),
                  Row(
                    children: [Icon(Icons.face, size:30, color: Colors.white,),
                      CustomizedText(':   ', font_color: Colors.white),
                      CustomizedText(' ${realTime[1]}')],
                  ),
                  mySpace(10),
                  Row(
                    children: [Icon(Icons.bed, size:30, color: Colors.white,),
                      CustomizedText(':   ', font_color: Colors.white),
                      CustomizedText(' ${realTime[2]}'),],
                  ),
                  mySpace(10),
                  Row(
                    children: [Icon(Icons.air, size:30, color: Colors.white,),
                      CustomizedText(':   ', font_color: Colors.white),
                      CustomizedText(' ${realTime[3]}'),],
                  ),
                ])),
        mySpace(screenHeight * 0.1),
        ElevatedButton(
          onPressed: () {
            stopMonitoring();
            isRunning = false;
            isReport = true;
            Navigator.popAndPushNamed(state.context, '/report');
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
          child:  isConnecting? CustomizedText('Connecting', font_color: Colors.yellow):
          CustomizedText('No Device', font_color: Colors.red),
        ),
        mySpace(screenHeight * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomizedText('Click'),
            bluetoothButton(),
            CustomizedText('to find '),
            ElevatedButton(
              onPressed: () async {
                await checkBluetoothConnection(state);
                if(isConnected){
                  state.setState(() {});
                  Navigator.popAndPushNamed(state.context, '/monitor');
                }

              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(12)), // => AppSettings.openAppSettings(type: AppSettingsType.location),
              child: const Icon(Icons.refresh),
            )
          ],
        ),
        mySpace(screenHeight * 0.05),
        Container(
            width: 280,
            height: 180,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
                color: Color.fromRGBO(255,255,255,0.2)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [Icon(Icons.location_on, size:30, color: Colors.white,),
                      CustomizedText(':     ----', font_color: Colors.white),],
                  ),
                  mySpace(10),
                  Row(
                    children: [Icon(Icons.people, size:30, color: Colors.white,),
                      CustomizedText(':     ----', font_color: Colors.white),],
                  ),
                  mySpace(10),
                  Row(
                    children: [Icon(Icons.bed, size:30, color: Colors.white,),
                      CustomizedText(':     ----', font_color: Colors.white),],
                  ),
                  mySpace(10),
                  Row(
                    children: [Icon(Icons.air, size:30, color: Colors.white,),
                      CustomizedText(':     ----', font_color: Colors.white),],
                  ),
                ])),
        mySpace(screenHeight*0.1),
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

Future<void> startMonitoring() async {
  print("123456");
  Uint8List dataToSend = Uint8List.fromList("START".codeUnits);
  connection.output.add(dataToSend);
  print(dataToSend);
  await connection.output.allSent;
  isRunning =true;
  amoutBre = 0;
  count = 0;
}

Future<void> stopMonitoring() async {
  Uint8List dataToSend = Uint8List.fromList("STOP".codeUnits);
  connection.output.add(dataToSend);
  if(count !=0) {
    report[0] = (amoutBre / count).toString();
  }
  else{
    report[0] ='0';
  }
// 如果需要，确保调用flush来确保数据被发送
  await connection.output.allSent;
  isRunning = false;

}
