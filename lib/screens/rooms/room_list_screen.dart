import 'package:app_project/models/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/room_provider.dart';

class RoomListScreen extends ConsumerWidget {
  const RoomListScreen({super.key});
  // Tạo ID ngẫu nhiên cho phòng mới;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách phòng')),
      body: roomState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (rooms) => ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return ListTile(
              title: Text(room.name),
              subtitle: Text(room.isOccupied ? 'Đã thuê' : 'Trống'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Thêm phòng mới demo
          ref
              .read(roomProvider.notifier)
              .addRoom(Room(isOccupied: false, name: 'Phòng mới'));
        },
      ),
    );
  }
}
