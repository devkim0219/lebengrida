import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/services/user_service.dart';

class Join extends StatefulWidget {
  Join() : super();

  final String title = '사용자 등록';

  @override
  JoinState createState() => JoinState();
}

class JoinState extends State<Join> {
  final _focusNode = FocusScopeNode();
  
  String _titleProgress;
  TextEditingController _nameController;
  TextEditingController _mobileController;
  TextEditingController _birthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
  
  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _addUser() {
    if (_nameController.text.isEmpty || _mobileController.text.isEmpty || _birthController.text.isEmpty || _genderController.text.isEmpty || _addressController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('사용자 등록중...');
    Services.addUser(_nameController.text, _mobileController.text, _birthController.text, _genderController.text, _addressController.text)
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
                    padding: EdgeInsets.only(bottom: 20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        color: Colors.teal,
                        child: Text('등록'),
                        onPressed: () {
                          _addUser();
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                        color: Colors.teal,
                        child: Text('취소'),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}