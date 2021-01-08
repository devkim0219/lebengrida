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
  static const _SAVE_PROGRESS_ACTION = 'SAVE_PROGRESS';

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

  // 검사 진행상황 저장
  static Future<String> saveTestProgress(String mobile, String qNo, String attempt, String selectNo, String score, String testKey) async {
    try {
      var map = Map<String, dynamic>();

      map['action'] = _SAVE_PROGRESS_ACTION;
      map['mobile'] = mobile;
      map['q_no'] = qNo;
      map['attempt'] = attempt;
      map['select_no'] = selectNo;
      map['score'] = score;
      map['test_key'] = testKey;

      print('save progress map -> $map');

      final response = await http.post(ROOT, body: map);
      print('saveTestProgress Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        throw Exception('Failed to save progress');
      }
    } catch(e) {
      throw Exception('Failed to save progress: $e');
    }
  }

  // 검사 결과 저장
  static Future<String> saveTestResult(String mobile, List<int> scoreList, int totalScore, String resultStatus, String testKey) async {
    try {
      var map = Map<String, dynamic>();
      var a1Score = 0;
      var a2Score = 0;
      var bScore = 0;
      var cScore = 0;
      var dScore = 0;

      map['action'] = _SAVE_RESULT_ACTION;
      map['mobile'] = mobile;

      for (int i = 0; i < scoreList.length; i++) {
        if (i >= 0 && i <= 3 ) {
          a1Score += scoreList[i];
        } else if (i >= 4 && i <= 7) {
          a2Score += scoreList[i];
        } else if (i >= 8 && i <= 11) {
          bScore += scoreList[i];
        } else if (i >= 12 && i <= 15) {
          cScore += scoreList[i];
        } else {
          dScore += scoreList[i];
        }
      }
      map['a1_score'] = a1Score.toString();
      map['a2_score'] = a2Score.toString();
      map['b_score'] = bScore.toString();
      map['c_score'] = cScore.toString();
      map['d_score'] = dScore.toString();
      map['total_score'] = totalScore.toString();
      map['comment'] = '';
      map['result_status'] = resultStatus;
      map['test_key'] = testKey;

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