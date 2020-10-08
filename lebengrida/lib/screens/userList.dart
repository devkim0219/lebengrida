import 'package:flutter/material.dart';
import 'package:lebengrida/models/user_data.dart';
import 'package:lebengrida/services/user_service.dart';

class UserList extends StatefulWidget {
  UserList() : super();

  final String title = '사용자 리스트';

  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  List<User> _users;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _mobileController;
  TextEditingController _birthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
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
    _mobileController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
    _getUsers();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message)
      )
    );
  }

  // 사용자 등록
  _addUser() {
    if (_nameController.text.isEmpty || _mobileController.text.isEmpty || _birthController.text.isEmpty || _genderController.text.isEmpty || _addressController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('사용자 등록중...');
    Services.addUser(_nameController.text, _mobileController.text, _birthController.text, _genderController.text, _addressController.text)
    .then((result) {
      if ('success' == result) {
        _getUsers();
        _clearValues();
      }
    });
  }

  // 사용자 리스트 조회
  _getUsers() {
    _showProgress('사용자 목록 조회중...');
    Services.getUsers().then((users) {
      setState(() {
        _users = users;
      });
      _showProgress(widget.title);
      print('Length ${users.length}');
    });
  }

  // 사용자 정보 수정
  _updateUser(User user) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('사용자 정보 수정중...');
    Services.updateUser(_nameController.text, _mobileController.text, _birthController.text, _genderController.text, _addressController.text)
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

  // 사용자 정보 삭제
  _deleteUser(User user) {
    _showProgress('사용자 정보 삭제중...');
    Services.deleteUser(user.mobile).then((result) {
      if ('success' == result) {
        _getUsers();
      }
    });
  }

  // 입력값 초기화
  _clearValues() {
    _nameController.text = '';
    _mobileController.text = '';
    _birthController.text = '';
    _genderController.text = '';
    _addressController.text = '';
  }

  // 각 회원의 정보 조회
  _showValues(User user) {
    _nameController.text = user.name;
    _mobileController.text = user.mobile;
    _birthController.text = user.birth;
    _genderController.text = user.gender;
    _addressController.text = user.address;
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('이름')),
            DataColumn(label: Text('연락처')),
            DataColumn(label: Text('출생년도')),
            DataColumn(label: Text('성별')),
            DataColumn(label: Text('주소')),
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getUsers();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration.collapsed(
                  hintText: '이름'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _mobileController,
                decoration: InputDecoration.collapsed(
                  hintText: '연락처'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _birthController,
                decoration: InputDecoration.collapsed(
                  hintText: '출생년도'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _genderController,
                decoration: InputDecoration.collapsed(
                  hintText: '성별'
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration.collapsed(
                  hintText: '주소'
                ),
              ),
            ),
            _isUpdating
              ? Row(
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
              : Container(),
            Expanded(child: _dataBody())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addUser();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}