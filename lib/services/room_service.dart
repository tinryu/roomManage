import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room.dart';

class RoomService {
  final _client = Supabase.instance.client;
  final String _table = 'rooms';

  // Lấy danh sách phòng
  Future<List<Room>> getAllRooms() async {
    final response = await _client.from(_table).select();
    return (response as List)
        .map((item) => Room.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // Thêm phòng
  Future<void> addRoom(Room room) async {
    await _client.from(_table).insert(room.toMap());
  }

  // Cập nhật phòng
  Future<void> updateRoom(Room room) async {
    await _client.from(_table).update(room.toMap()).eq('id', room.id as Object);
  }

  // Xoá phòng
  Future<void> deleteRoom(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }

  // Lấy 1 phòng theo ID
  Future<Room?> getRoomById(String id) async {
    final response = await _client.from(_table).select().eq('id', id).single();
    return Room.fromMap(response);
  }

  // Cập nhật trạng thái thuê
  Future<void> updateOccupied(
    String id,
    bool isOccupied, {
    String? tenantId,
  }) async {
    await _client
        .from(_table)
        .update({
          'isOccupied': isOccupied,
          'tenantId': isOccupied ? tenantId : null,
        })
        .eq('id', id);
  }
}
