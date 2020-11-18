import 'package:flutter/foundation.dart';

class JoinOrLogin extends ChangeNotifier {
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  // set isLogin(bool isJoin) => _isLogin = isJoin;

  String _mobile = '';
  String get mobile => _mobile;

  void toggle() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  // void setIsLogin(bool isLogin) {
  //   _isLogin = isLogin;
  //   notifyListeners();
  // }

  void setMobile(String mobile) {
    _mobile = mobile;
    notifyListeners();
  }
}