import 'package:lebengrida/models/result_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultServices {
  static const ROOT = 'http://192.168.0.132/RestAPI/result_actions.php';
  static const _GET_USERRESULT_ACTION = 'GET_USERRESULT';
  static const _USER_CHECK_ACTION = 'USER_CHECK';

  // 기존 검사 여부 체크
  static Future<String> checkTested(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _USER_CHECK_ACTION;
      map['mobile'] = mobile;
      final response = await http.post(ROOT, body: map);

      if (response.statusCode == 200) {
        return response.body;

      } else {
        return 'error';
      }
    } catch(e) {
      return 'error';
    }
  }

  // 각 회원별 검사 결과 정보 조회
  static Future<Result> getUserResult(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_USERRESULT_ACTION;
      map['mobile'] = mobile;
      final response = await http.post(ROOT, body: map);
      print('getUserResult Response: ${response.body}');

      if (200 == response.statusCode) {
        Result result = Result.fromJson(json.decode(response.body));
        return result;
      } else {
        throw Exception('Failed to load result');
      }
    } catch(e) {
      throw Exception('Failed to load result: $e');
    }
  }
}