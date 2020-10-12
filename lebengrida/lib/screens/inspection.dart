import 'package:flutter/material.dart';

class Inspection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('치매 진단 테스트'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/dog_1.png'),
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/dog_2.png'),
            ),
          ],
        )
      ),
    );
  }
}