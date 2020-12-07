import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moto_app/page/home_page.dart';
import 'package:moto_app/provider/location_device.dart';
import 'package:moto_app/share/widget/maps_widget.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        initialRoute: 'home',
        routes: {
          'home': (context) => HomePage(),
          '/prueba': (context) => Maps(),
        },
      ),
    );
  }
}
