

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

final String targetDeviceName1 = 'HC-05';
final String targetDeviceName2 = 'HC-05 ';
final String targetServiceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
final String targetCharacteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
final String targetWriteCharacteristicUuid ="beb5483e-36e1-4688-b7f6-ea07361b26a9";

BluetoothDevice? localDevice;
BluetoothState bluetoothState = BluetoothState.UNKNOWN;
FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
late BluetoothConnection connection;
late var subscription;

Uint8List receivedMes = Uint8List.fromList([72, 101, 108, 108, 111]);
double amoutBre = 0;
double count =0;


bool isConnected = false;
bool isRunning = false;
bool isConnecting = false;
bool isReport = false;

List<String> realTime = ['IN','NOBODY','AWAKE',''];
List<String> report = ['','0','0','0','0','0','0',''];


double frequency = 0;

class PieData {
  PieData(this.xData, this.yData, this.percentage, [this.text]);
  String xData;
  num yData;
  Color? text;
  double percentage;
}

List<PieData> pieData = [
  PieData('Deep Sleep', 25, 12.1,  Color.fromRGBO(9,0,136,1)),
  PieData('Light Sleep', 38, 56.2, Color.fromRGBO(147,0,119,1)),
  PieData('Awake', 34, 30.1, Color.fromRGBO(228,0,124,1))
];
