import 'package:lebengrida/model/result_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultServices {
  // static const ROOT = 'http://220.119.175.200:8081/RestAPI/result_actions.php';
  static const ROOT = 'http://lebengrida.youtunet.co.kr/RestAPI/result_actions.php';
  static const _GET_USERRESULTS_ACTION = 'GET_USERRESULTS';
  static const _GET_LASTRESULT_ACTION = 'GET_LASTRESULT';
  static const _USER_CHECK_ACTION = 'USER_CHECK';
  static const _SAVE_RESULT_ACTION = 'SAVE_RESULT';

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
        throw Exception('Failed to load exist test result');
      }
    } catch(e) {
      throw Exception('Failed to load exist test result result: $e');
    }
  }

  // 각 회원별 검사 결과 정보 조회
  static Future<List<Result>> getUserResults(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_USERRESULTS_ACTION;
      map['mobile'] = mobile;
      final response = await http.post(ROOT, body: map);
      print('getUserResult Response: ${response.body}');

      if (200 == response.statusCode) {
        List<Result> results = parseResponse(response.body);
        return results;
      } else {
        throw Exception('Failed to load result');
      }
    } catch(e) {
      throw Exception('Failed to load result: $e');
    }
  }

  static List<Result> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Result>((json) => Result.fromJson(json)).toList();
  }

  // 각 회원별 가장 최근 검사 결과 정보 조회
  static Future<Result> getLastResult(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_LASTRESULT_ACTION;
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

  // 검사 결과 저장
  static Future<String> saveTestResult(String mobile, List<int> attemptList, List<int> selectList, List<int> pointList, int totalPoint, String resultStatus) async {
    try {
      var map = Map<String, dynamic>();

      map['action'] = _SAVE_RESULT_ACTION;
      map['mobile'] = mobile;
      map['comment'] = '';

      // attempt_1 ~ 20
      for (var i = 0; i < attemptList.length; i++) {
        map['attempt_${i + 1}'] = attemptList[i].toString();
      }

      // select_1 ~ 20
      for (var i = 0; i < selectList.length; i++) {
        map['select_${i + 1}'] = selectList[i].toString();
      }

      // point_1 ~ 20
      for (var i = 0; i < pointList.length; i++) {
        map['point_${i + 1}'] = pointList[i].toString();
      }

      map['point_total'] = totalPoint.toString();
      map['result_status'] = resultStatus;

      print('save result map -> $map');

      final response = await http.post(ROOT, body: map);
      print('saveTestResult Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        throw Exception('Failed to save result');
      }
    } catch(e) {
      throw Exception('Failed to save result: $e');
    }
  }
}