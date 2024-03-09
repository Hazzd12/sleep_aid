import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sleep_aid/util/globalVar.dart';

class BluetoothPage1 extends StatefulWidget {
  const BluetoothPage1({super.key});

  @override
  State<BluetoothPage1> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage1> {
  ///当前已经连接的蓝牙设备
  List<BluetoothDevice> _systemDevices = [];

  ///扫描到的蓝牙设备
  List<ScanResult> _scanResults = [];

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (error) {
      print('Scan Error:$error');
    });
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String name = '蓝牙';

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("蓝牙"),
      ),
      body: ListView(
        children: [
          ..._buildSystemDeviceTiles(),
          ..._buildScanResultTiles(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/monitor');
            },
            child: const Text('GO'),
          ),
          Text(name)
        ],
      ),
      floatingActionButton: FlutterBluePlus.isScanningNow
          ? FloatingActionButton(
              onPressed: () {
                FlutterBluePlus.stopScan();
              },
              backgroundColor: Colors.red,
              child: const Text("Stop"),
            )
          : FloatingActionButton(
              onPressed: () async {
                try {
                  _systemDevices = await FlutterBluePlus.systemDevices;
                  _systemDevices += await FlutterBluePlus.bondedDevices;
                  _systemDevices += FlutterBluePlus.connectedDevices;

                  print('dc-----_systemDevices$_systemDevices');
                } catch (e) {
                  print("Stop Scan Error:$e");
                }
                if (mounted) {
                  setState(() {});
                }
              },
              child: const Text("SCAN"),
            ),
    );
  }

  List<Widget> _buildSystemDeviceTiles() {
    return _systemDevices.map((device) {
      return ListTile(
        title: Text(device.platformName),
        subtitle: Text(device.advName.toString()),
        trailing: ElevatedButton(
          onPressed: () async {
            localDevice = device;
            setState(() {
              name = device.isConnected.toString() +
                  ' ' +
                  device.platformName.toString();
            });
            if (device.platformName.toString() == targetDeviceName) {
              await device.connect(timeout: Duration(hours: 1));
              Navigator.pushNamed(context, '/monitor');
            }
            else{
              name +="no name";
            }
          },
          child: const Text('CONNECT'),
        ),
      );
    }).toList();
  }

  List<Widget> _buildScanResultTiles() {
    return _scanResults
        .map(
          (scanResult) => ListTile(
            title: Text(
              scanResult.device.platformName,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              scanResult.device.remoteId.toString(),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  name = 'scanResult ' +
                      scanResult.device.isConnected.toString() +
                      ' ' +
                      scanResult.device.platformName.toString();
                });
              },
              child: const Text('CONNECT'),
            ),
          ),
        )
        .toList();
  }
}
