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
    final notifier = ref.read(roomProvider.notifier);

    return Scaffold(
      body: roomState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (rooms) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return ListTile(
                    leading: room.imageUrl != null && room.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              room.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.lightBlue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Icon(
                              Icons.inventory_2,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                    title: Text(
                      room.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textScaler: TextScaler.linear(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          room.isOccupied ? 'Đã thuê' : 'Trống',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.linear(0.8),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (notifier.hasMore)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: notifier.isLoadingMore
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: notifier.fetchNextPage,
                        child: Text('Load More'),
                      ),
              ),
          ],
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
