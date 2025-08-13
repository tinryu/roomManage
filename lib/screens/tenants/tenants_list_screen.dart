import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/tenant_provider.dart';
import 'package:intl/intl.dart';

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
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                    title: Text(
                      t.name,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_downward_sharp,
                              size: 12,
                              color: Colors.green,
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(t.checkIn),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textScaler: TextScaler.linear(0.8),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_upward_sharp,
                              size: 12,
                              color: Colors.red,
                            ),
                            Text(
                              DateFormat(
                                'dd/MM/yyyy HH:mm',
                              ).format(t.checkOut!),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textScaler: TextScaler.linear(0.8),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4DB6E2),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
