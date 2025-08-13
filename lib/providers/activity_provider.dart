import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/activity.dart';

class ActivityNotifier extends AsyncNotifier<List<Activity>> {
  final supabase = Supabase.instance.client;
  final String _table = 'activities';

  static const int _pageSize = 10;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Activity>> build() async {
    _offset = 0;
    _hasMore = true;
    return await _fetchPage(reset: true);
  }

  Future<List<Activity>> _fetchPage({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final response = await supabase
          .from(_table)
          .select()
          .order('timestamp', ascending: false)
          .range(_offset, _offset + _pageSize - 1);

      final data = response as List;
      final fetched = data.map((e) => Activity.fromMap(e)).toList();

      if (reset) {
        _offset = fetched.length;
        state = AsyncData(fetched);
      } else {
        _offset += fetched.length;
        final current = state.value ?? [];
        state = AsyncData([...current, ...fetched]);
      }

      if (fetched.length < _pageSize) {
        _hasMore = false;
      }

      return fetched;
    } catch (e, st) {
      if (reset) {
        state = AsyncError(e, st);
      }
      return [];
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> fetchNextPage() async {
    if (_hasMore) {
      await _fetchPage();
    }
  }

  Future<void> addActivity(Activity activity) async {
    await supabase.from(_table).insert(activity.toMap()).select().single();
    // Refresh state
    state = AsyncValue.data([...state.value ?? [], activity]);
  }

  Future<List<Activity>> getMonthlyActivitys({int? year, int? month}) async {
    final now = DateTime.now();
    final selectedYear = year ?? now.year;
    final selectedMonth = month ?? now.month;

    // Start and end of the month
    final start = DateTime(selectedYear, selectedMonth, 1);
    final end = DateTime(
      selectedYear,
      selectedMonth + 1,
      1,
    ).subtract(Duration(seconds: 1));

    final response = await supabase
        .from(_table)
        .select()
        .gte('timestamp', start.toIso8601String())
        .lte('timestamp', end.toIso8601String())
        .order('timestamp', ascending: true)
        .limit(5);

    return (response as List)
        .map((item) => Activity.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final activityProvider =
    AsyncNotifierProvider<ActivityNotifier, List<Activity>>(
      () => ActivityNotifier(),
    );
