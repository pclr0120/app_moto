import 'package:flutter/material.dart';
import 'package:moto_app/model/UserModel.dart';
import 'package:moto_app/provider/Api.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import 'AuthRouterProvider.dart';

class AuthProvider with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _token;

  String get token => _token;

  set token(String token) {
    _token = token;
    notifyListeners();
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    this.token = prefs.get('token');
    return this.token;
  }

  setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('token', token);
    this.token = token;
    notifyListeners();
  }

  Future<String> get getUser async {
    final SharedPreferences prefs = await _prefs;
    return prefs.get('user');
  }

  setUser(String _user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('user', _user);
    this.userModel = User.fromJson(convert.jsonDecode(_user));
  }

  loadUserPref() async {
    final SharedPreferences prefs = await _prefs;
    prefs.getString('user');
    this.userModel = User.fromJson(convert.jsonDecode(prefs.getString('user')));
  }

  User _userModel;

  User get userModel {
    return _userModel;
  }

  set userModel(User usermodel) {
    _userModel = usermodel;
    notifyListeners();
  }

  AuthProvider() {
    this.loadUserPref();
  }
  // User getUserModel() {
  //   this.getUser.then((value) {
  //     userModel = User.fromJson(convert.jsonDecode(value));
  //     notifyListeners();
  //     return userModel;
  //   }).catchError((onError) {
  //     return null;
  //   });
  // }

  Future<Map<String, String>> login(
      String user, pass, BuildContext context) async {
    ApiProvider _api = new ApiProvider();

    return await _api
        .post('/auth/loginCustomer', {'email': user.trim(), 'pass': pass},
            context)
        .then(
      (value) async {
        var jsonResponse = convert.jsonDecode(value.body);
        var jsonUser = convert.jsonEncode(jsonResponse['data']);
        if (jsonResponse['status'] == 'OK') {
          if (jsonResponse['status'] != 'ERROR') {
            this.setUser(jsonUser);
            this.setToken(jsonResponse['data']['accessToken']['token']);

            return await _api
                .apiGet(
                    "/customers/?query=user_id=${jsonResponse['data']['id']},*",
                    context)
                .then((value) {
              var jsonResponse = convert.jsonDecode(value.body);

              this.setUser(convert.jsonEncode(jsonResponse['data'][0]));
              return (jsonResponse['data'][0]['token'] == null
                  ? {'status': 'ERROR', 'msn': 'Error intente de nuevo'}
                  : {'status': 'true'});
            });
          }
        } else {
          return {'status': 'auth', 'msn': "Usuario o contraseña invalido"};
        }
      },
    ).catchError((onError) {
      return {
        'status': 'ERROR',
        'msn': 'Error con el servidor intente más tarde'
      };
    });
  }

  logOut(BuildContext context) async {
    if (ModalRoute.of(context).settings.name != '/Login') {
      // final SharedPreferences prefs = await _prefs;
      // prefs.setString('token', null);
      Provider.of<AuthProvider>(context, listen: false).setToken(null);
      Provider.of<AuthProvider>(context, listen: false).setToken(null);
      AuthRouterProvider _auth = new AuthRouterProvider(context: context);
      _auth.checkSession(context);
    }
  }
}
