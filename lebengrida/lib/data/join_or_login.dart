import 'package:flutter/foundation.dart';

class JoinOrLogin extends ChangeNotifier {
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  // set isJoin(bool isJoin) => _isJoin;

  void toggle() {
    _isLogin = !_isLogin;
    notifyListeners();
  }
}