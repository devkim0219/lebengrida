import 'package:lebengrida/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserServices {
  static const ROOT = 'http://192.168.0.132/RestAPI/user_actions.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_USER_ACTION = 'ADD_USER';
  static const _UPDATE_USER_ACTION = 'UPDATE_USER';
  static const _DELETE_USER_ACTION = 'DELETE_USER';

  // 전체 사용자 리스트 조회
  static Future<List<User>> getUsers() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getUsers Response: ${response.body}');
      
      if (200 == response.statusCode) {
        List<User> list = parseResponse(response.body);
        print('### user list: $list');
        return list;
      } else {
        return List<User>();
      }
    } catch(e) {
      return List<User>();
    }
  }

  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  // 사용자 등록
  static Future<String> addUser(String name, String mobile, String birth, String gender, String address) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_USER_ACTION;
      map['name'] = name;
      map['mobile'] = mobile;
      map['birth'] = birth;
      map['gender'] = gender;
      map['address'] = address;
      final response = await http.post(ROOT, body: map);
      print('addUser Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch(e) {
      return 'error';
    }
  }

  // 사용자 정보 수정
  static Future<String> updateUser(String name, String mobile, String birth, String gender, String address) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_USER_ACTION;
      map['name'] = name;
      map['mobile'] = mobile;
      map['birth'] = birth;
      map['gender'] = gender;
      map['address'] = address;
      final response = await http.post(ROOT, body: map);
      print('updateUser Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch(e) {
      return 'error';
    }
  }

  // 사용자 정보 삭제
  static Future<String> deleteUser(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_USER_ACTION;
      map['mobile'] = mobile;
      final response = await http.post(ROOT, body: map);
      print('deleteUser Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch(e) {
      return 'error';
    }
  }
}