import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/payment.dart';

class PaymentNotifier extends AsyncNotifier<List<Payment>> {
  final supabase = Supabase.instance.client;
  final String _table = 'payments';

  static const int _pageSize = 10;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Payment>> build() async {
    _offset = 0;
    _hasMore = true;
    return await _fetchPayments(reset: true);
  }

  Future<void> deletePayments(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      await supabase.from(_table).delete().inFilter('id', ids);
      final current = state.value ?? [];
      final idSet = ids.toSet();
      final updated = current
          .where((p) => !(p.id != null && idSet.contains(p.id)))
          .toList();
      state = AsyncData(updated);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePayment(Payment payment) async {
    if (payment.id == null) return;
    try {
      final data = {
        'tenantid': payment.tenantId,
        'roomid': payment.roomId,
        'amount': payment.amount,
        'isPaid': payment.isPaid,
        'type': payment.type,
        'datetime': payment.datetime.toIso8601String(),
      };
      final res = await supabase
          .from(_table)
          .update(data)
          .eq('id', payment.id as int)
          .select()
          .single();

      final updatedPayment = Payment.fromMap(res);
      final current = state.value ?? [];
      final updated = current.map((p) {
        if (p.id == updatedPayment.id) return updatedPayment;
        return p;
      }).toList();
      state = AsyncData(updated);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markPaymentsAsPaid(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      await supabase.from(_table).update({'isPaid': true}).inFilter('id', ids);

      // Update local state
      final current = state.value ?? [];
      final idSet = ids.toSet();
      final updated = current.map((p) {
        if (p.id != null && idSet.contains(p.id)) {
          return Payment(
            id: p.id,
            tenantId: p.tenantId,
            roomId: p.roomId,
            amount: p.amount,
            isPaid: true,
            type: p.type,
            datetime: p.datetime,
          );
        }
        return p;
      }).toList();
      state = AsyncData(updated);
    } catch (e) {
      // keep current state, just rethrow so UI can handle
      rethrow;
    }
  }

  Future<List<Payment>> _fetchPayments({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final res = await supabase
          .from(_table)
          .select()
          .order('datetime', ascending: false)
          .range(_offset, _offset + _pageSize - 1);
      final data = res as List;
      final fetched = data.map((e) => Payment.fromMap(e)).toList();

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
      await _fetchPayments();
    }
  }

  Future<List<Payment>> getMonthlyPayments({
    int? year,
    int? month,
    int? limit,
  }) async {
    final now = DateTime.now();
    final selectedYear = year ?? now.year;
    final selectedMonth = month ?? now.month;

    // Start and end of the month
    final start = DateTime(selectedYear, selectedMonth, 1);
    final end = DateTime(
      selectedYear,
      selectedMonth + 1,
      1,
    ).subtract(Duration(seconds: 1));

    final response = await supabase
        .from(_table)
        .select()
        .gte('datetime', start.toIso8601String())
        .lte('datetime', end.toIso8601String())
        .order('datetime', ascending: false)
        .limit(limit ?? 5);

    return (response as List)
        .map((item) => Payment.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addPayment(Payment payment) async {
    try {
      final data = {
        'tenantid': payment.tenantId,
        'roomid': payment.roomId,
        'amount': payment.amount,
        'isPaid': payment.isPaid,
        'type': payment.type,
        'datetime': payment.datetime.toIso8601String(),
      };
      final res = await supabase.from(_table).insert(data).select().single();

      final newPayment = Payment.fromMap(res);
      final current = state.value ?? [];
      state = AsyncData([newPayment, ...current]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final paymentProvider = AsyncNotifierProvider<PaymentNotifier, List<Payment>>(
  () => PaymentNotifier(),
);
