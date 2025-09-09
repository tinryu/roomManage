// ignore_for_file: unnecessary_null_comparison

import 'package:app_project/models/room.dart';
import 'package:app_project/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Room model is used through provider
import 'package:app_project/models/asset.dart';
import 'package:app_project/providers/room_full_provider.dart';
import 'package:app_project/providers/asset_provider.dart';
import 'package:app_project/providers/room_provider.dart';
import 'package:app_project/screens/rooms/rooms_add_screen.dart';
import 'package:app_project/widgets/shared/base_list_screen.dart';

// Holds selected room IDs
final selectedRoomIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class RoomFullListScreen extends ConsumerStatefulWidget {
  const RoomFullListScreen({super.key});

  @override
  ConsumerState<RoomFullListScreen> createState() => _RoomFullListScreenState();
}

class _RoomFullListScreenState extends ConsumerState<RoomFullListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final notifier = ref.read(roomFullProvider.notifier);
      if (notifier.hasMore && !notifier.isLoadingMore) {
        notifier.fetchNextPage();
      }
    }
  }

  String formatPhone(String phone) {
    // Xoá ký tự không phải số
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    // Thêm dấu cách hoặc dấu gạch theo định dạng
    if (digits.length == 10) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }
    return phone;
  }

  // FutureProvider for assets - defined at class level
  static final _assetsProvider = FutureProvider.family<List<Asset>, List<int>>((
    ref,
    assetIds,
  ) async {
    if (assetIds.isEmpty) return [];
    return ref.read(assetProvider.notifier).fetchAssetsByIds(assetIds);
  });

  Widget _buildRoomAssets(List<int>? assetIds, BuildContext context) {
    if (assetIds == null || assetIds.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'No assets assigned to this room',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          textScaler: TextScaler.linear(0.8),
        ),
      );
    }

    return Consumer(
      builder: (context, ref, _) {
        final asyncAssets = ref.watch(_assetsProvider(assetIds));

        return asyncAssets.when(
          data: (assets) {
            if (assets.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No assets found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textScaler: TextScaler.linear(0.8),
                ),
              );
            }

            return SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text(
                        asset.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(0.8),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error loading assets: ${error.toString()}',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomFullAsync = ref.watch(roomFullProvider);
    final roomFullNotifier = ref.read(roomFullProvider.notifier);
    final roomNotifier = ref.read(roomProvider.notifier);
    final selectedIds = ref.watch(selectedRoomIdsProvider);
    return BaseListScreen(
      showAppBar: false,
      title: 'Rooms',
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRoomScreen()),
          );
        },
      ),
      body: roomFullAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (rooms) {
          if (rooms.isEmpty) {
            return const Center(child: Text('No room data found.'));
          }
          return Column(
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
                          final data = rooms;
                          if (data.isEmpty) return;
                          final pageIds = data
                              .where((r) => r.roomId != null)
                              .map((r) => r.roomId)
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
                                  ref.read(roomFullProvider).asData?.value ??
                                  [];
                              final id = selectedIds.first;
                              final room = rooms.firstWhere(
                                (r) => r.roomId == id,
                                orElse: () => rooms.first,
                              );
                              final roomEdit = Room(
                                id: room.roomId,
                                name: room.roomName,
                                is_occupied: room.isOccupied,
                                asset_ids: room.assetIds,
                                imageUrl: room.roomImage,
                                tenantId: room.tenantId,
                              );
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddRoomScreen(initialItem: roomEdit),
                                ),
                              );
                            },
                          ),
                          // Delete
                          IconButton(
                            tooltip: 'Delete',
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black45,
                            ),
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
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
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
                                await roomNotifier.deleteRooms(
                                  selectedIds.toList(),
                                );
                                ref
                                        .read(selectedRoomIdsProvider.notifier)
                                        .state =
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
                                    SnackBar(
                                      content: Text('Delete failed: $e'),
                                    ),
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
                  controller: _scrollController,
                  itemCount:
                      rooms.length +
                      (ref.watch(roomFullProvider.notifier).hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == rooms.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final item = rooms[index];
                    final isSelected =
                        item.roomId != null &&
                        selectedIds.contains(item.roomId);

                    return BaseListTile(
                      selected: isSelected,
                      onTap: item.roomId == null
                          ? null
                          : () {
                              final selected = ref.read(
                                selectedRoomIdsProvider.notifier,
                              );
                              final current = ref.read(selectedRoomIdsProvider);
                              if (isSelected) {
                                selected.state = current.difference({
                                  item.roomId,
                                });
                              } else {
                                selected.state = {...current, item.roomId};
                              }
                            },
                      title: item.roomName,
                      showTitle: false,
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "Room Info:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                textScaler: TextScaler.linear(0.8),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                spacing: 8,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                          ),
                                          border: Border.all(
                                            color: Colors.blue[100]!,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          item.roomName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                          border: Border.fromBorderSide(
                                            BorderSide(
                                              color: Colors.blue[100]!,
                                            ),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          item.isOccupied
                                              ? 'Occupied'
                                              : 'Vacant',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      item.roomImage != null &&
                                              item.roomImage!.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                item.roomImage!,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stack,
                                                    ) => Container(
                                                      width: 50,
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.all(
                                                            12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .lightBlue[100],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              Colors.lightBlue,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.white,
                                                        size: 24,
                                                      ),
                                                    ),
                                              ),
                                            )
                                          : Container(
                                              width: 50,
                                              height: 50,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlue[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.lightBlue,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.meeting_room_outlined,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "Room Tenant:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                textScaler: TextScaler.linear(0.8),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                spacing: 8,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.tenantName ?? 'No Tenant',
                                            textScaler: const TextScaler.linear(
                                              0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.phone, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            formatPhone(item.phone ?? 'N/A'),
                                            textScaler: const TextScaler.linear(
                                              0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.event_available, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.checkin != null
                                                ? appFormatDate(
                                                    context,
                                                    item.checkin!,
                                                  )
                                                : 'N/A',
                                            textScaler: const TextScaler.linear(
                                              0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.event_busy, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.checkout != null
                                                ? appFormatDate(
                                                    context,
                                                    item.checkout!,
                                                  )
                                                : 'N/A',
                                            textScaler: const TextScaler.linear(
                                              0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Room Assets:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textScaler: TextScaler.linear(0.8),
                                ),
                              ),
                              _buildRoomAssets(item.assetIds, context),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (roomFullNotifier.hasMore)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: roomFullNotifier.isLoadingMore
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: roomFullNotifier.fetchNextPage,
                          child: Text('Load More'),
                        ),
                ),
            ],
          );
        },
      ),
    );
  }
}
