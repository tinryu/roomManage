import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/payment_provider.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

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
                  final pay = payments[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Icon(
                        Icons.currency_exchange,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Type transfer: ${pay.type}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textScaler: TextScaler.linear(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount: ${NumberFormat('#,###', 'vi_VN').format(pay.amount)} VND',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.linear(0.8),
                        ),
                        Text(
                          'Date transfer: ${DateFormat('dd/MM/yyyy HH:mm').format(pay.datetime)}',
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
        onPressed: () {},
      ),
    );
  }
}
