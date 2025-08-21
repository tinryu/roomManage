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
    try {
      final data = {
        'name': tenant.name,
        'phone': tenant.phone,
        'email': tenant.email,
        'checkin': tenant.checkIn.toIso8601String(),
        'checkout': tenant.checkOut?.toIso8601String(),
      };
      final res = await supabase.from(_table).insert(data).select().single();
      final newTenant = Tenant.fromMap(res);
      final current = state.value ?? [];
      state = AsyncData([newTenant, ...current]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateTenant(Tenant tenant) async {
    if (tenant.id == null) return;
    try {
      final data = {
        'name': tenant.name,
        'phone': tenant.phone,
        'email': tenant.email,
        'checkin': tenant.checkIn.toIso8601String(),
        'checkout': tenant.checkOut?.toIso8601String(),
      };
      final res = await supabase
          .from(_table)
          .update(data)
          .eq('id', tenant.id!)
          .select()
          .maybeSingle();
      if (res == null) {
        throw StateError('No tenant found with id ${tenant.id} to update');
      }
      final updated = Tenant.fromMap(res);
      final current = state.value ?? [];
      state = AsyncData(current.map((t) => t.id == updated.id ? updated : t).toList());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteTenant(int id) async {
    await supabase.from(_table).delete().eq('id', id);
    final current = state.value ?? [];
    state = AsyncData(current.where((t) => t.id != id).toList());
  }

  Future<void> deleteTenants(List<int> ids) async {
    if (ids.isEmpty) return;
    await supabase.from(_table).delete().inFilter('id', ids);
    final idSet = ids.toSet();
    final current = state.value ?? [];
    state = AsyncData(current.where((t) => !(t.id != null && idSet.contains(t.id))).toList());
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final tenantProvider = AsyncNotifierProvider<TenantNotifier, List<Tenant>>(
  () => TenantNotifier(),
);
