import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

String username = '';

class Join extends StatelessWidget {
  TextEditingController name = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController birth = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  TextEditingController address = new TextEditingController();

  Future<List> sendData() async {
    final response = await http.post('http://192.168.0.132/RestAPI/insertdata.php',
                                      body: {
                                        'name': name.text,
                                        'mobile': mobile.text,
                                        'birth': birth.text,
                                        'gender': gender.text,
                                        'address': address.text,
                                      }
                                    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('사용자 등록')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이름',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                )
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: 'ex) 홍길동'
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '연락처',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                )
              ),
              TextField(
                controller: mobile,
                decoration: InputDecoration(
                  hintText: 'ex) 01012345678'
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '출생년도',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                )
              ),
              TextField(
                controller: birth,
                decoration: InputDecoration(
                  hintText: 'ex) 드롭다운.. 2020'
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '성별',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                )
              ),
              TextField(
                controller: gender,
                decoration: InputDecoration(
                  hintText: 'ex) 체크박스.. 남자 or 여자'
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '주소',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                )
              ),
              TextField(
                controller: address,
                decoration: InputDecoration(
                  hintText: 'ex) 드롭다운.. 시, 군, 구'
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.green,
                    child: Text('등록'),
                    onPressed: () {
                      sendData();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.green,
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
    );
  }
}