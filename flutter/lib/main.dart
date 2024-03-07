import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'pages/home.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => VideoSplashScreen(),
        '/second': (context) => BluetoothPage(),
      },
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
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration
            && !_controller.value.isPlaying) {
          // 视频播放结束后，等待5秒
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushNamed(context, '/second'); // 跳转到另一个页面
          });
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
}

