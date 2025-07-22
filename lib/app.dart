import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'screens/main_screen.dart';
import 'package:app_project/screens/user/login_screen.dart' show LoginScreen;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');
  final user = Supabase.instance.client.auth.currentUser;
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
      home: user == null
          ? LoginScreen()
          : MainScreen(onLocaleChange: _changeLanguage),
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
          foregroundColor: Colors.black,
          hoverColor: Colors.yellowAccent,
          focusColor: Colors.yellow[700],
          iconSize: 20,
          sizeConstraints: const BoxConstraints(minWidth: 45, minHeight: 45),
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
