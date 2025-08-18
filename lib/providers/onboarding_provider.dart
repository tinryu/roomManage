import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds whether the user has already seen the onboarding flow.
/// Default is false; real initial value is overridden in main() using ProviderScope.overrides.
final seenOnboardingProvider = StateProvider<bool>((ref) => false);
