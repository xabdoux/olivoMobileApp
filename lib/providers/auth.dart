import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:olivoalcazar/models/http_exception.dart';
import 'package:olivoalcazar/screens/auth_screen.dart';
import 'package:olivoalcazar/screens/customers_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  String _urlServer;
  String _fullName;
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
      print(responseData);
      if (!responseData['success']) {
        throw HttpException(responseData['message']);
      }

      _token = responseData['token'].toString();
      _userId = responseData['id'].toString();
      _fullName = responseData['name'].toString();
      _urlServer = urlServer;

      notifyListeners();
      Navigator.of(context).pushReplacementNamed(CustomersListScreen.routeName);

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
    //print(_urlServer);
    return _urlServer;
  }

  void logout(BuildContext context) {
    _token = null;
    _userId = null;
    _fullName = null;
    notifyListeners();
  }
}
