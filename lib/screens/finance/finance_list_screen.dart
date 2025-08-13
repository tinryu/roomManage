import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/payment_provider.dart';

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentServiceProvider);
    final notifier = ref.read(paymentServiceProvider.notifier);

    return Scaffold(
      body: paymentState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (payments) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${payment.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          Text('Amount: ${payment.amount}'),
                          Text(
                            'Date transfer: ${payment.datetime.toString().substring(0, 10)}',
                          ),
                          Text('Type transfer: ${payment.type}'),
                        ],
                      ),
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
