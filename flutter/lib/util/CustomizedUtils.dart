import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../util/PlatformService.dart';
import 'globalVar.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// Customized Text
Widget CustomizedText(String txt,
    {double font_size = 24.0, //Named Parameters
    Color font_color = Colors.white,
    FontWeight font_Weight = FontWeight.bold}) {
  return Text(txt,
      softWrap: true,
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
    onPressed: () {
      SystemSettingsLauncher.openSystemSettings();
    },
    style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(
            12)), // => AppSettings.openAppSettings(type: AppSettingsType.location),
    child: Icon(Icons.bluetooth),
  );
}

Future<bool> checkBluetoothConnection(State state) async {
  List<BluetoothDevice> devices = [];

  try {
    devices = await bluetooth.getBondedDevices();
    for (BluetoothDevice b in devices) {
    }
  } catch (e) {
    print('abc $e');
    return false;
  }
  bool flag = await tryToConnect(state);
  return flag;
}

Future<bool> tryToConnect(State state) async {
  try {
    state.setState(() {
      isConnecting = true;
    });
    final List<BluetoothDevice> pairedDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    for (BluetoothDevice d in pairedDevices) {
      print('name ${d.name}');
      if (d.name == targetDeviceName1 || d.name == targetDeviceName2) {

        await BluetoothConnection.toAddress(d.address).then((_connection) {
          print('Connected to the device');
          connection = _connection;
          state.setState(() {
            isConnected = true;
            isConnecting = false;
          });
          localDevice = d;
        }).catchError((error) {
          print('Home Cannot connect, exception occured');
          print(error);
        });
      }
    }
    if (localDevice != null) {
      print('找到了特定名字的蓝牙设备');
      print(connection.isConnected);
      return true;
      // 在这里你可以根据需要添加更多的逻辑，例如尝试连接设备
    } else {
      state.setState(() {
        isConnecting = false;
      });
      print('失败: 没有找到特定名字的蓝牙设备1');
      return false;
    }
  } catch (e) {
    print('检查连接时发生错误: $e');
    return false;
  }
}

void startMonitoringConnection(Timer? timer, State state) {
  timer = Timer.periodic(Duration(seconds: 3), (timer) async {
    if (bluetoothState == BluetoothState.STATE_ON) {
      try {
        final List<BluetoothDevice> pairedDevices =
            await FlutterBluetoothSerial.instance.getBondedDevices();
        for (BluetoothDevice d in pairedDevices) {
          if (d.name == targetDeviceName1 || d.name == targetDeviceName2) {

            if (!d.isConnected) {
              localDevice = d;
              isConnected = false;

            }
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      isConnected = false;
    }

    if(!isConnected){
      if (isRunning) {
        Navigator.pushNamed(state.context, '/disMonitor');
      } else {
        Navigator.popAndPushNamed(state.context, '/home');
      }
      // 可以在这里执行重连逻辑或其他处理
      timer.cancel(); // 如果设备断开连接，停止定时器
    }
  });
}
