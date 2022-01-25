import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token == null || _expiryDate.isBefore(DateTime.now())) {
      return null;
    }
    return _token;
  }

  Future<void> _toggleOption(
      String email, String password, String optionKey) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$optionKey?key=AIzaSyA7mslX761KUUj7rn-ZE7NqFyPUxAfjwyU';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData['error'] != null) {
        // print(responseData);
        print('error found');
        throw responseData['error']['message'];
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      print('working on pref');
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      pref.setString('userData', userData);
      // print(json.decode(pref.getString('userData')));
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(
    String email,
    String password,
  ) {
    return _toggleOption(email, password, 'signInWithPassword');
  }

  Future<void> signup(
    String email,
    String password,
  ) {
    return _toggleOption(email, password, 'signUp');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<void> autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> autoLogin() async{
    final prefs= await SharedPreferences.getInstance();
    // print('auto login');


    if(!prefs.containsKey('userData')){
      print('empty key');
      return false;
    }

    final userData=json.decode(prefs.getString('userData')) as Map<String,dynamic>;
    final expiry=DateTime.parse(userData['expiryDate']);

    if(expiry.isBefore(DateTime.now())){
      return false;
    }

    _token=userData['token'];
    _userId=userData['userId'];
    _expiryDate=expiry;
    autoLogout();
    notifyListeners();
    return true;
  }
}
