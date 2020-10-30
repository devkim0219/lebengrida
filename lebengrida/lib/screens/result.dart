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
  String _resultStatus = '';
  Color _resultStatusTextColor;

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

        // 인지 능력 저하 판단
        // 60~69세 : 22점, 70~74세 : 22점, 75~79세 : 21점, 80세 이상 : 20점
        if (int.parse(_selectedUser.age) >= 60 && int.parse(_selectedUser.age) <= 74 && int.parse(_userResult.pointTotal) >= 22 ||
            int.parse(_selectedUser.age) >= 75 && int.parse(_selectedUser.age) <= 79 && int.parse(_userResult.pointTotal) >= 21 ||
            int.parse(_selectedUser.age) >= 80 && int.parse(_userResult.pointTotal) >= 20 ) {
          _userResult.resultStatus = 'pass';
          
        } else {
          _userResult.resultStatus = 'nopass';
        }

        // 인지 능력 저하 미도달/도달 에 따른 텍스트 색상 변경
        if (_userResult.resultStatus == 'pass') {
          _resultStatus = '미도달';
          _resultStatusTextColor = Colors.black87;

        } else {
          _resultStatus = '도달';
          _resultStatusTextColor = Colors.red[700];
        }
      });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '이름 : ${_selectedUser.name}',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
              ),
            ),
            Text(
              '연락처 : ${_userResult.mobile}',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
              ),
            ),
            Text(
              '나이 : ${_selectedUser.age}',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
              ),
            ),
            Text(
              '총점 : ${_userResult.pointTotal}점',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black87
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '인지 능력 저하 : '
                  ),
                  TextSpan(
                    text: '$_resultStatus',
                    style: TextStyle(
                      color: _resultStatusTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '최근 검사일 : ${_userResult.testDate}',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      )
    );
  }
}