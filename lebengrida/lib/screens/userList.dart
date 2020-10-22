import 'package:flutter/material.dart';
import 'package:lebengrida/models/user_data.dart';
import 'package:lebengrida/services/user_service.dart';

class UserListPage extends StatefulWidget {
  UserListPage() : super();

  final String title = '회원 목록';

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  final _focusNode = FocusScopeNode();

  List<User> _users;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _users = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _getUsers();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  // 회원 목록 조회
  _getUsers() {
    _showProgress('회원 목록 조회중...');
    UserServices.getUsers().then((users) {
      setState(() {
        _users = users;
      });
      _showProgress(widget.title);
      print('Length ${users.length}');
    });
  }

  // 회원 정보 삭제(탈퇴)
  _deleteUser(User user) {
    _showProgress('회원 탈퇴중...');
    UserServices.deleteUser(user.mobile).then((result) {
      if ('success' == result) {
        _getUsers();
      }
    });
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('이름')),
            DataColumn(label: Text('출생년도')),
            DataColumn(label: Text('성별')),
            DataColumn(label: Text('주소')),
            DataColumn(label: Text('연락처')),
            DataColumn(label: Text('보호자')),
            DataColumn(label: Text('삭제')),
          ],
          rows: _users.map(
            (user) => DataRow(cells: [
              DataCell(
                Text(user.name),
                onTap: () {

                }
              ),
              DataCell(
                Text(user.birth),
                onTap: () {

                }
              ),
              DataCell(
                Text(user.gender),
                onTap: () {

                }
              ),
              DataCell(
                Text(user.address),
                onTap: () {

                }
              ),
              DataCell(
                Text(user.mobile),
                onTap: () {

                }
              ),
              DataCell(
                Text(user.protector),
                onTap: () {

                }
              ),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteUser(user);
                },
              )),
            ]),
          ).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: FocusScope(
        node: _focusNode,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(_titleProgress),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _getUsers();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              _dataBody()
            ],
          )
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _addUser();
        //   },
        //   child: Icon(Icons.add),
        // ),
      ),
    );
  }
}