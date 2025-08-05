import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/activity_provider.dart';
import 'package:intl/intl.dart';

class RecentList extends ConsumerWidget {
  const RecentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeState = ref.watch(activityProvider);
    final notifier = ref.read(activityProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Recent actives')),
      body: activeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Loi: $e')),
        data: (actives) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: actives.length,
                itemBuilder: (context, index) {
                  final act = actives[index];
                  return ListTile(
                    title: Text(act.action),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(act.timestamp),
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
    );
  }
}
