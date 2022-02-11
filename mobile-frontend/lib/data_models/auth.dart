import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthModel extends ChangeNotifier {
  String? _token;
  // bool _isLoggedIn = false;
  bool isLoggedIn() {
    return _token == null ? false : true;
  }

  Future<void> saveToken(String token) async {
    var box = await Hive.openBox('hiveBox');
    await box.put('token', token);
    _token = token;
    notifyListeners();
  }

  Future<void> loadToken() async {
    var box = await Hive.openBox('hiveBox');
    var token = await box.get('token');
    _token = token;
  }

  String? get token {
    return _token;
  }

  dynamic get currentUser {}
}
