import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/onboarding_provider.dart';
import 'providers/dashboard_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://ycidrltgcbmpjpmuchnt.supabase.co', // Replace with your Project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InljaWRybHRnY2JtcGpwbXVjaG50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI1NTQ0MDEsImV4cCI6MjA2ODEzMDQwMX0.03kRJm4BFJpGEtLxZdoDtohMdpwtk5rGBM3NhY7H6II', // Replace with your Anon Key
  );

  // Preload onboarding flag and inject into Riverpod at bootstrap time
  final prefs = await SharedPreferences.getInstance();
  final seen = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(),
        ),
      ],
      child: ProviderScope(
        overrides: [seenOnboardingProvider.overrideWith((ref) => seen)],
        child: const MyApp(),
      ),
    ),
  );
}
