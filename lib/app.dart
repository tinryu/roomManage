// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'screens/main_screen.dart';
import 'package:app_project/screens/tenants/login_screen.dart' show LoginScreen;

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
        // Primary color scheme using lightblue, white, and black
        primarySwatch: Colors.lightBlue,
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,

        // Color scheme
        colorScheme: ColorScheme.light(
          primary: Colors.lightBlue,
          secondary: Colors.lightBlue[300]!,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
        ),

        // Text theme using black for readability
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
          bodySmall: TextStyle(color: Colors.black87, fontSize: 12),
          labelLarge: TextStyle(color: Colors.black, fontSize: 16),
          labelMedium: TextStyle(color: Colors.black, fontSize: 14),
          labelSmall: TextStyle(color: Colors.black87, fontSize: 12),
          titleLarge: TextStyle(color: Colors.black, fontSize: 16),
          titleMedium: TextStyle(color: Colors.black, fontSize: 14),
          titleSmall: TextStyle(color: Colors.black87, fontSize: 12),
          headlineLarge: TextStyle(color: Colors.black, fontSize: 16),
          headlineMedium: TextStyle(color: Colors.black, fontSize: 14),
          headlineSmall: TextStyle(color: Colors.black87, fontSize: 12),
          displayLarge: TextStyle(color: Colors.black, fontSize: 16),
          displayMedium: TextStyle(color: Colors.black, fontSize: 14),
          displaySmall: TextStyle(color: Colors.black87, fontSize: 12),
        ),

        // Icon theme
        iconTheme: IconThemeData(color: Colors.lightBlue),
        primaryIconTheme: IconThemeData(color: Colors.white),

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),

        // Card theme
        cardTheme: CardThemeData(
          color: Colors.white,
          shadowColor: Colors.black26,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.lightBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),

        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            shadowColor: Colors.black26,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.lightBlue),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.lightBlue,
            side: BorderSide(color: Colors.lightBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // FloatingActionButton theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          hoverColor: Colors.lightBlue[300],
          focusColor: Colors.lightBlue[700],
          iconSize: 24,
          elevation: 4,
          focusElevation: 6,
          hoverElevation: 6,
          highlightElevation: 8,
        ),

        // BottomNavigationBar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.lightBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.lightBlue[100],
          selectedIconTheme: IconThemeData(size: 28, color: Colors.white),
          unselectedIconTheme: IconThemeData(
            size: 24,
            color: Colors.lightBlue[100],
          ),
          selectedLabelStyle: TextStyle(
            color: Colors.lightBlue,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(color: Colors.black54),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.lightBlue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black38),
          ),
          labelStyle: TextStyle(color: Colors.black87),
          hintStyle: TextStyle(color: Colors.black54),
          prefixIconColor: Colors.black54,
          suffixIconColor: Colors.black54,
        ),

        // Drawer theme
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.white,
          scrimColor: Colors.black54,
        ),

        // ListTile theme
        listTileTheme: ListTileThemeData(
          textColor: Colors.black,
          iconColor: Colors.black54,
          selectedColor: Colors.lightBlue,
          selectedTileColor: Colors.lightBlue.withOpacity(0.1),
        ),

        // Divider theme
        dividerTheme: DividerThemeData(color: Colors.black12, thickness: 1),

        // Switch theme
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.lightBlue;
            }
            return Colors.white;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.lightBlue.withOpacity(0.5);
            }
            return Colors.black26;
          }),
        ),

        // Checkbox theme
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.lightBlue;
            }
            return Colors.white;
          }),
          checkColor: MaterialStateProperty.all(Colors.white),
          side: BorderSide(color: Colors.black54),
        ),

        // Radio theme
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.lightBlue;
            }
            return Colors.black54;
          }),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
