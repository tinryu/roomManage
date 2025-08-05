import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room.dart';

class RoomNotifier extends AsyncNotifier<List<Room>> {
  final _client = Supabase.instance.client;
  final String _table = 'rooms';

  @override
  Future<List<Room>> build() async {
    return await fetchRooms();
  }

  Future<List<Room>> fetchRooms() async {
    final response = await _client.from(_table).select();
    return (response as List)
        .map((item) => Room.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addRoom(Room room) async {
    await _client.from(_table).insert(room.toMap()).select().single();
    // Refresh state
    state = AsyncValue.data([...state.value ?? [], room]);
  }

  Future<void> updateRoom(Room room) async {
    await _client.from(_table).update(room.toMap()).eq('id', room.id as Object);
    final updatedList = state.value!
        .map((r) => r.id == room.id ? room : r)
        .toList();
    state = AsyncValue.data(updatedList);
  }

  Future<void> deleteRoom(String id) async {
    await _client.from(_table).delete().eq('id', id);
    // ignore: unrelated_type_equality_checks
    state = AsyncValue.data(state.value!.where((r) => r.id != id).toList());
  }
}

// Provider để dùng trong app
final roomProvider = AsyncNotifierProvider<RoomNotifier, List<Room>>(
  RoomNotifier.new,
);
