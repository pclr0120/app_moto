import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moto_app/page/Login/LoginPage.dart';
import 'package:moto_app/page/homePage.dart';
import 'package:moto_app/provider/Api.dart';
import 'package:moto_app/provider/AuthProvider.dart';
import 'package:moto_app/provider/AuthRouterProvider.dart';
import 'package:moto_app/provider/locationDevice.dart';
import 'package:moto_app/share/widget/mapsWidget.dart';

import 'package:provider/provider.dart';

String token;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthProvider _auth = new AuthProvider();
  token = await _auth.getToken();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Provider.of<AuthRouterProvider>(context, listen: false)
    //     .checkSession(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthRouterProvider(context: context),
        ),
        ChangeNotifierProvider(
          create: (_) => ApiProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationDevice(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: true,
          localizationsDelegates: [
            // ... app-specific localization delegate[s] here
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('es', ''), // Hebrew, no country code
            const Locale.fromSubtags(
                languageCode: 'zh'), // Chinese *See Advanced Locales below*
            // ... other locales the app supports
          ],
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.dark,
          ),
          title: 'Material App',
          initialRoute: token != null ? 'home' : '/Login',
          routes: {
            'home': (context) => HomePage(),
            '/prueba': (context) => Maps(),
            '/Login': (context) => LoginPage(),
          }),
    );
  }
}

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => LocationDevice(),
//         )
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: true,
//         localizationsDelegates: [
//           // ... app-specific localization delegate[s] here
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: [
//           const Locale('en', ''), // English, no country code
//           const Locale('es', ''), // Hebrew, no country code
//           const Locale.fromSubtags(
//               languageCode: 'zh'), // Chinese *See Advanced Locales below*
//           // ... other locales the app supports
//         ],
//         theme: ThemeData(
//           // Define the default brightness and colors.
//           brightness: Brightness.dark,
//         ),
//         title: 'Material App',
//         initialRoute: 'home',
//         routes: {
//           'home': (context) => HomePage(),
//           '/prueba': (context) => Maps(),
//         },
//       ),
//     );
//   }
// }
