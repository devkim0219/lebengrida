import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/data/login_auth.dart';
import 'package:lebengrida/screen/join_screen.dart';
import 'package:lebengrida/screen/home_screen.dart';
import 'package:lebengrida/screen/no_result_screen.dart';
import 'package:lebengrida/screen/result_screen.dart';
import 'package:lebengrida/screen/update_info_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginAuth>.value(
      value : LoginAuth(),
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
  bool _isCheckedPermission = false;

  String _mobile = '';

  final _focusNode = FocusScopeNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime currentBackPressTime;

  // 권한 체크
  Future<bool> _checkPermission() async {
    PermissionStatus storagePermissionStatus = await Permission.storage.status;
    PermissionStatus microphonePermissionStatus = await Permission.microphone.status;

    if (storagePermissionStatus == PermissionStatus.granted && microphonePermissionStatus == PermissionStatus.granted) {
      print('Storage and microphone permission is granted.');
      return true;
    } else {
      print('Storage and microphone permission is not granted.');
      return false;
    }
  }

  // 권한 요청
  Future<bool> _requestPermission() async {
    var storagePermissionResult = await Permission.storage.request();
    var microphonePermissionResult = await Permission.microphone.request();

    if (storagePermissionResult == PermissionStatus.granted && microphonePermissionResult == PermissionStatus.granted) {
      print('Storage and microphone permission is granted.');
      return true;
    } else {
      print('Storage and microphone permission is not granted.');
      return false;
    }
  }

  // 뒤로가기 버튼 두 번 터치 시 종료
  bool onPressBackButton() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text('뒤로가기 버튼을 한 번더 누르시면 종료됩니다.'))
        );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // 권한 체크
    _checkPermission().then((value) => _isCheckedPermission = value);
    
    // 권한 없을 시 요청
    if (!_isCheckedPermission) {
      _requestPermission().then((value) => _isCheckedPermission = value);
    }

    setState(() {
      _mobile = Provider.of<LoginAuth>(context).mobile;
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

    return FocusScope(
      node: _focusNode,
      child: WillPopScope(
        onWillPop: () async {
          bool result = onPressBackButton();
          return await Future.value(result);
        },
        child: Consumer<LoginAuth>(
          builder: (context, loginAuth, child) =>
            Scaffold(
              key: scaffoldKey,
              body: SafeArea(
                top: false,
                child: IndexedStack(
                    index: loginAuth.currentIndex,
                    children: loginAuth.isLogin ? _children2 : _children
                ),
              ),
              // loginAuth.isLogin ? _children2[_currentIndex] : _children[_currentIndex],
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
                selectedIndex: loginAuth.currentIndex,
                onSelectTab: (index) {
                  setState(() {
                    loginAuth.setCurrentIndex(index);
                  });
                },
                items: [
                  FFNavigationBarItem(
                    iconData: Icons.home,
                    label: '홈',
                  ),
                  loginAuth.isLogin
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
        ),
      ),
    );
  }
}