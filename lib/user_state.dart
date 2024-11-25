import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  String? _userId;
  String? _roleId;
  String? _token;

  String? get userId => _userId;
  String? get roleId => _roleId;
  String? get token => _token;

  void setUserDetails(String userId, String roleId, String token) {
    _userId = userId;
    _roleId = roleId;
    _token = token;
    notifyListeners();
  }

  void clearUserDetails() {
    _userId = null;
    _roleId = null;
    _token = null;
    notifyListeners();
  }
}
