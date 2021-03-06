import 'package:lebengrida/model/question_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionServices {
  // static const ROOT = 'http://220.119.175.200:8081/RestAPI/question_actions.php';
  static const ROOT = 'http://lebengrida.youtunet.co.kr/RestAPI/question_actions.php';
  static const _GET_ALL_ACTION = 'GET_ALL';

  // 문제 데이터 조회
  static Future<List<Question>> getQuestions() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getQuestions Response: ${response.body}');
      
      if (200 == response.statusCode) {
        List<Question> list = parseResponse(response.body);
        return list;
      } else {
        return List<Question>();
      }
    } catch(e) {
      return List<Question>();
    }
  }

  static List<Question> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }
}