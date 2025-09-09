import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/room.dart';
import 'package:app_project/providers/room_full_provider.dart';

class RoomNotifier extends AsyncNotifier<List<Room>> {
  final supabase = Supabase.instance.client;
  final String _table = 'rooms';

  static const int _pageSize = 5;
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

  Future<String?> _uploadImage(File file) async {
    try {
      final fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";
      await supabase.storage.from('images').upload(fileName, file);
      return supabase.storage.from('images').getPublicUrl(fileName);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<Room?> addRoom({
    required String name,
    required bool isOccupied,
    List<int>? assetIds,
    File? imageFile,
    int? tenantId,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      // Pass assetIds directly as a list, Supabase will handle the JSON serialization
      final response = await supabase.rpc(
        'add_room_with_tenant',
        params: {
          'p_name': name,
          'p_is_occupied': isOccupied,
          'p_asset_ids': assetIds, // Pass the list directly
          'p_image_url': imageUrl,
          'p_tenant_id': tenantId,
        },
      );

      if (response != null) {
        final newRoom = Room.fromMap(response);
        // Update the local state
        final current = state.value ?? [];
        state = AsyncData([newRoom, ...current]);
        await refreshRoomFullData();
        return newRoom;
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
    return null;
  }

  Future<Room?> updateRoom({
    required int id,
    required String name,
    required bool isOccupied,
    List<int>? assetIds,
    File? imageFile,
    String? imageUrl,
    int? tenantId,
  }) async {
    try {
      // Handle image upload if needed
      String? imageUpload;
      if (imageFile != null) {
        imageUpload = await _uploadImage(imageFile);
      }

      // Pass assetIds directly as a list, Supabase will handle the JSON serialization
      final response = await supabase.rpc(
        'update_room_with_tenant',
        params: {
          'p_id': id,
          'p_name': name,
          'p_is_occupied': isOccupied,
          'p_asset_ids': assetIds, // Pass the list directly
          'p_image_url': imageUpload ?? imageUrl,
          'p_tenant_id': tenantId,
        },
      );

      if (response != null) {
        final updatedRoom = Room.fromMap(response);
        // Update local state
        final current = state.value ?? [];
        state = AsyncData([
          for (final room in current)
            if (room.id == id) updatedRoom else room,
        ]);
        await refreshRoomFullData();
        return updatedRoom;
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
    return null;
  }

  Future<void> deleteRoom(int id) async {
    try {
      await supabase.from(_table).delete().eq('id', id);
      final current = state.value ?? [];
      state = AsyncValue.data(current.where((r) => r.id != id).toList());
      await refreshRoomFullData();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteRooms(List<int> ids) async {
    if (ids.isEmpty) return;

    try {
      // Delete rooms using the 'in' filter
      await supabase.from(_table).delete().inFilter('id', ids);
      final current = state.value ?? [];
      state = AsyncValue.data(
        current.where((r) => !ids.contains(r.id)).toList(),
      );
      await refreshRoomFullData();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  // Method to refresh room full data with optional delay
  Future<void> refreshRoomFullData({
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    try {
      // Add a small delay to allow UI to update first
      await Future.delayed(delay);

      // Get the RoomFullNotifier instance
      final roomFullNotifier = ref.read(roomFullProvider.notifier);
      // Call the public fetchRooms method
      await roomFullNotifier.fetchRooms(reset: true);
    } catch (e) {
      // Handle any errors
      if (kDebugMode) {
        log('Error refreshing room full data: $e');
      }
      rethrow;
    }
  }
}

// Provider để dùng trong app
final roomProvider = AsyncNotifierProvider<RoomNotifier, List<Room>>(
  () => RoomNotifier(),
);
