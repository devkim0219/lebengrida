import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/screen/guide.dart';
import 'package:lebengrida/service/login_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _focusNode = FocusScopeNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime currentBackPressTime;
  TextEditingController _mobileController;

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
  Future<String> _checkUser(String mobile) async {
    var _result = '';
    await LoginServices.checkUser(mobile).then((result) {
      _result = result;
    });
    return _result;
  }

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
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
                      SizedBox(height: 50),
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                      SizedBox(height: 60),
                      Text(
                        '스마트 화행 검사',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 60),
                      TextField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          hintText: '휴대폰 번호를 입력하세요.'
                        ),
                      ),
                      SizedBox(height: 35),
                      RaisedButton(
                        color: Colors.teal,
                        child: Text('로그인', style: TextStyle(color: Colors.white)),
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
                          _checkUser(_mobileController.text).then((value) {
                            if (value == 'success') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GuidePage(mobile: _mobileController.text),
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: '등록된 사용자가 아닙니다. 회원등록 후 이용해주세요.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3
                              );
                              return;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
