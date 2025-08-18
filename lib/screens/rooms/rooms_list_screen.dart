import 'package:app_project/screens/rooms/rooms_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/room_provider.dart';

// Holds selected room IDs
final selectedRoomIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class RoomListScreen extends ConsumerWidget {
  const RoomListScreen({super.key});
  // Tạo ID ngẫu nhiên cho phòng mới;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomProvider);
    final notifier = ref.read(roomProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: IconButton(
            tooltip: 'Select All',
            icon: const Icon(Icons.select_all, color: Colors.black45),
            onPressed: () {
              final selected = ref.read(selectedRoomIdsProvider.notifier);
              final current = ref.read(selectedRoomIdsProvider);
              final data = roomState.asData?.value ?? [];
              if (data.isEmpty) return;
              final pageIds = data
                  .where((r) => r.id != null)
                  .map((r) => r.id!)
                  .toSet();
              final allSelected =
                  pageIds.isNotEmpty && pageIds.difference(current).isEmpty;
              selected.state = allSelected
                  ? (current.difference(pageIds))
                  : ({...current, ...pageIds});
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                // Edit
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit, color: Colors.black45),
                  onPressed: () async {
                    final selectedIds = ref.read(selectedRoomIdsProvider);
                    if (selectedIds.length != 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select exactly one room to edit'),
                        ),
                      );
                      return;
                    }
                    final rooms = ref.read(roomProvider).asData?.value ?? [];
                    final id = selectedIds.first;
                    final room = rooms.firstWhere(
                      (r) => r.id == id,
                      orElse: () => rooms.first,
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddRoomScreen(initialRoom: room),
                      ),
                    );
                  },
                ),
                // Delete
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete, color: Colors.black45),
                  onPressed: () async {
                    final selectedIds = ref.read(selectedRoomIdsProvider);
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
                      ref.read(selectedRoomIdsProvider.notifier).state = {};
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
          ),
        ],
      ),
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
                  final selectedIds = ref.watch(selectedRoomIdsProvider);
                  final isChecked =
                      room.id != null && selectedIds.contains(room.id!);
                  return ListTile(
                    onTap: room.id == null
                        ? null
                        : () {
                            final sel = ref.read(
                              selectedRoomIdsProvider.notifier,
                            );
                            final next = {...selectedIds};
                            if (isChecked) {
                              next.remove(room.id!);
                            } else {
                              next.add(room.id!);
                            }
                            sel.state = next;
                          },
                    leading: Checkbox(
                      value: isChecked,
                      onChanged: room.id == null
                          ? null
                          : (v) {
                              final sel = ref.read(
                                selectedRoomIdsProvider.notifier,
                              );
                              final next = {...selectedIds};
                              if (v == true) {
                                next.add(room.id!);
                              } else {
                                next.remove(room.id!);
                              }
                              sel.state = next;
                            },
                    ),
                    subtitle: Row(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        room.imageUrl != null && room.imageUrl!.isNotEmpty
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textScaler: TextScaler.linear(0.8),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              room.isOccupied ? 'Đã thuê' : 'Trống',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textScaler: TextScaler.linear(0.8),
                            ),
                          ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRoomScreen()),
          );
        },
      ),
    );
  }
}
