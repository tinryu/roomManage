import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/room_full.dart';

class RoomFullNotifier extends AsyncNotifier<List<RoomFull>> {
  final supabase = Supabase.instance.client;
  final String _table = 'room_full_view';

  static const int _pageSize = 5;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<RoomFull>> build() async {
    _offset = 0;
    _hasMore = true;
    return await _fetchRooms(reset: true);
  }

  // Public method to fetch rooms
  Future<List<RoomFull>> fetchRooms({bool reset = false}) async {
    if (reset) {
      _offset = 0;
      _hasMore = true;
    }
    return await _fetchRooms(reset: reset);
  }

  Future<List<RoomFull>> _fetchRooms({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final res = await supabase
          .from(_table)
          .select()
          .order('room_name', ascending: true)
          .range(_offset, _offset + _pageSize - 1);

      final data = res as List;
      final fetched = data.map((e) => RoomFull.fromMap(e)).toList();

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
      await _fetchRooms();
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final roomFullProvider =
    AsyncNotifierProvider<RoomFullNotifier, List<RoomFull>>(
      () => RoomFullNotifier(),
    );
