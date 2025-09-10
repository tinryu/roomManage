// ignore_for_file: unnecessary_null_comparison
import 'package:app_project/utils/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/asset_provider.dart';
import 'package:app_project/screens/assets/assets_add_screen.dart';
import 'package:app_project/utils/format.dart';
import 'package:app_project/widgets/shared/base_list_screen.dart';

// Holds selected asset IDs
final selectedAssetIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class AssetsListScreen extends ConsumerWidget {
  const AssetsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetState = ref.watch(assetProvider);
    final notifier = ref.read(assetProvider.notifier);
    final selectedIds = ref.watch(selectedAssetIdsProvider);

    return BaseListScreen(
      title: 'Assets',
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAssetScreen()),
          );
        },
      ),
      body: assetState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (assets) => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: LocalizationManager.local.selectAll,
                      icon: const Icon(Icons.select_all, color: Colors.black45),
                      onPressed: () {
                        final selected = ref.read(
                          selectedAssetIdsProvider.notifier,
                        );
                        final current = ref.read(selectedAssetIdsProvider);
                        final data = assetState.asData?.value ?? [];
                        if (data.isEmpty) return;
                        final pageIds = data.map((a) => a.id).toSet();
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
                        // Edit single
                        IconButton(
                          tooltip: LocalizationManager.local.edit,
                          icon: const Icon(Icons.edit, color: Colors.black45),
                          onPressed: () async {
                            final selectedIds = ref.read(
                              selectedAssetIdsProvider,
                            );
                            if (selectedIds.length != 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Select exactly one asset to edit',
                                  ),
                                ),
                              );
                              return;
                            }
                            final assets =
                                ref.read(assetProvider).asData?.value ?? [];
                            final id = selectedIds.first;
                            final asset = assets.firstWhere(
                              (a) => a.id == id,
                              orElse: () => assets.first,
                            );
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddAssetScreen(initialItem: asset),
                              ),
                            );
                          },
                        ),
                        // Delete bulk
                        IconButton(
                          tooltip: LocalizationManager.local.delete,
                          icon: const Icon(Icons.delete, color: Colors.black45),
                          onPressed: () async {
                            final selectedIds = ref.read(
                              selectedAssetIdsProvider,
                            );
                            if (selectedIds.isEmpty) return;
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete assets'),
                                content: Text(
                                  'Delete ${selectedIds.length} selected asset(s)?',
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
                              await notifier.deleteAssets(selectedIds.toList());
                              ref
                                      .read(selectedAssetIdsProvider.notifier)
                                      .state =
                                  {};
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Deleted selected assets'),
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
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  final isChecked =
                      asset.id != null && selectedIds.contains(asset.id);

                  return BaseListTile(
                    selected: isChecked,
                    onTap: asset.id == null
                        ? null
                        : () {
                            final selected = ref.read(
                              selectedAssetIdsProvider.notifier,
                            );
                            final current = ref.read(selectedAssetIdsProvider);
                            if (isChecked) {
                              selected.state = current.difference({asset.id});
                            } else {
                              selected.state = {...current, asset.id};
                            }
                          },
                    title: asset.name,
                    subtitle: Text(
                      asset.condition,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.lightBlue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.linear(0.8),
                    ),
                    leading:
                        asset.imageUrl != null && asset.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              asset.imageUrl!,
                              width: 40,
                              height: 40,
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
                              size: 22,
                            ),
                          ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${LocalizationManager.local.quantity}: ${asset.quantity}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.linear(0.8),
                        ),
                        Text(
                          appFormatDate(context, asset.createdAt),
                          style: const TextStyle(fontSize: 12),
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
                        child: Text(LocalizationManager.local.loadMore),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
