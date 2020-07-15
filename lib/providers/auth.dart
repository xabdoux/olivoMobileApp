import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../screens/customers_list_screen.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  String _urlServer;
  String _fullName;
  String _username;
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

  String get fullName {
    return _fullName;
  }

  String get username {
    return _username;
  }

  Future<void> authenticate(String username, String password, String urlServer,
      BuildContext context) async {
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
        Duration(seconds: 8),
        onTimeout: () {
          throw SocketException(
              'Request Timeout, please check the server and try again');
        },
      );

      final responseData = json.decode(response.body);
      //print(response.statusCode);
      //print(responseData);
      if (!responseData['success']) {
        throw HttpException(responseData['message']);
      }

      _token = responseData['token'].toString();
      _userId = responseData['id'].toString();
      _fullName = responseData['name'].toString();
      _username = responseData['username'].toString();
      _urlServer = urlServer;

      notifyListeners();
      Navigator.of(context).pushReplacementNamed(CustomersListScreen.routeName);

      final prefs = await SharedPreferences.getInstance();
      // final userData =
      //     json.encode({'userId': _userId, 'urlServer': _urlServer});
      prefs.setString('urlServer', _urlServer);
      prefs.setString('username', _username);
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
    //print(_urlServer);
    return _urlServer;
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('username')) {
      return '';
    }
    final username = prefs.getString('username');

    //_token = extractedUserData['token'];

    _username = username;
    notifyListeners();
    //print(_urlServer);
    return _username;
  }

  void logout(BuildContext context) {
    _token = null;
    _userId = null;
    _fullName = null;
    notifyListeners();
  }
}
