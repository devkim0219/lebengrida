import 'package:flutter/foundation.dart';

class LoginAuth extends ChangeNotifier {
  // 로그인 상태 체크
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  // set isLogin(bool isJoin) => _isLogin = isJoin;

  // 로그인 정보 : 휴대폰 번호
  String _mobile = '';
  String get mobile => _mobile;

  // 현재 탭 페이지 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void toggle() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void setMobile(String mobile) {
    _mobile = mobile;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}