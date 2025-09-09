import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/dashboard.dart';
import 'package:app_project/models/payment.dart';
import 'package:app_project/models/activity.dart';
import 'package:app_project/models/task.dart';

class DashboardProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;

  DashboardData? _dashboard;
  bool _isLoading = false;
  List<Payment> _recentPayments = const [];
  List<Activity> _recentActivities = const [];
  List<Task> _upcomingTasks = const [];

  DashboardData? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  List<Payment> get recentPayments => _recentPayments;
  List<Activity> get recentActivities => _recentActivities;
  List<Task> get upcomingTasks => _upcomingTasks;

  Future<void> fetchDashboard({int homeLimit = 5, int taskLimit = 3}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final end = start.add(Duration(days: 1));

      // Fetch in parallel: revenue, rooms, checkins today, active users, damaged assets,
      // plus recent payments and recent activities
      final results = await Future.wait([
        _client
            .from('payments')
            .select('amount')
            .eq('isPaid', true)
            .gte('datetime', start.toIso8601String())
            .lt('datetime', end.toIso8601String()),
        _client.from('rooms').select('is_occupied'),
        _client
            .from('tenants')
            .select()
            .gte('checkin', start.toIso8601String())
            .lt('checkin', end.toIso8601String()),
        _client
            .from('tenants')
            .select()
            .lte('checkin', now.toIso8601String())
            .gte('checkout', now.toIso8601String()),
        _client.from('assets').select().eq('condition', 'damaged'),
        // Recent payments in current month
        _client
            .from('payments')
            .select()
            .gte('datetime', DateTime(now.year, now.month, 1).toIso8601String())
            .lt(
              'datetime',
              DateTime(now.year, now.month + 1, 1).toIso8601String(),
            )
            .order('datetime', ascending: true)
            .limit(homeLimit),
        // Recent activities in current month
        _client
            .from('activities')
            .select()
            .gte(
              'timestamp',
              DateTime(now.year, now.month, 1).toIso8601String(),
            )
            .lt(
              'timestamp',
              DateTime(now.year, now.month + 1, 1).toIso8601String(),
            )
            .order('timestamp', ascending: true)
            .limit(homeLimit),
        // Upcoming tasks in current month
        _client
            .from('tasks')
            .select()
            .gte(
              'created_at',
              DateTime(now.year, now.month, 1).toIso8601String(),
            )
            .lt(
              'created_at',
              DateTime(now.year, now.month + 1, 1).toIso8601String(),
            )
            .order('created_at', ascending: true)
            .limit(taskLimit),
      ]);

      final payments = results[0] as List<dynamic>;
      final rooms = results[1] as List<dynamic>;
      final checkins = results[2] as List<dynamic>;
      final activeUsers = results[3] as List<dynamic>;
      final damagedAssets = results[4] as List<dynamic>;
      final recentPaysRaw = results[5] as List<dynamic>;
      final recentActsRaw = results[6] as List<dynamic>;
      final upcomingTasksRaw = results[7] as List<dynamic>;

      final todayRevenue = payments.fold<int>(
        0,
        (sum, row) => sum + (row['amount'] as int),
      );
      final occupied = rooms.where((r) => r['is_occupied'] == true).length;
      final occupancyRate = rooms.isEmpty
          ? 0.0
          : (occupied / rooms.length) * 100;

      _dashboard = DashboardData(
        todayRevenue: todayRevenue,
        availableRooms: rooms.length - occupied,
        todayCheckins: checkins.length,
        occupancyRate: occupancyRate,
        activeUsers: activeUsers.length,
        damagedAssets: damagedAssets.length,
      );

      _recentPayments = recentPaysRaw
          .map((e) => Payment.fromMap(e as Map<String, dynamic>))
          .toList();
      _recentActivities = recentActsRaw
          .map((e) => Activity.fromMap(e as Map<String, dynamic>))
          .toList();
      _upcomingTasks = upcomingTasksRaw
          .map((e) => Task.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching dashboard: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
