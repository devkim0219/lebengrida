import 'package:flutter/foundation.dart';

class LoginAuth extends ChangeNotifier {
  // 로그인 상태 체크
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  // set isLogin(bool isJoin) => _isLogin = isJoin;

  // 로그인 정보 - 휴대폰 번호
  String _mobile = '';
  String get mobile => _mobile;

  // 로그인 정보 - 이름
  String _name = '';
  String get name => _name;

  // 최근 검사일
  String _testDate = '0000-00-00 00:00:00';
  String get testDate => _testDate;

  // 현재 탭 페이지 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // 지난 검사 날짜 인데스
  int _currentTestDateIndex = 0;
  int get currentTestDateIndex => _currentTestDateIndex;

  void toggle() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void setMobile(String mobile) {
    _mobile = mobile;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setTestDate(String testDate) {
    _testDate = testDate;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setCurrentTestDateIndex(int index) {
    _currentTestDateIndex = index;
    notifyListeners();
  }
}