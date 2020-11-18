import 'package:flutter/material.dart';
import 'package:lebengrida/screen/guide.dart';
import 'package:lebengrida/screen/animation.dart';
import 'package:lebengrida/screen/join.dart';
import 'package:lebengrida/screen/login.dart';
import 'package:lebengrida/screen/question.dart';
import 'package:lebengrida/screen/result.dart';
import 'package:lebengrida/screen/userList.dart';
import 'package:lebengrida/screen/update_info.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 마이크 및 저장소 권한 체크
  Future<bool> _checkPermission() async {
    PermissionStatus storagePermissionStatus = await Permission.storage.status;
    PermissionStatus microphonePermissionStatus = await Permission.microphone.status;

    if (storagePermissionStatus == PermissionStatus.granted && microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  // 마이크 및 저장소 권한 요청
  Future<bool> _requestPermission() async {
    var storagePermissionResult = await Permission.storage.request();
    var microphonePermissionResult = await Permission.microphone.request();

    if (storagePermissionResult == PermissionStatus.granted && microphonePermissionResult == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool _isGrantedPermission = false;

    // 권한 체크
    _checkPermission().then((value) {
      _isGrantedPermission = value;
      print('Granted Storage and Microphone Permission : $_isGrantedPermission');
    });

    // 권한 거부 시 요청
    if (!_isGrantedPermission) {
      _requestPermission().then((value) {
        _isGrantedPermission = value;
      });
    }

    return MaterialApp(
      title: '스마트 화행 검사 - 레벤그리다',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/join': (context) => JoinPage(),
        '/updateInfo': (context) => UpdateInfoPage(mobile: ''),
        '/userList': (context) => UserListPage(),
        '/animation': (context) => AnimationPage(mobile: ''),
        '/question': (context) => QuestionPage(mobile: ''),
        '/guide': (context) => GuidePage(mobile: ''),
        '/result': (context) => ResultPage(mobile: ''),
      },
    );
  }
}