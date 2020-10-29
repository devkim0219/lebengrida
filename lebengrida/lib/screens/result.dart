import 'package:flutter/material.dart';
import 'package:lebengrida/models/result_data.dart';
import 'package:lebengrida/models/user_data.dart';
import 'package:lebengrida/services/result_service.dart';
import 'package:lebengrida/services/user_service.dart';

class ResultPage extends StatefulWidget {
  final String mobile;

  ResultPage({
    Key key,
    @required this.mobile,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  User _selectedUser;
  Result _userResult;

  // 각 회원 정보 조회
  _getUserInfo(String mobile) {
    UserServices.getUserInfo(mobile).then((user) {
      setState(() {
        _selectedUser = user;
      });
      print('### selected user info -> ${user.mobile}');
    });
  }

  // 각 회원별 검사 결과 정보 조회
  _getUserResult(String mobile) {
    ResultServices.getUserResult(mobile).then((result) {
      setState(() {
        _userResult = result;

        if (_userResult.resultStatus == 'pass') {
          _userResult.resultStatus = '도달';
        } else {
          _userResult.resultStatus = '미도달';
        }
      });
      print('### selected user result -> ${result.mobile}');
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo(widget.mobile);
    _getUserResult(widget.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('검사 결과'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/'))
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              '이름 : ${_selectedUser.name}\n'
              + '연락처 : ${_userResult.mobile}\n'
              + '나이 : ${_selectedUser.age}\n'
              + '총점 : ${_userResult.pointTotal}점\n'
              + '인지 검사 결과 : ${_userResult.resultStatus}\n'
              + '최근 검사일 : ${_userResult.testDate}',
              style: TextStyle(
                fontSize: 30,
              ),
            )
          ],
        ),
      )
    );
  }
}