import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:new_medi/calander.dart';
import 'package:new_medi/takePicture.dart';
import 'package:new_medi/camera_example_home.dart';

import 'Upload.dart';
import 'camera_app.dart';
import 'dashbord.dart';
import 'fetch.dart';
import 'fetch1.dart';
import 'login.dart';
import 'questions.dart';
import 'trakOrder.dart';

List<CameraDescription> _cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MyWidget(cameras: _cameras));
}

class MyWidget extends StatefulWidget {
  final cameras;

  const MyWidget({super.key, this.cameras});

  @override
  State<MyWidget> createState() => _MyWidgetState(cameras: _cameras);
}

class _MyWidgetState extends State<MyWidget> {
  final cameras;

  _MyWidgetState({this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(
                builder: (_) => const MyLoginPage(
                      title: 'chathura',
                    ));
          } else if (settings.name == '/dashboard') {
            return MaterialPageRoute(builder: (_) => const DashBoard());
          } else if (settings.name == '/upload') {
            return MaterialPageRoute(builder: (_) => const Upload());
          } else if (settings.name == '/questions') {
            return MaterialPageRoute(builder: (_) => const Questions());
          } else if (settings.name == '/booking') {
            return MaterialPageRoute(builder: (_) => const Booking());
          } else if (settings.name == '/trakOrder') {
            return MaterialPageRoute(builder: (_) => const TrakOrder());
          } else if (settings.name == '/cam') {
            return MaterialPageRoute(
                builder: (_) => CameraApp(cameras: _cameras));
          } else {
            return null;
          }
        },
      ),
    );
  }
}

// return MaterialPageRoute(builder: (_) => const MyApp());
            // return MaterialPageRoute(builder: (_) => const DashBoard());