import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'screens/main_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Service Manager',
      locale: _locale,
      supportedLocales: [const Locale('en', 'US'), const Locale('vi', 'VN')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MainScreen(onLocaleChange: _changeLanguage),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.yellow[500],
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow[500],
          foregroundColor: Colors.grey[500],
          hoverColor: Colors.yellowAccent,
          focusColor: Colors.yellow[700],
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.yellow[500],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[500],
          selectedIconTheme: IconThemeData(size: 30),
          unselectedIconTheme: IconThemeData(size: 24),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
