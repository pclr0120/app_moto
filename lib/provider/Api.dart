import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:http/http.dart';

import 'AuthProvider.dart';

class ApiProvider with ChangeNotifier {
  ApiProvider() {
    this.url = "http://localhost:5000";
  }
  String _url;

  // ignore: unnecessary_getters_setters
  String get url {
    return _url;
  }

  // ignore: unnecessary_getters_setters
  set url(String url) {
    _url = url;
  }

  // String _token;

  // String get token => _token;

  // set token(String token) {
  //   _token = token;
  //   notifyListeners();
  // }

  // Future<String> getToken() async {
  //   final SharedPreferences prefs = await _prefs;
  //   this.token = prefs.get('token');
  //   return this.token;
  // }

  // setToken(String token) async {
  //   final SharedPreferences prefs = await _prefs;
  //   prefs.setString('token', token);
  //   this.token = token;
  // }

  // Future<String> get getUser async {
  //   final SharedPreferences prefs = await _prefs;
  //   return prefs.get('user');
  // }

  // setUser(String token) async {
  //   final SharedPreferences prefs = await _prefs;
  //   prefs.setString('user', token);
  // }

  Future<Response> post(
      String url, Map<String, String> body, BuildContext context) async {
    ApiProvider _api = new ApiProvider();

    var _body = json.encode(body);

    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    String _servicioURL = _api._url + url;
    AuthProvider _auth = new AuthProvider();
    var response;
    var token = await _auth.getToken();
    if (token == null || token == '') {
      response = await http.post(_servicioURL, headers: headers, body: _body);
    } else {
      headers = {'Accept': 'application/json', 'Authorization': token};
      response = await http.post(_servicioURL, headers: headers, body: _body);
    }

    if (response.statusCode == 200 &&
        interceptorTokenInvalid(response, context)) {
      return response;
    } else {
      return null;
    }
  }

  Future<Response> apiGet(String url, BuildContext context) async {
    ApiProvider _api = new ApiProvider();

    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    String _servicioURL = _api._url + url;

    AuthProvider _auth = new AuthProvider();
    var response;
    var token = await _auth.getToken();
    if (token == null || token == '') {
      response = await http.get(_servicioURL, headers: headers);
    } else {
      headers = {'Accept': 'application/json', 'Authorization': token};
      response = await http.get(_servicioURL, headers: headers);
    }

    if (response.statusCode == 200 &&
        interceptorTokenInvalid(response, context)) {
      return response;
    } else {
      return null;
    }
  }

  interceptorTokenInvalid(Response _response, BuildContext context) {
    var jsonResponse = convert.jsonDecode(_response.body);
    if (jsonResponse['status'] == "INVALID_TOKEN") {
      AuthProvider _auth = new AuthProvider();
      _auth.logOut(context);
      return false;
    } else {
      return true;
    }
  }
}
