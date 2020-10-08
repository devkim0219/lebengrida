import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: Colors.green,
                    child: Text('사용자 등록'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/join');
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.green,
                    child: Text('검사 시작'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ],
              ),
              RaisedButton(
                color: Colors.green,
                child: Text('목록보기(test)'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/userList');
                },
              )
            ],
          ),
        ),
      )
    );
  }
}