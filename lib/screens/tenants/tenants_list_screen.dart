import 'package:app_project/screens/tenants/tenant_add_screen.dart';
import 'package:app_project/utils/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/tenant_provider.dart';
import 'package:app_project/utils/format.dart';
import 'package:app_project/widgets/shared/base_list_screen.dart';

// Holds selected tenant IDs
final selectedTenantIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class TenantListScreen extends ConsumerStatefulWidget {
  const TenantListScreen({super.key});

  @override
  ConsumerState<TenantListScreen> createState() => _TenantListScreenState();
}

class _TenantListScreenState extends ConsumerState<TenantListScreen> {
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
      final notifier = ref.read(tenantProvider.notifier);
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final tenantState = ref.watch(tenantProvider);
        final notifier = ref.read(tenantProvider.notifier);
        final selectedIds = ref.watch(selectedTenantIdsProvider);

        return BaseListScreen(
          showAppBar: false,
          title: LocalizationManager.local.tenants,
          floatingActionButton: FloatingActionButton.small(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTenantScreen()),
              );
            },
          ),
          body: tenantState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text(err.toString())),
            data: (tenants) => Column(
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
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                                  Navigator.of(context).popAndPushNamed('/');
                                }
                              },
                            ),
                            Text(
                              LocalizationManager.local.tenants,
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
                              child: Text(LocalizationManager.local.selectAll),
                              onTap: () {
                                final selected = ref.read(
                                  selectedTenantIdsProvider.notifier,
                                );
                                final current = ref.read(
                                  selectedTenantIdsProvider,
                                );
                                final data = tenantState.asData?.value ?? [];
                                if (data.isEmpty) return;
                                final pageIds = data.map((a) => a.id!).toSet();
                                final allSelected =
                                    pageIds.isNotEmpty &&
                                    pageIds.difference(current).isEmpty;
                                selected.state = allSelected
                                    ? (current.difference(pageIds))
                                    : ({...current, ...pageIds});
                              },
                            ),
                            PopupMenuItem(
                              child: Text(LocalizationManager.local.delete),
                              onTap: () async {
                                final selectedIds = ref.read(
                                  selectedTenantIdsProvider,
                                );
                                if (selectedIds.isEmpty) return;
                                final confim = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Tenants'),
                                    content: Text(
                                      'Delete ${selectedIds.length} selected tenant(s)?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confim != true) return;
                                try {
                                  await notifier.deleteTenants(
                                    selectedIds.toList(),
                                  );
                                  ref
                                          .read(
                                            selectedTenantIdsProvider.notifier,
                                          )
                                          .state =
                                      {};
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Deleted selected tenants',
                                        ),
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
                            PopupMenuItem(
                              child: Text(LocalizationManager.local.edit),
                              onTap: () async {
                                final selectedIds = ref.read(
                                  selectedTenantIdsProvider,
                                );
                                if (selectedIds.length != 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Select exactly one tenant to edit',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final tenants =
                                    ref.read(tenantProvider).asData?.value ??
                                    [];
                                final id = selectedIds.first;
                                final tenant = tenants.firstWhere(
                                  (a) => a.id == id,
                                  orElse: () => tenants.first,
                                );
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddTenantScreen(initialItem: tenant),
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
                    itemCount: tenants.length,
                    itemBuilder: (context, index) {
                      final t = tenants[index];
                      final isSelected =
                          t.id != null && selectedIds.contains(t.id!);

                      return BaseListTile(
                        title: t.name,
                        leading: t.imageUrl?.isNotEmpty == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  t.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                ),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.broken_image,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                        selected: isSelected,
                        onTap: t.id == null
                            ? null
                            : () {
                                final sel = ref.read(
                                  selectedTenantIdsProvider.notifier,
                                );
                                final next = {...selectedIds};
                                if (isSelected) {
                                  next.remove(t.id!);
                                } else {
                                  next.add(t.id!);
                                }
                                sel.state = next;
                              },
                      );
                    },
                  ),
                ),
                // if (notifier.hasMore)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: notifier.isLoadingMore
                //         ? CircularProgressIndicator()
                //         : ElevatedButton(
                //             onPressed: notifier.fetchNextPage,
                //             child: Text(LocalizationManager.local.loadMore),
                //           ),
                //   ),
              ],
            ),
          ),
        );
      },
    );
  }
}
