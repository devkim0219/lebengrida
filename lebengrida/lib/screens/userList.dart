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
  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
  TextEditingController _mobileController;
  TextEditingController _protectorController;
  User _selectedUser;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _users = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
    _mobileController = TextEditingController();
    _protectorController = TextEditingController();
    _getUsers();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  // _showSnackBar(context, message) {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Text(message)
  //     )
  //   );
  // }

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

  // 회원 정보 수정
  _updateUser(User user) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('회원 정보 수정중...');
    UserServices.updateUser(_nameController.text, _birthController.text, _genderController.text, _addressController.text, _mobileController.text, _protectorController.text)
    .then((result) {
      if ('success' == result) {
        _getUsers();
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
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

  // 입력값 초기화
  _clearValues() {
    _nameController.text = '';
    _birthController.text = '';
    _genderController.text = '';
    _addressController.text = '';
    _mobileController.text = '';
    _protectorController.text = '';
  }

  // 각 회원의 정보 조회
  _showValues(User user) {
    _nameController.text = user.name;
    _birthController.text = user.birth;
    _genderController.text = user.gender;
    _addressController.text = user.address;
    _mobileController.text = user.mobile;
    _protectorController.text = user.protector;
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
                  _showValues(user);
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                }
              ),
              DataCell(
                Text(user.birth),
                onTap: () {
                  _showValues(user);
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                }
              ),
              DataCell(
                Text(user.gender),
                onTap: () {
                  _showValues(user);
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                }
              ),
              DataCell(
                Text(user.address),
                onTap: () {
                  _showValues(user);
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                }
              ),
              DataCell(
                Text(user.mobile),
                onTap: () {
                  _showValues(user);
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                }
              ),
              DataCell(
                Text(user.protector),
                onTap: () {
                  _showValues(user);
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
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

  SingleChildScrollView _showModifyUser() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _birthController,
                decoration: InputDecoration(
                  hintText: '출생년도'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  hintText: '성별'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: '주소'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                  hintText: '연락처'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: TextField(
                controller: _protectorController,
                decoration: InputDecoration(
                  hintText: '보호자'
                ),
              ),
            ),
            Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('수정'),
                  onPressed: () {
                    _updateUser(_selectedUser);
                  },
                ),
                OutlineButton(
                  child: Text('취소'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
          ]
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
              _dataBody(),
              _isUpdating ? _showModifyUser() : Container()
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