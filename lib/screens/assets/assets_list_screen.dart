import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/asset_provider.dart';
import 'package:app_project/screens/assets/assets_add_screen.dart';
import 'package:intl/intl.dart';

class AssetsListScreen extends ConsumerWidget {
  const AssetsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetState = ref.watch(assetProvider);
    final notifier = ref.read(assetProvider.notifier);

    return Scaffold(
      body: assetState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (assets) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return ListTile(
                    leading:
                        asset.imageUrl != null && asset.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              asset.imageUrl!,
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
                      asset.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textScaler: TextScaler.linear(0.8),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Condition: ${asset.condition}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.linear(0.8),
                        ),
                        Text(
                          "Quantity: ${asset.quantity}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.linear(0.8),
                        ),
                        Text(
                          "Room ID: ${asset.roomid}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.linear(0.8),
                        ),
                      ],
                    ),
                    trailing: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(asset.createdAt),
                      style: const TextStyle(fontSize: 12),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAssetScreen()),
          );
        },
      ),
    );
  }
}
