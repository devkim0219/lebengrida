import 'package:flutter/material.dart';

class NoResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원 등록')),
      body: Container(
        padding: EdgeInsets.all(60.0),
        alignment: Alignment.center,
        child: Text(
          '로그인 후 검사 결과를 확인하실 수 있습니다.',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
