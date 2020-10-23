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

  @override
  UpdateInfoPageState createState() => UpdateInfoPageState();
}

class UpdateInfoPageState extends State<UpdateInfoPage> {
  final _focusNode = FocusScopeNode();
  final _fKey = GlobalKey<FormState>();

  String year;

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
  TextEditingController _mobileController;
  TextEditingController _protectorController;
  User _selectedUser;

  

  // 회원 정보 수정
  _updateUser(User user) {
    if (_nameController.text.isEmpty || _birthController.text.isEmpty || _genderController.text.isEmpty || _addressController.text.isEmpty || _mobileController.text.isEmpty || _protectorController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: '모든 항목을 입력해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3
      );
      return;
    }

    UserServices.updateUser(_nameController.text, _birthController.text, _genderController.text, _addressController.text, _mobileController.text, _protectorController.text)
    .then((result) {
      if ('success' == result) {
        Navigator.pop(context);
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
  // _deleteUser(User user) {
  //   UserServices.deleteUser(user.mobile).then((result) {
  //     if ('success' == result) {
  //       Navigator.pushNamed(context, '/');
  //       Fluttertoast.showToast(
  //         msg: '회원 탈퇴가 완료되었습니다.',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 3
  //       );
  //     }
  //   });
  // }

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

  // 출생년도 선택
  _yearPicker() {
    final year = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '출생년도를 선택하세요.',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 4.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[200],
            child: YearPicker(
              selectedDate: DateTime(year),
              firstDate: DateTime(year - 100),
              lastDate: DateTime(year),
              onChanged: (value) {
                _birthController.text = value.toString().substring(0, 4);
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    );
  }

  // 회원 정보 수정 입력 폼
  Widget updateForm() {
    return Form(
      key: _fKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이름',
                hintText: '예) 홍길동',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '이름을 입력해주세요.';
                }
                return null;
              }, 
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _yearPicker,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _birthController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '출생년도',
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      onSaved: (val) {
                        year = _birthController.text;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return '출생년도를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextField(
              controller: _genderController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '성별',
                hintText: 'RadioButton으로 대체',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '주소',
                hintText: '주소검색 API 또는 DropDown으로 대체',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '연락처',
                hintText: '예) 01012345678',
                prefixIcon: Icon(Icons.phone_android),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextField(
              controller: _protectorController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '보호자',
                hintText: '예) 홍길동',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
              RaisedButton(
                color: Colors.teal,
                child: Text(
                  '등록',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () {
                  if (_fKey.currentState.validate()) {
                    _updateUser(_selectedUser);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
    _mobileController = TextEditingController();
    _protectorController = TextEditingController();

    _getUserInfo(widget.mobile);
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
            title: Text('회원 정보 수정'),
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
                  _clearValues();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: updateForm(),
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