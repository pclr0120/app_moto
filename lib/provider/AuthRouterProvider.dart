import 'package:flutter/material.dart';

import 'AuthProvider.dart';

class AuthRouterProvider with ChangeNotifier {
  AuthProvider _auth;
  AuthRouterProvider({BuildContext context}) {
    this._auth = new AuthProvider();
    checkSession(context);
  }

  checkSession(BuildContext context) async {
    await this._auth.getToken().then((value) {
      if (value == null)
        return Navigator.pushNamedAndRemoveUntil(
            context, "/Login", (Route<dynamic> route) => false);
      else
        return true;
    }).catchError((onError) {
      return Navigator.pushNamedAndRemoveUntil(
          context, "/Login", (Route<dynamic> route) => false);
    });
  }
}

// class RouteGenerater {
//   static const ROUTE_HOME = "/home";
//   static const ROUTE_LOGIN = "/";

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     AuthProvider _auth = new AuthProvider();
//     _auth.getToken().then((value) {
//       switch (settings.name) {
//         case ROUTE_HOME:
//           final page = HomePage();
//           return MaterialPageRoute(builder: (context) => page);
//         case ROUTE_LOGIN:
//           final page = LoginPage();
//           return MaterialPageRoute(builder: (context) => page);

//         default:
//           return MaterialPageRoute(builder: (context) => LoginPage());
//       }
//     }).catchError((onError) {
//       return MaterialPageRoute(builder: (context) => LoginPage());
//     });
//   }
// }
