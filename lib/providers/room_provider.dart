import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/room.dart';

class RoomNotifier extends AsyncNotifier<List<Room>> {
  final supabase = Supabase.instance.client;
  final String _table = 'rooms';

  static const int _pageSize = 10;
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
      final res = await supabase
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
    try {
      final data = {
        'name': room.name,
        'isOccupied': room.isOccupied,
        'assetId': room.assetId,
        'image_url': room.imageUrl,
        'tenantId': room.tenantId,
      };
      final res = await supabase.from(_table).insert(data).select().single();

      final newRoom = Room.fromMap(res);
      final current = state.value ?? [];
      state = AsyncData([newRoom, ...current]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateRoom(Room room) async {
    if (room.id == null) return;
    try {
      final data = {
        'name': room.name,
        'isOccupied': room.isOccupied,
        'assetId': room.assetId,
        'image_url': room.imageUrl,
        'tenantId': room.tenantId,
      };
      final res = await supabase
          .from(_table)
          .update(data)
          .eq('id', room.id!)
          .select()
          .maybeSingle();

      if (res == null) {
        throw StateError('No room found with id ${room.id} to update');
      }
      final updated = Room.fromMap(res);
      final current = state.value ?? [];
      state = AsyncData(
        current.map((r) => r.id == updated.id ? updated : r).toList(),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteRoom(int id) async {
    await supabase.from(_table).delete().eq('id', id);
    final current = state.value ?? [];
    state = AsyncData(current.where((r) => r.id != id).toList());
  }

  Future<void> deleteRooms(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      await supabase.from(_table).delete().inFilter('id', ids);
      final idSet = ids.toSet();
      final current = state.value ?? [];
      state = AsyncData(
        current.where((r) => !(r.id != null && idSet.contains(r.id))).toList(),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

// Provider để dùng trong app
final roomProvider = AsyncNotifierProvider<RoomNotifier, List<Room>>(
  () => RoomNotifier(),
);
