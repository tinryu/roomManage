import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/tenant.dart';

class TenantNotifier extends AsyncNotifier<List<Tenant>> {
  final supabase = Supabase.instance.client;
  final String _table = 'tenants';

  static const int _pageSize = 10;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Tenant>> build() async {
    _offset = 0;
    _hasMore = true;
    return _fetchTenants(reset: true);
  }

  Future<List<Tenant>> _fetchTenants({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final res = await supabase
          .from(_table)
          .select()
          .order('checkin', ascending: false)
          .range(_offset, _offset + _pageSize - 1);

      final data = res as List;
      final fetched = data.map((e) => Tenant.fromMap(e)).toList();

      if (reset) {
        _offset = fetched.length;
        state = AsyncData(fetched);
      } else {
        _offset += fetched.length;
        final current = state.value ?? [];
        state = AsyncData([...current, ...fetched]);
      }

      if (fetched.length < _pageSize) {
        _hasMore = false;
      }

      return fetched;
    } catch (e, st) {
      if (reset) {
        state = AsyncError(e, st);
      }
      return [];
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> fetchNextPage() async {
    if (_hasMore) {
      await _fetchTenants();
    }
  }

  Future<void> addTenant(Tenant tenant) async {
    await supabase.from(_table).insert(tenant.toMap());
    state = AsyncData(await _fetchTenants());
  }

  Future<void> deleteTenant(String id) async {
    await supabase.from(_table).delete().eq('id', id);
    state = AsyncData(await _fetchTenants());
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final tenantProvider = AsyncNotifierProvider<TenantNotifier, List<Tenant>>(
  () => TenantNotifier(),
);
