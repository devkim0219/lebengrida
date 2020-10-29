import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/screens/animation.dart';
import 'package:lebengrida/screens/result.dart';
import 'package:lebengrida/screens/update_info.dart';
import 'package:lebengrida/services/login_service.dart';
import 'package:lebengrida/services/result_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DateTime currentBackPressTime;
  TextEditingController _mobileController;

  final _focusNode = FocusScopeNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  // 회원 등록 여부 체크
  _checkUser(String mobile) {
    if (_mobileController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: '휴대폰 번호를 입력해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3
      );
      return;
    }

    LoginServices.checkUser(mobile).then((result) {
      if (result == 'success') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnimationPage(mobile: mobile),
          )
        );
      } else {
        Fluttertoast.showToast(
          msg: '등록된 사용자가 아닙니다. 회원등록 후 이용해주세요.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
      }
    });
  }

  // 기존 검사 여부 체크
  _checkTested(String mobile) {
    if (_mobileController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: '휴대폰 번호를 입력해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3
      );
      return;
    }

    ResultServices.checkTested(mobile).then((result) {
      print('result is $result');
      
      if (result == 'success') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultPage(mobile: mobile),
          )
        );
      } else {
        Fluttertoast.showToast(
          msg: '검사한 내역이 없습니다. 검사를 진행한 후에 결과를 보실 수 있습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: FocusScope(
        node: _focusNode,
        child: WillPopScope(
          onWillPop: () async {
            bool result = onPressBackButton();
            return await Future.value(result);
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text('스마트 스피치(S-Speech)')),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        '스마트 화행 검사',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.teal,
                        )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: TextField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          hintText: '휴대폰 번호를 입력하세요.'
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            color: Colors.teal,
                            child: Text('회원 등록', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/join');
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RaisedButton(
                            color: Colors.teal,
                            child: Text('검사 시작', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              _checkUser(_mobileController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child:RaisedButton(
                        color: Colors.teal,
                        child: Text('회원 정보 수정(Test)', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (_mobileController.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: '휴대폰 번호를 입력해주세요.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3
                            );
                            return;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateInfoPage(mobile: _mobileController.text)
                            )
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child:RaisedButton(
                        color: Colors.teal,
                        child: Text('회원 목록(Test)', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/userList');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child:RaisedButton(
                        color: Colors.teal,
                        child: Text('검사 결과(Test)', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _checkTested(_mobileController.text);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ) 
      ),
    ); 
  }
}