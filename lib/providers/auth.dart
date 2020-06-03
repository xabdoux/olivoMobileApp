import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:olivoalcazar/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  String _urlServer;
  //DateTime _expiryDate;
  //Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get urlServer {
    return _urlServer;
  }

  Future<void> authenticate(
      String username, String password, String urlServer) async {
    final url = "$urlServer/api/login";
    try {
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': username,
            'password': password,
          },
        ),
      )
          .timeout(
        Duration(seconds: 1),
        onTimeout: () {
          throw 'Request Timeout, please check the server and try again';
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (!responseData['success']) {
        print(responseData['message']);
        throw HttpException(responseData['message']);
      }

      _token = responseData['token'].toString();
      _userId = responseData['id'].toString();
      _urlServer = urlServer;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      // final userData =
      //     json.encode({'userId': _userId, 'urlServer': _urlServer});
      prefs.setString('urlServer', _urlServer);
    } catch (error) {
      throw (error);
    }
  }

  Future<String> getUrlServer() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('urlServer')) {
      return '';
    }
    final urlServer = prefs.getString('urlServer');

    //_token = extractedUserData['token'];

    _urlServer = urlServer;
    notifyListeners();
    print(_urlServer);
    return _urlServer;
  }

  void logout() {
    _token = null;
    _userId = null;
    notifyListeners();
  }
}
