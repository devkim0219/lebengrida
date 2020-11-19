import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/data/login_auth.dart';
import 'package:lebengrida/model/result_data.dart';
import 'package:lebengrida/model/user_data.dart';
import 'package:lebengrida/screen/guide_screen.dart';
import 'package:lebengrida/service/login_service.dart';
import 'package:lebengrida/service/result_service.dart';
import 'package:lebengrida/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _focusNode = FocusScopeNode();

  TextEditingController _mobileController;

  // 회원 등록 여부 체크
  Future<String> _checkUser(String mobile) async {
    var _result = '';
    await LoginServices.checkUser(mobile).then((result) {
      _result = result;
    });
    return _result;
  }

  // 각 회원 정보 조회
  Future<User> _getUserInfo(String mobile) async {
    var _user;
    await UserServices.getUserInfo(mobile).then((user) {
      _user = user;
    });
    return _user;
  }

  // 각 회원별 검사 결과 정보 조회
  Future<Result> _getUserResult(String mobile) async {
    var _result;
    await ResultServices.getUserResult(mobile).then((result) {
      _result = result;
    });
    return _result;
  }

  // 최근 검사일이 6개월 지났는지 체크
  bool _checkLatestTest(String testDate) {
    bool _isRetest = false;
    DateTime _latestTestDate = DateTime.parse(testDate);
    DateTime _currentDate = DateTime.now();

    var _differenceDay = _currentDate.toUtc().difference(_latestTestDate).inDays;

    if (_differenceDay >= 180) {
      _isRetest = true;
    }

    return _isRetest;
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
          child: Scaffold(
            appBar: AppBar(title: Text('스마트 스피치(S-Speech)')),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    SizedBox(height: 60),
                    Text(
                      '스마트 화행 검사',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.teal[800],
                      ),
                    ),
                    SizedBox(height: 50),
                    Consumer<LoginAuth>(
                      builder: (context, loginAuth, child) =>
                      loginAuth.isLogin
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loginAuth.testDate.startsWith('0')
                                    ? '${loginAuth.name}님 반갑습니다.\n최근에 검사한 이력이 없습니다.'
                                    : '${loginAuth.name}님 반갑습니다.\n최근 검사일은 ${loginAuth.testDate}입니다.',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                _checkLatestTest(loginAuth.testDate)
                                  ? Text(
                                      '\n검사한 지 6개월이 지나 재검사가\n필요합니다.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Container()
                              ],
                            )
                          : TextField(
                              controller: _mobileController,
                              decoration: InputDecoration(
                                  hintText: '휴대폰 번호를 입력하세요.'
                              ),
                            )
                    ),
                    SizedBox(height: 35),
                    Consumer<LoginAuth>(
                      builder: (context, loginAuth, child) =>
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: RaisedButton(
                                color: Colors.teal,
                                child: Text(loginAuth.isLogin ? '검사시작' : '로그인', style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  if(!loginAuth.isLogin) {
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
                                        loginAuth.toggle();
                                        loginAuth.setMobile(_mobileController.text);

                                        _getUserInfo(_mobileController.text).then((value) {
                                          setState(() {
                                            loginAuth.setName(value.name);
                                          });
                                        });

                                        _getUserResult(_mobileController.text).then((value) {
                                          setState(() {
                                            loginAuth.setTestDate(formatDate(DateTime.parse(value.testDate), [yyyy, '-', mm, '-', dd]));
                                          });
                                        });

                                        Fluttertoast.showToast(
                                            msg: '로그인 성공',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 3
                                        );
                                        return;
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
                                  }
                                  if (loginAuth.isLogin) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => GuidePage(mobile: _mobileController.text),
                                      ),
                                    );
                                  } else {
                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                  }
                                },
                              ),
                            ),
                            loginAuth.isLogin
                              ? Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: RaisedButton(
                                      color: Colors.teal,
                                      child: Text('로그아웃', style: TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        loginAuth.toggle();
                                        loginAuth.setName('');
                                        loginAuth.setTestDate('0000-00-00 00:00:00');
                                      },
                                    ),
                                  ),
                                )
                              : Container()
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}