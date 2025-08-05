import 'package:app_project/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class IncomeSummaryScreen extends ConsumerWidget {
  const IncomeSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentServiceProvider);

    return paymentState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Lỗi: $error')),
      data: (payment) {
        if (payment.isEmpty) {
          return const Center(child: Text('Không có dữ liệu thanh toán'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(paymentServiceProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: payment.length,
            itemBuilder: (context, index) {
              final pay = payment[index];
              return ListTile(
                leading: const Icon(Icons.payment),
                title: Text(pay.type),
                subtitle: Text(
                  '${pay.amount} VND • ${DateFormat('dd/MM/yyyy HH:mm').format(pay.datetime)}',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
