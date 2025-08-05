import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:
        'https://ycidrltgcbmpjpmuchnt.supabase.co', // Replace with your Project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InljaWRybHRnY2JtcGpwbXVjaG50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI1NTQ0MDEsImV4cCI6MjA2ODEzMDQwMX0.03kRJm4BFJpGEtLxZdoDtohMdpwtk5rGBM3NhY7H6II', // Replace with your Anon Key
  );
  runApp(ProviderScope(child: MyApp()));
}
