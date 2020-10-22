import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/models/user_data.dart';
import 'package:lebengrida/services/user_service.dart';

class UpdateInfoPage extends StatefulWidget {
  final String mobile;
  
  UpdateInfoPage({
    Key key,
    @required this.mobile
  }) : super(key: key);

  final String title = '회원 정보 수정';

  @override
  UpdateInfoPageState createState() => UpdateInfoPageState();
}

class UpdateInfoPageState extends State<UpdateInfoPage> {
  final _focusNode = FocusScopeNode();

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
  TextEditingController _mobileController;
  TextEditingController _protectorController;
  String _titleProgress;
  User _selectedUser;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
    _mobileController = TextEditingController();
    _protectorController = TextEditingController();

    _getUserInfo(widget.mobile);
  }

  // 회원 정보 수정
  _updateUser(User user) {
    UserServices.updateUser(_nameController.text, _birthController.text, _genderController.text, _addressController.text, _mobileController.text, _protectorController.text)
    .then((result) {
      if ('success' == result) {
        Navigator.pushNamed(context, '/');
        Fluttertoast.showToast(
          msg: '회원 정보가 수정되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
      }
    });
  }

  // 회원 정보 수정을 위한 해당 회원의 정보 조회
  _getUserInfo(String mobile) {
    UserServices.getUserInfo(mobile).then((user) {
      setState(() {
        _selectedUser = user;
      });
      print('### selected user info -> ${user.mobile}');
      _showValues(_selectedUser);
    });
  }

  // 회원 정보 삭제(탈퇴)
  _deleteUser(User user) {
    UserServices.deleteUser(user.mobile).then((result) {
      if ('success' == result) {
        Navigator.pushNamed(context, '/');
        Fluttertoast.showToast(
          msg: '회원 탈퇴가 완료되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
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

  SingleChildScrollView _showModifyUser() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
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
                  _clearValues();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: '이름'
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _birthController,
                      decoration: InputDecoration(
                        hintText: '출생년도'
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _genderController,
                      decoration: InputDecoration(
                        hintText: '성별'
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: '주소'
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        hintText: '연락처'
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _protectorController,
                      decoration: InputDecoration(
                        hintText: '보호자'
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.teal,
                        child: Text(
                          '수정', 
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                        onPressed: () {
                          // _updateUser(_selectedUser);
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      RaisedButton(
                        color: Colors.teal,
                        child: Text(
                          '취소', 
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
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