import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/services/user_service.dart';

class JoinPage extends StatefulWidget {
  JoinPage() : super();

  final String title = '회원 등록';

  @override
  JoinPageState createState() => JoinPageState();
}

class JoinPageState extends State<JoinPage> {
  final _focusNode = FocusScopeNode();
  
  String _titleProgress;
  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
  TextEditingController _mobileController;
  TextEditingController _protectorController;
  
  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
    _mobileController = TextEditingController();
    _protectorController = TextEditingController();
  }

  _addUser() {
    if (_nameController.text.isEmpty || _birthController.text.isEmpty || _genderController.text.isEmpty || _addressController.text.isEmpty || _mobileController.text.isEmpty || _protectorController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: '모든 항목을 입력해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3
      );
      return;
    }

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

    Navigator.pop(context);
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
          appBar: AppBar(title: Text(_titleProgress)),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Text(
                  //   '이름',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //     color: Colors.black54,
                  //   )
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: '이름'
                      ),
                    ),
                  ),
                  // Text(
                  //   '연락처',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //     color: Colors.black54,
                  //   )
                  // ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        hintText: '연락처'
                      ),
                    ),
                  ),
                  // Text(
                  //   '출생년도',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //     color: Colors.black54,
                  //   )
                  // ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _birthController,
                      decoration: InputDecoration(
                        hintText: '출생년도'
                      ),
                    ),
                  ),
                  // Text(
                  //   '성별',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //     color: Colors.black54,
                  //   )
                  // ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _genderController,
                      decoration: InputDecoration(
                        hintText: '성별'
                      ),
                    ),
                  ),
                  // Text(
                  //   '주소',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //     color: Colors.black54,
                  //   )
                  // ),
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
                      controller: _protectorController,
                      decoration: InputDecoration(
                        hintText: '보호자'
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text('취소'),
                        onPressed: () {
                          Navigator.pop(context);
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
                          _addUser();
                        },
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     RaisedButton(
                  //       color: Colors.teal,
                  //       child: Text(
                  //         '등록',
                  //         style: TextStyle(
                  //           color: Colors.white
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         _addUser();
                  //         Navigator.pushReplacementNamed(context, '/');
                  //       },
                  //     ),
                  //     SizedBox(
                  //       width: 20,
                  //     ),
                  //     RaisedButton(
                  //       color: Colors.teal,
                  //       child: Text(
                  //         '취소',
                  //         style: TextStyle(
                  //           color: Colors.white
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.pushReplacementNamed(context, '/');
                  //       },
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}