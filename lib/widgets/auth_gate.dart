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
  final Future<void> Function(Session session)? onConfirmed; // optional hook

  const AuthGate({
    super.key,
    this.onLocaleChange,
    this.onThemeChange,
    this.currentThemeMode,
    this.onResetOnboarding,
    this.onConfirmed,
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

    _sub = auth.onAuthStateChange.listen((data) async {
      final previous = _session;
      setState(() {
        // When user confirms email and the app is opened via deep link,
        // Supabase emits signedIn with a valid session.
        _session = auth.currentSession;
      });

      // Transition from no session to a valid session => confirmation success
      if (previous == null && _session != null) {
        if (mounted) {
          // Optional custom action for the app (e.g., fetch profile, route, analytics)
          if (widget.onConfirmed != null) {
            await widget.onConfirmed!(_session!);
          }
          // User feedback
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Email confirmed. You are now signed in.'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
        }
      }
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
