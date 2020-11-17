import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/data/join_or_login.dart';
import 'package:lebengrida/screen/join_screen.dart';
import 'package:lebengrida/screen/home_screen.dart';
import 'package:lebengrida/screen/result_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JoinOrLogin>.value(
      value : JoinOrLogin(),
      child: MaterialApp(
        title: '스마트 화행 검사 - 레벤그리다',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: '스마트 스피치(S-Speech)'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _children = [
    HomePage(),
    JoinPage(),
    ResultPage(),
    // Container()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.teal[400],
          selectedItemBorderColor: Colors.teal[300],
          selectedItemBackgroundColor: Colors.teal[400],
          unselectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.white,
          unselectedItemLabelColor: Colors.white54,
          showSelectedItemShadow: false,
          itemWidth: 54,
          barHeight: 70,
        ),
        selectedIndex: _currentIndex,
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: '홈',
          ),
          FFNavigationBarItem(
            iconData: Icons.person,
            label: '회원등록',
          ),
          FFNavigationBarItem(
            iconData: Icons.search,
            label: '검사결과',
          ),
        ],
      ),
    );
  }
}