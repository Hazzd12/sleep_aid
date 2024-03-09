

import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

final String targetDeviceName = 'RadarDat';
final String targetServiceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
final String targetCharacteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
final String targetWriteCharacteristicUuid ="beb5483e-36e1-4688-b7f6-ea07361b26a9";
late BluetoothCharacteristic characteristic;
late BluetoothService localService;
late BluetoothDevice? localDevice;
late BluetoothCharacteristic write;

bool isConnected = false;
bool isRunning = false;
bool isGetChara = false;
String rr = '';