import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      // print(_expirydate);
      // print(_token);
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urltype) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urltype?key=AIzaSyB4wcV1NFfZpOlgiAVeYrU_Q83Ph2Mt6zM";

      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      //print(jsonDecode(response.body));
      final responsedata = jsonDecode(response.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));

      _autoLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expirydate': _expirydate.toIso8601String()
      });
      prefs.setString('UserData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return false;
    }

    final extractedUserData = jsonDecode(prefs.getString('UserData')) as Map;
    final expiryDate = DateTime.parse(extractedUserData['expirydate']);

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expirydate = expiryDate;
    print(extractedUserData);

    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expirydate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    print('B');
    prefs.clear();
  }

  void _autoLogOut() {
    if (authTimer != null) authTimer.cancel();

    print('YOO ${_expirydate.difference(DateTime.now()).inSeconds}');
    authTimer = Timer(
        Duration(seconds: _expirydate.difference(DateTime.now()).inSeconds),
        logOut);
  }
}
