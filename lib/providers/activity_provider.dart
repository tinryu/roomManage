import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity.dart';

class ActivityNotifier extends AsyncNotifier<List<Activity>> {
  final _client = Supabase.instance.client;
  final String _table = 'activities';

  @override
  Future<List<Activity>> build() async {
    return await getRecentActivities();
  }

  Future<List<Activity>> fetchActivities() async {
    final response = await _client
        .from(_table)
        .select()
        .order('timestamp', ascending: false);
    return (response as List)
        .map((item) => Activity.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Activity>> getRecentActivities({int limit = 10}) async {
    final response = await _client
        .from(_table)
        .select()
        .order('timestamp', ascending: false)
        .limit(limit);
    return (response as List)
        .map((item) => Activity.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addActivity(Activity activity) async {
    await _client.from(_table).insert(activity.toMap()).select().single();
    // Refresh state
    state = AsyncValue.data([...state.value ?? [], activity]);
  }
}

final activityProvider =
    AsyncNotifierProvider<ActivityNotifier, List<Activity>>(
      ActivityNotifier.new,
    );
