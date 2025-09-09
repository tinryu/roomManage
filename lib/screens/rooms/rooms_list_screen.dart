import 'package:app_project/screens/rooms/rooms_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/room_provider.dart';
import 'package:app_project/widgets/shared/base_list_screen.dart';

// Holds selected room IDs
final selectedRoomIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class RoomListScreen extends ConsumerWidget {
  const RoomListScreen({super.key});
  // Tạo ID ngẫu nhiên cho phòng mới;

  // Method to handle room deletion confirmation
  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    List<int> roomIds,
    RoomNotifier notifier,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Rooms'),
        content: Text('Delete ${roomIds.length} selected room(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await notifier.deleteRooms(roomIds);
        if (context.mounted) {
          ref.read(selectedRoomIdsProvider.notifier).state = {};
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rooms deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete rooms: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomProvider);
    final notifier = ref.read(roomProvider.notifier);
    final selectedRoomIds = ref.watch(selectedRoomIdsProvider);

    return BaseListScreen(
      title: 'Rooms',
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRoomScreen()),
          );
          ref.invalidate(roomProvider);
        },
      ),
      body: roomState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (rooms) => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'Select All',
                      icon: const Icon(Icons.select_all, color: Colors.grey),
                      onPressed: () {
                        final selected = ref.read(
                          selectedRoomIdsProvider.notifier,
                        );
                        final current = ref.read(selectedRoomIdsProvider);
                        final data = roomState.asData?.value ?? [];
                        if (data.isEmpty) return;
                        final pageIds = data
                            .where((r) => r.id != null)
                            .map((r) => r.id!)
                            .toSet();
                        final allSelected =
                            pageIds.isNotEmpty &&
                            pageIds.difference(current).isEmpty;
                        selected.state = allSelected
                            ? (current.difference(pageIds))
                            : ({...current, ...pageIds});
                      },
                    ),
                    Row(
                      children: [
                        // Edit
                        IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () async {
                            final selectedIds = ref.read(
                              selectedRoomIdsProvider,
                            );
                            if (selectedIds.length != 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Select exactly one room to edit',
                                  ),
                                ),
                              );
                              return;
                            }
                            final rooms =
                                ref.read(roomProvider).asData?.value ?? [];
                            final id = selectedIds.first;
                            final room = rooms.firstWhere(
                              (r) => r.id == id,
                              orElse: () => rooms.first,
                            );
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddRoomScreen(initialRoom: room),
                              ),
                            );
                          },
                        ),
                        // Delete
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete, color: Colors.black45),
                          onPressed: () async {
                            final selectedIds = ref.read(
                              selectedRoomIdsProvider,
                            );
                            if (selectedIds.isEmpty) return;
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete rooms'),
                                content: Text(
                                  'Delete ${selectedIds.length} selected room(s)?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm != true) return;
                            try {
                              await notifier.deleteRooms(selectedIds.toList());
                              ref.read(selectedRoomIdsProvider.notifier).state =
                                  {};
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Deleted selected rooms'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Delete failed: $e')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final isSelected =
                      room.id != null && selectedRoomIds.contains(room.id!);

                  return BaseListTile(
                    title: room.name,
                    subtitle: Text(
                      room.is_occupied ? 'Occupied' : 'Available',
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: room.imageUrl?.isNotEmpty == true
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              room.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              room.is_occupied
                                  ? Icons.meeting_room
                                  : Icons.meeting_room_outlined,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),

                    selected: isSelected,
                    onTap: room.id == null
                        ? null
                        : () {
                            final selected = ref.read(
                              selectedRoomIdsProvider.notifier,
                            );
                            final current = ref.read(selectedRoomIdsProvider);
                            if (isSelected) {
                              selected.state = current.difference({room.id!});
                            } else {
                              selected.state = {...current, room.id!};
                            }
                          },
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
    );
  }
}
