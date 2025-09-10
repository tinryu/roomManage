import 'package:app_project/screens/payment/payment_add_screen.dart';
import 'package:app_project/utils/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/payment_provider.dart';
import 'package:intl/intl.dart';
import 'package:app_project/utils/format.dart';

// Holds the set of selected payment IDs for checkbox selection
final selectedPaymentIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentProvider);
    final notifier = ref.read(paymentProvider.notifier);
    final selectedIds = ref.watch(selectedPaymentIdsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: IconButton(
            tooltip: LocalizationManager.local.selectAll,
            icon: const Icon(Icons.select_all, color: Colors.black45),
            onPressed: () {
              final payments = paymentState.asData?.value ?? [];
              final pageIds = payments
                  .map((p) => p.id)
                  .whereType<int>()
                  .toSet();
              if (pageIds.isEmpty) return;
              final selNotifier = ref.read(selectedPaymentIdsProvider.notifier);
              final current = {...selectedIds};
              final allSelected = pageIds.every(current.contains);
              if (allSelected) {
                current.removeAll(pageIds);
              } else {
                current.addAll(pageIds);
              }
              selNotifier.state = current;
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  tooltip: LocalizationManager.local.markAsPaid,
                  icon: const Icon(Icons.done_all, color: Colors.black45),
                  onPressed: selectedIds.isEmpty
                      ? null
                      : () async {
                          try {
                            await notifier.markPaymentsAsPaid(
                              selectedIds.toList(),
                            );
                            // Optionally clear selection after marking
                            ref
                                    .read(selectedPaymentIdsProvider.notifier)
                                    .state =
                                {};
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    LocalizationManager.local.markAsPaid,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed: $e')),
                              );
                            }
                          }
                        },
                ),
                IconButton(
                  tooltip: LocalizationManager.local.edit,
                  icon: const Icon(Icons.edit, color: Colors.black45),
                  onPressed: () async {
                    if (selectedIds.length != 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            LocalizationManager.local.selectExactlyOne,
                          ),
                        ),
                      );
                      return;
                    }
                    final payments =
                        ref.read(paymentProvider).asData?.value ?? [];
                    final id = selectedIds.first;
                    final payment = payments.firstWhere(
                      (p) => p.id == id,
                      orElse: () => payments.first,
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddPaymentScreen(initialPayment: payment),
                      ),
                    );
                  },
                ),
                IconButton(
                  tooltip: LocalizationManager.local.delete,
                  icon: const Icon(Icons.delete, color: Colors.black45),
                  onPressed: selectedIds.isEmpty
                      ? null
                      : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                LocalizationManager.local.deletePayment,
                              ),
                              content: Text(
                                'Delete ${selectedIds.length} selected payment(s)?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(LocalizationManager.local.cancel),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text(LocalizationManager.local.delete),
                                ),
                              ],
                            ),
                          );
                          if (confirm != true) return;
                          try {
                            await notifier.deletePayments(selectedIds.toList());
                            ref
                                    .read(selectedPaymentIdsProvider.notifier)
                                    .state =
                                {};
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    LocalizationManager
                                        .local
                                        .paymentDeleteSuccess,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${LocalizationManager.local.deleteFailed}: $e',
                                  ),
                                ),
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
      body: paymentState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('${LocalizationManager.local.error}: $e')),
        data: (payments) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final pay = payments[index];
                  final selectedIds = ref.watch(selectedPaymentIdsProvider);
                  final isChecked =
                      pay.id != null && selectedIds.contains(pay.id!);
                  return ListTile(
                    onTap: pay.id == null
                        ? null
                        : () {
                            final notifierSel = ref.read(
                              selectedPaymentIdsProvider.notifier,
                            );
                            final next = {...selectedIds};
                            if (isChecked) {
                              next.remove(pay.id!);
                            } else {
                              next.add(pay.id!);
                            }
                            notifierSel.state = next;
                          },
                    leading: Checkbox(
                      value: isChecked,
                      onChanged: pay.id == null
                          ? null
                          : (v) {
                              final notifierSel = ref.read(
                                selectedPaymentIdsProvider.notifier,
                              );
                              final next = {...selectedIds};
                              if (v == true) {
                                next.add(pay.id!);
                              } else {
                                next.remove(pay.id!);
                              }
                              notifierSel.state = next;
                            },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${pay.type}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textScaler: TextScaler.linear(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: pay.isPaid
                                    ? Colors.lightBlue
                                    : Colors.black45,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                pay.isPaid
                                    ? LocalizationManager.local.done
                                    : LocalizationManager.local.nope,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textScaler: TextScaler.linear(0.8),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${LocalizationManager.local.amount}: ${appFormatCurrencyCompact(context, pay.amount)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaler: TextScaler.linear(0.8),
                        ),
                        Text(
                          '${LocalizationManager.local.dateTransfer}: ${appFormatDate(context, pay.datetime)} - ${DateFormat('HH:mm').format(pay.datetime)}',
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
                        child: Text(LocalizationManager.local.loadMore),
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
            MaterialPageRoute(builder: (context) => const AddPaymentScreen()),
          );
        },
      ),
    );
  }
}
