import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room.dart';

class RoomNotifier extends AsyncNotifier<List<Room>> {
  final _client = Supabase.instance.client;
  final String _table = 'rooms';

  static const int _pageSize = 1;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Room>> build() async {
    _offset = 0;
    _hasMore = true;
    return await _fetchRooms(reset: true);
  }

  Future<List<Room>> _fetchRooms({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final res = await _client
          .from(_table)
          .select()
          .order('created_at', ascending: false)
          .range(_offset, _offset + _pageSize - 1);
      final data = res as List;
      final fetched = data.map((e) => Room.fromMap(e)).toList();

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

  Future<void> addRoom(Room room) async {
    await _client.from(_table).insert(room.toMap()).select().single();
    state = AsyncValue.data(await _fetchRooms(reset: true));
  }

  Future<void> updateRoom(Room room) async {
    await _client.from(_table).update(room.toMap()).eq('id', room.id as Object);
    state = AsyncValue.data(await _fetchRooms(reset: true));
  }

  Future<void> deleteRoom(String id) async {
    await _client.from(_table).delete().eq('id', id);
    state = AsyncValue.data(await _fetchRooms(reset: true));
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

// Provider để dùng trong app
final roomProvider = AsyncNotifierProvider<RoomNotifier, List<Room>>(
  () => RoomNotifier(),
);
