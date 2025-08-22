import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'screens/main_screen.dart';
import 'widgets/auth_gate.dart';
// import 'package:app_project/screens/tenants/login_screen.dart' show LoginScreen;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/onboarding_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Locale _locale = Locale('en');
  final user = Supabase.instance.client.auth.currentUser;
  ThemeMode _themeMode = ThemeMode.light;
  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  Future<void> _setSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    ref.read(seenOnboardingProvider.notifier).state = true;
  }

  Future<void> _resetSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', false);
    ref.read(seenOnboardingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final seen = ref.watch(seenOnboardingProvider);
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
      home: !seen
          ? OnboardingScreen(onFinish: _setSeenOnboarding)
          : AuthGate(
              onLocaleChange: _changeLanguage,
              onThemeChange: _changeTheme,
              currentThemeMode: _themeMode,
              onResetOnboarding: _resetSeenOnboarding,
            ),
      themeMode: _themeMode,
      theme: ThemeData(
        fontFamily: 'Roboto',
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
        textTheme: GoogleFonts.interTextTheme(
          TextTheme(
            bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
            bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
            bodySmall: TextStyle(fontSize: 12, color: Colors.black),
            labelLarge: TextStyle(fontSize: 16, color: Colors.black),
            labelMedium: TextStyle(fontSize: 14, color: Colors.black),
            labelSmall: TextStyle(fontSize: 12, color: Colors.black),
            titleLarge: TextStyle(fontSize: 16, color: Colors.black),
            titleMedium: TextStyle(fontSize: 14, color: Colors.black),
            titleSmall: TextStyle(fontSize: 12, color: Colors.black),
            headlineLarge: TextStyle(fontSize: 16, color: Colors.black),
            headlineMedium: TextStyle(fontSize: 14, color: Colors.black),
            headlineSmall: TextStyle(fontSize: 12, color: Colors.black),
            displayLarge: TextStyle(fontSize: 16, color: Colors.black),
            displayMedium: TextStyle(fontSize: 14, color: Colors.black),
            displaySmall: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),

        // Icon theme
        iconTheme: IconThemeData(color: Colors.white),

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 0,
        ),

        // Card theme
        cardTheme: CardThemeData(
          shadowColor: Colors.black26,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.lightBlue.withValues(alpha: 0.2),
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
          selectedTileColor: Colors.lightBlue.withValues(alpha: 0.1),
        ),

        // Divider theme
        dividerTheme: DividerThemeData(color: Colors.black12, thickness: 1),

        // Switch theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.lightBlue;
            }
            return Colors.white;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.lightBlue.withValues(alpha: 0.5);
            }
            return Colors.black26;
          }),
        ),

        // Checkbox theme
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.lightBlue;
            }
            return Colors.white;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: Colors.black54),
        ),

        // Radio theme
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.lightBlue;
            }
            return Colors.black54;
          }),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightBlue,
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.lightBlue,
          secondary: Colors.lightBlue[300]!,
          surface: const Color(0xFF121212),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(
          const TextTheme(
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 14),
            bodySmall: TextStyle(fontSize: 12),
          ),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        iconTheme: const IconThemeData(color: Colors.lightBlue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          shadowColor: Colors.black54,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.lightBlue.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white54),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIconColor: Colors.white70,
          suffixIconColor: Colors.white70,
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.white70,
          thickness: 1,
        ),
        listTileTheme: ListTileThemeData(textColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
