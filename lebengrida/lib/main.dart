import 'package:flutter/material.dart';
import 'package:lebengrida/screens/guide.dart';
import 'package:lebengrida/screens/animation.dart';
import 'package:lebengrida/screens/join.dart';
import 'package:lebengrida/screens/login.dart';
import 'package:lebengrida/screens/question.dart';
import 'package:lebengrida/screens/result.dart';
import 'package:lebengrida/screens/userList.dart';
import 'package:lebengrida/screens/update_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List qData;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        '/animation': (context) => AnimationPage(),
        '/question': (context) => QuestionPage(),
        '/guide': (context) => GuidePage(),
        '/result': (context) => ResultPage(),
      },
    );
  }
}