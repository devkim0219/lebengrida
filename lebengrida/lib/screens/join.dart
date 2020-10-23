import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/services/user_service.dart';

class JoinPage extends StatefulWidget {
  JoinPage() : super();

  @override
  JoinPageState createState() => JoinPageState();
}

class JoinPageState extends State<JoinPage> {
  final _focusNode = FocusScopeNode();
  final _fKey = GlobalKey<FormState>();
  
  String year;

  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
  TextEditingController _mobileController;
  TextEditingController _protectorController;

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

  // 회원 등록 정보 입력 폼
  Widget inputForm() {
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
                    _addUser();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 회원 등록
  _addUser() {
    // if (_nameController.text.isEmpty || _birthController.text.isEmpty || _genderController.text.isEmpty || _addressController.text.isEmpty || _mobileController.text.isEmpty || _protectorController.text.isEmpty) {
    //   Fluttertoast.showToast(
    //     msg: '모든 항목을 입력해주세요.',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 3
    //   );
    //   return;
    // }

    UserServices.addUser(_nameController.text, _birthController.text, _genderController.text, _addressController.text, _mobileController.text, _protectorController.text)
    .then((result) {
      if ('success' == result) {
        Fluttertoast.showToast(
          msg: '등록이 완료되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
      }
    });
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
    _mobileController = TextEditingController();
    _protectorController = TextEditingController();
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
          appBar: AppBar(title: Text('회원 등록')),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: inputForm(),
            ),
          )
        )
      ),
    );
  }
}