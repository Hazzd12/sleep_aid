import 'package:flutter/material.dart';
import 'package:sleep_aid/pages/Connected.dart';
import 'package:sleep_aid/pages/test.dart';
import 'package:sleep_aid/util/CustomizedUtils.dart';
import 'package:sleep_aid/util/globalVar.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
        onGenerateRoute: (settings)
    {
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
      }
    }
    );
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

    _controller = VideoPlayerController.asset("assets/landing.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _initializeVideoPlayerFuture.then((_) {
      _controller.play();
      // 检查视频是否已结束，并在适当时进行跳转
      _controller.addListener(() async {
        if (_controller.value.position >= _controller.value.duration
            && !_controller.value.isPlaying) {
            rr += i.toString();
            i++;
            await _checkBluetooth(this);
            if(isConnected) {
              Navigator.pushNamed(context, '/connected');
            }
            else{
              Navigator.pushNamed(context, '/home');
            }
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
    if(await checkBluetoothConnection(state)) {
      setState(() {
        isConnected = true;
      });
    }
  }



}


