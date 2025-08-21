import 'package:app_project/screens/tenants/tenant_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/tenant_provider.dart';
import 'package:app_project/utils/format.dart';

// Holds selected tenant IDs
final selectedTenantIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class TenantListScreen extends ConsumerWidget {
  const TenantListScreen({super.key});

  String formatPhone(String phone) {
    // Xoá ký tự không phải số
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    // Thêm dấu cách hoặc dấu gạch theo định dạng
    if (digits.length == 10) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantState = ref.watch(tenantProvider);
    final notifier = ref.read(tenantProvider.notifier);

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
              final selected = ref.read(selectedTenantIdsProvider.notifier);
              final current = ref.read(selectedTenantIdsProvider);
              final data = tenantState.asData?.value ?? [];
              if (data.isEmpty) return;
              final pageIds = data
                  .where((t) => t.id != null)
                  .map((t) => t.id!)
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
                // Edit (single selection)
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit, color: Colors.black45),
                  onPressed: () async {
                    final selectedIds = ref.read(selectedTenantIdsProvider);
                    if (selectedIds.length != 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select exactly one tenant to edit'),
                        ),
                      );
                      return;
                    }
                    final tenants =
                        ref.read(tenantProvider).asData?.value ?? [];
                    final id = selectedIds.first;
                    final tenant = tenants.firstWhere(
                      (t) => t.id == id,
                      orElse: () => tenants.first,
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddTenantScreen(initialTenant: tenant),
                      ),
                    );
                  },
                ),
                // Delete (bulk)
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete, color: Colors.black45),
                  onPressed: () async {
                    final selectedIds = ref.read(selectedTenantIdsProvider);
                    if (selectedIds.isEmpty) return;
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete tenants'),
                        content: Text(
                          'Delete ${selectedIds.length} selected tenant(s)?',
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
                      await notifier.deleteTenants(selectedIds.toList());
                      ref.read(selectedTenantIdsProvider.notifier).state = {};
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Deleted selected tenants'),
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
      body: tenantState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (tenants) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tenants.length,
                itemBuilder: (context, index) {
                  final t = tenants[index];
                  final selectedIds = ref.watch(selectedTenantIdsProvider);
                  final isChecked = t.id != null && selectedIds.contains(t.id!);
                  return ListTile(
                    onTap: t.id == null
                        ? null
                        : () {
                            final sel = ref.read(
                              selectedTenantIdsProvider.notifier,
                            );
                            final next = {...selectedIds};
                            if (isChecked) {
                              next.remove(t.id!);
                            } else {
                              next.add(t.id!);
                            }
                            sel.state = next;
                          },
                    leading: Checkbox(
                      value: isChecked,
                      onChanged: t.id == null
                          ? null
                          : (v) {
                              final sel = ref.read(
                                selectedTenantIdsProvider.notifier,
                              );
                              final next = {...selectedIds};
                              if (v == true) {
                                next.add(t.id!);
                              } else {
                                next.remove(t.id!);
                              }
                              sel.state = next;
                            },
                    ),
                    subtitle: Row(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textScaler: TextScaler.linear(0.8),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.phone_android_rounded, size: 12),
                                Text(
                                  formatPhone(t.phone),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textScaler: TextScaler.linear(0.8),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.house_sharp, size: 12),
                                Text(
                                  appFormatDate(context, t.checkIn),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textScaler: TextScaler.linear(0.8),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  t.checkOut != null
                                      ? Icons.arrow_circle_right_rounded
                                      : null,
                                  size: 12,
                                ),
                                Text(
                                  t.checkOut != null
                                      ? appFormatDate(context, t.checkOut!)
                                      : '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textScaler: TextScaler.linear(0.8),
                                ),
                              ],
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
            MaterialPageRoute(builder: (context) => const AddTenantScreen()),
          );
        },
      ),
    );
  }
}
