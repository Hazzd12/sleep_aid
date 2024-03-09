import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../util/PlatformService.dart';
import 'globalVar.dart';

// Customized Text
Widget CustomizedText(String txt,
    {double font_size = 24.0, //Named Parameters
    Color font_color = Colors.white,
    FontWeight font_Weight = FontWeight.bold}) {
  return Text(txt,
      style: TextStyle(
        fontSize: font_size,
        color: font_color,
        fontWeight: font_Weight,
      ));
}

Widget mySpace(double height) {
  return SizedBox(height: height);
}



ElevatedButton bluetoothButton() {
  return ElevatedButton(
    onPressed: (){
      SystemSettingsLauncher.openSystemSettings();
    },
    style: ElevatedButton.styleFrom(
        shape: CircleBorder(), padding: EdgeInsets.all(12)), // => AppSettings.openAppSettings(type: AppSettingsType.location),
    child: Icon(Icons.bluetooth),
  );
}

Future<bool> checkBluetoothConnection(State state) async {
  List<BluetoothDevice> devices = await FlutterBluePlus.systemDevices;
  devices += FlutterBluePlus.connectedDevices;
  devices += await FlutterBluePlus.bondedDevices;
  for (BluetoothDevice device in devices) {
    if (device.platformName.toString() == targetDeviceName) {
      if(!device.isConnected){
        try {
          await device.connect(timeout: Duration(hours: 1))
              .timeout(Duration(seconds: 3), onTimeout: () {
            device.disconnect();
            throw TimeoutException('Connecting to the device timed out');
          });
            await device.requestMtu(512);
          print('Device connected successfully');
        } on TimeoutException catch (e) {
          print(e.message);
        } catch (e) {
          print('Failed to connect: $e');
        };

      }
        state.setState(() {
          isConnected = true;
        });
      localDevice = device;
      return true;
    }
  }

  return false;

}

void setServiceAndChar(BluetoothDevice device) async {
  List<BluetoothService> services = await device.discoverServices();
  for (BluetoothService service in services) {
    if (service.uuid.toString() == targetServiceUuid) {
      localService = service;
      bool flag1 =false;
      bool flag2 = false;
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.uuid.toString() == targetCharacteristicUuid) {
          characteristic = c;
          flag1 = true;
        }
        if (c.uuid.toString() == targetWriteCharacteristicUuid) {
          write = c;
          flag2 = true;
        }
      }

      if(flag1 && flag2){
        isGetChara = true;
      }
    }
  }
}

