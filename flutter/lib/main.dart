import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sleep_aid/pages/Connected.dart';
import 'package:sleep_aid/pages/disconnectedMonitoring.dart';
import 'package:sleep_aid/pages/report.dart';
import 'package:sleep_aid/util/CustomizedUtils.dart';
import 'package:sleep_aid/util/globalVar.dart';
import 'package:video_player/video_player.dart';
import 'pages/home.dart';
import 'pages/monitoring.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the `routes` map
        initialRoute: '/',
        onGenerateRoute: (settings) {
          // Check the name of the route
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => VideoSplashScreen());
            case '/home':
              return MaterialPageRoute(builder: (_) => BluetoothPage());
            case '/connected':
              return MaterialPageRoute(builder: (_) => ConnectedPage());
            case '/monitor':
              return MaterialPageRoute(builder: (_) => MonitoringPage());
            case '/disMonitor':
              return MaterialPageRoute(builder: (_) => DisMonitoringPage());
            case '/report' :
              return MaterialPageRoute(builder: (_) => ReportPage());
          }
        });
  }
}

class VideoSplashScreen extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  int i = 995;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      precacheImage(AssetImage('assets/background.png'), context);
    });
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        bluetoothState = state;
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothState = state;
      });
    });

    _controller = VideoPlayerController.asset("assets/landing.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _initializeVideoPlayerFuture.then((_) {
      _controller.play();
      _checkBluetooth(this);
      // 检查视频是否已结束，并在适当时进行跳转
      _controller.addListener(() async {
        if (_controller.value.position >= _controller.value.duration &&
            !_controller.value.isPlaying) {
          if (isConnected) {
            Navigator.pushNamed(context, '/connected');
          } else {
            Navigator.pushNamed(context, '/home');
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    connection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 视频加载完成，显示视频播放器
          return Scaffold(
            body: Center(
              child: Container(
                width: double.infinity, // 宽度填满父容器
                height: double.infinity, // 高度填满父容器
                child: VideoPlayer(_controller), // 视频播放器，不考虑宽高比
              ),
            ),
          );
        } else {
          // 视频正在加载，显示加载指示器
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> _checkBluetooth(State state) async {
    if (await Permission.bluetoothConnect.request() !=
        PermissionStatus.granted) {
      // 权限请求被拒绝，处理拒绝情况
      print("BLUETOOTH_CONNECT permission denied");
    } else {
      // 权限被授予
      print("BLUETOOTH_CONNECT permission granted");
    }


    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      print("定位权限已授予");
      // 权限已被授予，可以继续操作
    } else {
      print("定位权限被拒绝");
      // 处理权限被拒绝的情况
    }

    if (bluetoothState == BluetoothState.STATE_ON) {
      print('${await Permission.bluetoothConnect.request()}');
      tryToConnect(state);

    } else {
      print(bluetoothState);
      print('蓝牙未开启');
      FlutterBluetoothSerial.instance
          .requestEnable()
          .then((_) {})
          .catchError((e) {
        //
      });
    }
  }
}
