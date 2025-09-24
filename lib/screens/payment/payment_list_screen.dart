import 'package:app_project/screens/payment/payment_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/payment_provider.dart';
import 'package:intl/intl.dart';
import 'package:app_project/utils/format.dart';
import 'package:app_project/widgets/shared/base_list_screen.dart';
import 'package:app_project/utils/localization_manager.dart';

// Holds the set of selected payment IDs for checkbox selection
final selectedPaymentIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LocalizationManager.initialize(context);
  }

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
      final notifier = ref.read(paymentProvider.notifier);
      if (notifier.hasMore && !notifier.isLoadingMore) {
        notifier.fetchNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final paymentState = ref.watch(paymentProvider);
        final notifier = ref.read(paymentProvider.notifier);
        final selectedIds = ref.watch(selectedPaymentIdsProvider);

        return BaseListScreen(
          showAppBar: false,
          title: LocalizationManager.local.payments,
          floatingActionButton: FloatingActionButton.small(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPaymentScreen()),
              );
            },
          ),
          body: paymentState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (payments) {
              if (payments.isEmpty) {
                return Center(child: Text(LocalizationManager.local.noData));
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        } else {
                                          Navigator.of(
                                            context,
                                          ).popAndPushNamed('/');
                                        }
                                      },
                                    ),
                                    Text(
                                      LocalizationManager.local.payment,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                  menuPadding: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  position: PopupMenuPosition.under,
                                  tooltip: LocalizationManager.local.action,
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Text(
                                        LocalizationManager.local.selectAll,
                                      ),
                                      onTap: () {
                                        final selected = ref.read(
                                          selectedPaymentIdsProvider.notifier,
                                        );
                                        final current = ref.read(
                                          selectedPaymentIdsProvider,
                                        );
                                        final data =
                                            paymentState.asData?.value ?? [];
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
                                    PopupMenuItem(
                                      onTap: selectedIds.isEmpty
                                          ? null
                                          : () async {
                                              try {
                                                await notifier
                                                    .markPaymentsAsPaid(
                                                      selectedIds.toList(),
                                                    );
                                                // Optionally clear selection after marking
                                                ref
                                                        .read(
                                                          selectedPaymentIdsProvider
                                                              .notifier,
                                                        )
                                                        .state =
                                                    {};
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        LocalizationManager
                                                            .local
                                                            .markAsPaid,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed: $e',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                      child: Text(
                                        LocalizationManager.local.markAsPaid,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        LocalizationManager.local.delete,
                                      ),
                                      onTap: () async {
                                        final selectedIds = ref.read(
                                          selectedPaymentIdsProvider,
                                        );
                                        if (selectedIds.isEmpty) return;
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text(
                                              LocalizationManager
                                                  .local
                                                  .deleteRoom,
                                            ),
                                            content: Text(
                                              'Delete ${selectedIds.length} selected?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                child: Text(
                                                  LocalizationManager
                                                      .local
                                                      .cancel,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: Text(
                                                  LocalizationManager
                                                      .local
                                                      .delete,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm != true) return;
                                        try {
                                          await notifier.deletePayments(
                                            selectedIds.toList(),
                                          );
                                          ref
                                                  .read(
                                                    selectedPaymentIdsProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              {};
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Deleted selected rooms',
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
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
                                    PopupMenuItem(
                                      child: Text(
                                        LocalizationManager.local.edit,
                                      ),
                                      onTap: () async {
                                        final selectedIds = ref.read(
                                          selectedPaymentIdsProvider,
                                        );
                                        if (selectedIds.length != 1) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Select exactly one item to edit',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        final payments =
                                            ref
                                                .read(paymentProvider)
                                                .asData
                                                ?.value ??
                                            [];
                                        final id = selectedIds.first;
                                        final payment = payments.firstWhere(
                                          (p) => p.id == id,
                                          orElse: () => payments.first,
                                        );
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddPaymentScreen(
                                                  initialItem: payment,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: payments.length,
                            itemBuilder: (context, index) {
                              final pay = payments[index];
                              final isChecked =
                                  pay.id != null &&
                                  selectedIds.contains(pay.id!);

                              return BaseListTile(
                                showTitle: false,
                                title: pay.type!,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            pay.isPaid
                                                ? LocalizationManager.local.done
                                                : LocalizationManager
                                                      .local
                                                      .nope,
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
                                selected: isChecked,
                                onTap: pay.id == null
                                    ? null
                                    : () {
                                        final selected = ref.read(
                                          selectedPaymentIdsProvider.notifier,
                                        );
                                        final current = ref.read(
                                          selectedPaymentIdsProvider,
                                        );
                                        if (isChecked) {
                                          selected.state = current.difference({
                                            pay.id!,
                                          });
                                        } else {
                                          selected.state = {
                                            ...current,
                                            pay.id!,
                                          };
                                        }
                                      },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
