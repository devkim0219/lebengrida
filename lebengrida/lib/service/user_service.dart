import 'package:lebengrida/model/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserServices {
  static const ROOT = 'http://220.119.175.200:8081/RestAPI/user_actions.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_USER_ACTION = 'ADD_USER';
  static const _UPDATE_USER_ACTION = 'UPDATE_USER';
  static const _GET_USERINFO_ACTION = 'GET_USERINFO';
  static const _DELETE_USER_ACTION = 'DELETE_USER';
  static const _CHECK_USER_ACTION = 'CHECK_USER';

  // 전체 회원 목록 조회
  static Future<List<User>> getUsers() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getUsers Response: ${response.body}');
      
      if (200 == response.statusCode) {
        List<User> list = parseResponse(response.body);
        return list;
      } else {
        throw Exception('Failed to load users');
      }
    } catch(e) {
      throw Exception('Failed to load users: $e');
    }
  }

  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  // 회원 등록
  static Future<String> addUser(String name, String birth, String gender, String address, String mobile, String protectorName, String protectorMobile, String instructor) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_USER_ACTION;
      map['name'] = name;
      map['birth'] = birth;
      map['age'] = (DateTime.now().year - int.parse(birth) + 1).toString();
      map['gender'] = gender;
      map['address'] = address;
      map['mobile'] = mobile;
      map['protector_name'] = protectorName;
      map['protector_mobile'] = protectorMobile;
      map['instructor'] = instructor;
      final response = await http.post(ROOT, body: map);
      print('addUser Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        throw Exception('Failed to add user');
      }
    } catch(e) {
      throw Exception('Failed to add user: $e');
    }
  }

  // 회원 정보 수정
  static Future<String> updateUser(String name, String birth, String gender, String address, String mobile, String protectorName, String protectorMobile, String instructor) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_USER_ACTION;
      map['name'] = name;
      map['birth'] = birth;
      map['age'] = (DateTime.now().year - int.parse(birth) + 1).toString();
      map['gender'] = gender;
      map['address'] = address;
      map['mobile'] = mobile;
      map['protector_name'] = protectorName;
      map['protector_mobile'] = protectorMobile;
      map['instructor'] = instructor;
      final response = await http.post(ROOT, body: map);
      print('updateUser Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        throw Exception('Failed to update user');
      }
    } catch(e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // 회원 정보 수정을 위한 해당 회원의 정보 조회
  static Future<User> getUserInfo(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_USERINFO_ACTION;
      map['mobile'] = mobile;
      final response = await http.post(ROOT, body: map);
      print('getUserInfo Response: ${response.body}');

      if (200 == response.statusCode) {
        User user = User.fromJson(json.decode(response.body));
        return user;
      } else {
        throw Exception('Failed to load userinfo');
      }
    } catch(e) {
      throw Exception('Failed to load userinfo: $e');
    }
  }

  // 회원 정보 삭제(탈퇴)
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
        throw Exception('Failed to delete user');
      }
    } catch(e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // 기존 등록된 회원이 있는지 확인
  static Future<String> checkUser(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _CHECK_USER_ACTION;
      map['mobile'] = mobile;
      final response = await http.post(ROOT, body: map);
      print('checkUser Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        throw Exception('Failed to check user');
      }
    } catch(e) {
      throw Exception('Failed to check user: $e');
    }
  }
}