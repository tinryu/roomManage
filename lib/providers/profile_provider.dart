import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/profile.dart';

class ProfileNotifier extends AsyncNotifier<Profile?> {
  late final SupabaseClient _supabase;

  @override
  Future<Profile?> build() async {
    _supabase = Supabase.instance.client;
    return fetchMyProfile();
  }

  Future<Profile?> fetchMyProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      state = const AsyncData(null);
      return null;
    }
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (data == null) {
        state = const AsyncData(null);
        return null;
      }
      final profile = Profile.fromMap(data);
      state = AsyncData(profile);
      return profile;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? avatarUrl,
  }) async {
    final user = _supabase.auth.currentUser;
    final now = DateTime.now().toIso8601String();
    if (user == null) throw StateError('Not signed in');
    final payload = Profile(
      id: user.id,
      username: username,
      fullName: fullName,
      avatarUrl: avatarUrl,
    ).toUpdateMap();
    // Always bump the updated_at timestamp
    payload['updated_at'] = now;
    if (payload.isEmpty) return;
    final updated = await _supabase
        .from('profiles')
        .update(payload)
        .eq('id', user.id)
        .select()
        .maybeSingle();
    if (updated != null) {
      state = AsyncData(Profile.fromMap(updated));
    }
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);
