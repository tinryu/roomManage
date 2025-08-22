import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/screens/tenants/login_screen.dart';
import 'package:app_project/screens/main_screen.dart';

/// AuthGate listens to Supabase auth state changes and shows the right screen.
/// It also reacts to email confirmation links (deep links) that sign the user in.
class AuthGate extends StatefulWidget {
  final void Function(Locale locale)? onLocaleChange;
  final void Function(ThemeMode mode)? onThemeChange;
  final ThemeMode? currentThemeMode;
  final Future<void> Function()? onResetOnboarding;

  const AuthGate({
    super.key,
    this.onLocaleChange,
    this.onThemeChange,
    this.currentThemeMode,
    this.onResetOnboarding,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? _session;
  late final StreamSubscription<AuthState> _sub;

  @override
  void initState() {
    super.initState();
    final auth = Supabase.instance.client.auth;
    _session = auth.currentSession;

    _sub = auth.onAuthStateChange.listen((data) {
      setState(() {
        // When user confirms email and the app is opened via deep link,
        // Supabase emits signedIn with a valid session.
        _session = auth.currentSession;
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_session == null) {
      return const LoginScreen();
    }
    return MainScreen(
      onLocaleChange: widget.onLocaleChange ?? (_) {},
      onThemeChange: widget.onThemeChange ?? (_) {},
      currentThemeMode: widget.currentThemeMode ?? ThemeMode.light,
      onResetOnboarding: widget.onResetOnboarding ?? (() async {}),
    );
  }
}
