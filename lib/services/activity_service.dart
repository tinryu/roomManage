import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity.dart';

class ActivityService {
  final supabase = Supabase.instance.client;
  final String tableName = 'activities';

  Future<List<Activity>> getRecentActivities({int limit = 10}) async {
    final response = await supabase.from(tableName).select();
    return (response as List)
        .map((item) => Activity.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // Get all activities for a specific room
  Future<List<Activity>> getActivitiesByRoom(String roomId) async {
    final response = await supabase
        .from(tableName)
        .select()
        .eq('room_id', roomId)
        .order('timestamp', ascending: false); // Order by latest activity

    return List<Activity>.from(response);
  }

  // Get activities for a specific user (optional)
  Future<List<Activity>> getActivitiesByUser(String userId) async {
    final response = await supabase
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false);

    return List<Activity>.from(response);
  }

  // Log a new activity
  Future<void> logActivity(Map<String, dynamic> activity) async {
    await supabase.from(tableName).insert(activity);
  }

  // Get all activities
  Future<List<Activity>> getAllActivities() async {
    final response = await supabase
        .from(tableName)
        .select()
        .order('timestamp', ascending: false);

    return List<Activity>.from(response);
  }

  // Delete an activity by ID
  Future<void> deleteActivity(String activityId) async {
    await supabase.from(tableName).delete().eq('id', activityId);
  }
}
