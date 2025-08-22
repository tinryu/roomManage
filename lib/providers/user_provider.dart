import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// User provider backed by Supabase Auth.
///
/// Notes on getUserById:
/// - In client apps (public anon key), you can only fetch the CURRENT authenticated user
///   via `auth.getUser()` or `auth.currentUser`.
/// - Fetching arbitrary users by ID requires the Admin API (service role key), which must
///   never be embedded in a client app. If you need arbitrary user lookup, mirror auth users
///   into a public table (e.g., `profiles`) and query that instead.
class UserNotifier extends AsyncNotifier<User?> {
  late final SupabaseClient _supabase;

  @override
  Future<User?> build() async {
    _supabase = Supabase.instance.client;
    // Initialize with the currently authenticated user, if any
    final current = _supabase.auth.currentUser;
    return current;
  }

  /// Sign up a new user via Supabase Auth.
  /// Returns the [AuthResponse] which includes [Session?] and [User?].
  Future<AuthResponse> addUser({
    required String email,
    required String password,
    Map<String, dynamic>? data, // optional user metadata stored in auth
    String? emailRedirectTo, // optional confirm email deep link
  }) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: data,
      emailRedirectTo: emailRedirectTo,
    );

    // Update state if this device becomes authenticated immediately
    // (depending on your Auth settings, email confirmation may be required)
    state = AsyncData(res.user ?? _supabase.auth.currentUser);

    // If authenticated session exists, create profile row
    if ((res.session ?? _supabase.auth.currentSession) != null &&
        res.user != null) {
      try {
        await _supabase.from('profiles').insert({
          'id': res.user!.id,
          'username': (data?['username'] as String?) ?? '',
        });
      } catch (e) {
        // Optional: log but don't fail signup flow
      }
    }
    return res;
  }

  /// Send password reset email. Requires Email provider + SMTP configured in Supabase.
  /// Optionally specify a [redirectTo] URL (deep link) that handles the recovery flow.
  Future<void> sendPasswordResetEmail(String email, {String? redirectTo}) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
  }

  /// After the user is in a password recovery session (from the email link),
  /// call this to update the password.
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Get the CURRENT authenticated user.
  /// For arbitrary users, see notes above.
  Future<User?> getCurrentUser() async {
    final res = await _supabase.auth.getUser();
    final user = res.user;
    state = AsyncData(user);
    return user;
  }

  /// Try to get a user by ID within client constraints.
  /// - If [userId] matches the current user's id, returns it.
  /// - Otherwise throws [UnsupportedError]. See class docs for alternatives.
  Future<User?> getUserById(String userId) async {
    final res = await _supabase.auth.getUser();
    final current = res.user;
    if (current != null && current.id == userId) {
      state = AsyncData(current);
      return current;
    }
    throw UnsupportedError(
      'Client apps cannot fetch arbitrary auth users by ID. '
      'Mirror users into a public table (e.g., profiles) or call an edge function/server with a service role.',
    );
  }

  /// Sign out the current user and clear state.
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    state = const AsyncData(null);
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(
  () => UserNotifier(),
);
