import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DateTime currentBackPressTime;

  final _focusNode = FocusScopeNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
              appBar: AppBar(title: Text('치매 사전 진단 서비스')),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '치매 사전 진단 서비스',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black54,
                        )
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Text(
                        '로그인',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54,
                        )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: '전화번호를 입력하세요.'
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            color: Colors.teal,
                            child: Text('사용자 등록'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/join');
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            color: Colors.teal,
                            child: Text('검사 시작'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/inspection');
                            },
                          ),
                        ],
                      ),
                      RaisedButton(
                        color: Colors.teal,
                        child: Text('사용자 목록'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/userList');
                        },
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