import 'package:http/http.dart' as http;

class LoginServices {
  // static const ROOT = 'http://220.119.175.200:8081/RestAPI/login_actions.php';
  static const ROOT = 'http://lebengrida.youtunet.co.kr/RestAPI/login_actions.php';
  static const _USER_CHECK_ACTION = 'USER_CHECK';

  // 회원 등록 여부 체크
  static Future<String> checkUser(String mobile) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _USER_CHECK_ACTION;
      map['mobile'] = mobile;
      final response = await http.post(ROOT, body: map);

      if (response.statusCode == 200) {
        return response.body;

      } else {
        throw Exception('Failed to check user');
      }
    } catch(e) {
      throw Exception('Failed to check user: $e');
    }
  }
}