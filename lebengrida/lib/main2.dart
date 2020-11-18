import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/data/login_auth.dart';
import 'package:lebengrida/screen/join_screen.dart';
import 'package:lebengrida/screen/home_screen.dart';
import 'package:lebengrida/screen/no_result_screen.dart';
import 'package:lebengrida/screen/result_screen.dart';
import 'package:lebengrida/screen/update_info_screen.dart';
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
  int _currentIndex = 0;
  String _mobile = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      _mobile = Provider.of<JoinOrLogin>(context).mobile;
      print('_mobile -> $_mobile');
    });

    final List<Widget> _children = [
      HomePage(),
      JoinPage(),
      NoResultPage(),
      // Container()
    ];
    final List<Widget> _children2 = [
      HomePage(),
      UpdateInfoPage(mobile: _mobile),
      ResultPage(mobile: _mobile),
      // Container()
    ];

    return Consumer<JoinOrLogin>(
      builder: (context, joinOrLogin, child) =>
        Scaffold(
          body: joinOrLogin.isLogin ? _children2[_currentIndex] : _children[_currentIndex],
          bottomNavigationBar: FFNavigationBar(
            theme: FFNavigationBarTheme(
              barBackgroundColor: Colors.teal,
              selectedItemBorderColor: Colors.teal[300],
              selectedItemBackgroundColor: Colors.teal[400],
              unselectedItemIconColor: Colors.white,
              selectedItemLabelColor: Colors.white,
              unselectedItemLabelColor: Colors.white70,
              showSelectedItemShadow: false,
              itemWidth: 54,
              barHeight: 70,
            ),
            selectedIndex: _currentIndex,
            onSelectTab: (index) {
              print('_isLogin -> ${joinOrLogin.isLogin}');
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              FFNavigationBarItem(
                iconData: Icons.home,
                label: '홈',
              ),
              joinOrLogin.isLogin
                ? FFNavigationBarItem(
                    iconData: Icons.person,
                    label: '회원정보수정',
                  )
                : FFNavigationBarItem(
                    iconData: Icons.person,
                    label: '회원등록',
                  ),
              FFNavigationBarItem(
                iconData: Icons.search,
                label: '검사결과',
              ),
            ],
          ),
        ),
    );
  }
}