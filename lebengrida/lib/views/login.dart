import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              TextFormField(
                decoration: InputDecoration(
                  hintText: '전화번호를 입력하세요.'
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  RaisedButton(
                    color: Colors.green,
                    child: Text('사용자 등록'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/join');
                    },
                  ),
                  RaisedButton(
                    color: Colors.green,
                    child: Text('검사 시작'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}