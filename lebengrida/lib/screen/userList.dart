import 'package:flutter/material.dart';
import 'package:lebengrida/model/user_data.dart';
import 'package:lebengrida/service/user_service.dart';

class UserListPage extends StatefulWidget {
  UserListPage() : super();

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  final _focusNode = FocusScopeNode();

  List<User> _users;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _users = [];
    _scaffoldKey = GlobalKey();
    _getUsers();
  }

  // 회원 목록 조회
  _getUsers() {
    UserServices.getUsers().then((users) {
      setState(() {
        _users = users;
      });
      print('Length ${users.length}');
    });
  }

  // 회원 정보 삭제(탈퇴)
  _deleteUser(User user) {
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
            DataColumn(label: Text('나이')),
            DataColumn(label: Text('성별')),
            DataColumn(label: Text('주소')),
            DataColumn(label: Text('연락처')),
            DataColumn(label: Text('보호자명')),
            DataColumn(label: Text('보호자 연락처')),
            DataColumn(label: Text('삭제')),
          ],
          rows: _users.map(
            (user) => DataRow(cells: [
              DataCell(
                Text(user.name),
              ),
              DataCell(
                Text(user.birth),
              ),
              DataCell(
                Text(user.age),
              ),
              DataCell(
                Text(user.gender),
              ),
              DataCell(
                Text(user.address),
              ),
              DataCell(
                Text(user.mobile),
              ),
              DataCell(
                Text(user.protectorName),
              ),
              DataCell(
                Text(user.protectorMobile),
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
            title: Text('회원 목록'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
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