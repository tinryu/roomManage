import 'package:app_project/screens/tenants/tenant_add_screen.dart';
import 'package:app_project/utils/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/tenant_provider.dart';
import 'package:app_project/models/tenant.dart';
import 'package:app_project/widgets/shared/base_list_screen.dart';
import 'package:app_project/utils/format.dart';

// Holds selected tenant IDs
final selectedTenantIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class TenantListScreen extends ConsumerStatefulWidget {
  const TenantListScreen({super.key});

  @override
  ConsumerState<TenantListScreen> createState() => _TenantListScreenState();
}

class _TenantListScreenState extends ConsumerState<TenantListScreen> {
  final _scrollController = ScrollController();
  bool _isGridView = false; // Track view mode

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

                        Row(
                          children: [
                            // Toggle view button
                            IconButton(
                              icon: Icon(
                                _isGridView ? Icons.view_list : Icons.grid_view,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isGridView = !_isGridView;
                                });
                              },
                              tooltip: _isGridView
                                  ? 'Switch to List View'
                                  : 'Switch to Grid View',
                            ),
                            const SizedBox(width: 8),
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
                                      selectedTenantIdsProvider.notifier,
                                    );
                                    final current = ref.read(
                                      selectedTenantIdsProvider,
                                    );
                                    final data =
                                        tenantState.asData?.value ?? [];
                                    if (data.isEmpty) return;
                                    final pageIds = data
                                        .map((a) => a.id!)
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
                                                selectedTenantIdsProvider
                                                    .notifier,
                                              )
                                              .state =
                                          {};
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Deleted selected tenants',
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Select exactly one tenant to edit',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final tenants =
                                        ref
                                            .read(tenantProvider)
                                            .asData
                                            ?.value ??
                                        [];
                                    final id = selectedIds.first;
                                    final tenant = tenants.firstWhere(
                                      (a) => a.id == id,
                                      orElse: () => tenants.first,
                                    );
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTenantScreen(
                                          initialItem: tenant,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _isGridView
                      ? _buildGridView(tenants, selectedIds, ref)
                      : _buildListView(tenants, selectedIds, ref),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(
    List<Tenant> tenants,
    Set<int> selectedIds,
    WidgetRef ref,
  ) {
    return ListView.builder(
      itemCount: tenants.length,
      itemBuilder: (context, index) {
        final t = tenants[index];
        final isSelected = t.id != null && selectedIds.contains(t.id!);

        return BaseListTile(
          title: t.name,
          leading: _buildTenantLeading(t),
          subtitle: _buildTenantSubtitle(t),
          selected: isSelected,
          onTap: t.id == null
              ? null
              : () {
                  final sel = ref.read(selectedTenantIdsProvider.notifier);
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
    );
  }

  Widget _buildGridView(
    List<Tenant> tenants,
    Set<int> selectedIds,
    WidgetRef ref,
  ) {
    final width = MediaQuery.of(context).size.width;
    final int columns = width > 1000
        ? 6
        : width > 700
        ? 4
        : 2;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: width > 700 ? 1.2 : 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tenants.length,
      itemBuilder: (context, index) {
        final t = tenants[index];
        final isSelected = t.id != null && selectedIds.contains(t.id!);

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.lightBlue : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: t.id == null
                ? null
                : () {
                    final sel = ref.read(selectedTenantIdsProvider.notifier);
                    final next = {...selectedIds};
                    if (isSelected) {
                      next.remove(t.id!);
                    } else {
                      next.add(t.id!);
                    }
                    sel.state = next;
                  },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tenant Avatar and Name
                  Row(
                    children: [
                      _buildTenantLeading(t, size: 40),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          t.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Tenant Details
                  Expanded(child: _buildTenantDetails(t)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTenantLeading(Tenant t, {double size = 50}) {
    return t.imageUrl?.isNotEmpty == true
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              t.imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildDefaultAvatar(size),
            ),
          )
        : _buildDefaultAvatar(size);
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.person, size: 30, color: Colors.white),
    );
  }

  Widget _buildTenantSubtitle(Tenant t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.phone_android_rounded, size: 12),
            const SizedBox(width: 4),
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
            const Icon(Icons.house_sharp, size: 12),
            const SizedBox(width: 4),
            Text(
              appFormatDate(context, t.checkIn),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textScaler: TextScaler.linear(0.8),
            ),
            if (t.checkOut != null) ...[
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward, size: 12),
              const SizedBox(width: 4),
              Text(
                appFormatDate(context, t.checkOut!),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textScaler: TextScaler.linear(0.8),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTenantDetails(Tenant t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Phone
        _buildDetailRow(Icons.phone_android_rounded, formatPhone(t.phone)),
        const SizedBox(height: 8),
        // Check-in Date
        _buildDetailRow(
          Icons.calendar_today,
          'Check-in: ${appFormatDate(context, t.checkIn)}',
        ),
        if (t.checkOut != null) ...[
          const SizedBox(height: 4),
          _buildDetailRow(
            Icons.arrow_forward,
            'Check-out: ${appFormatDate(context, t.checkOut!)}',
            iconSize: 16,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {double iconSize = 14}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: iconSize, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textScaler: TextScaler.linear(0.8),
          ),
        ),
      ],
    );
  }
}
