import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment.dart';

class PaymentNotifier extends AsyncNotifier<List<Payment>> {
  final _client = Supabase.instance.client;
  final String _table = 'payment';

  static const int _pageSize = 1;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Payment>> build() async {
    _offset = 0;
    _hasMore = true;
    return await _fetchPayments(reset: true);
  }

  Future<List<Payment>> _fetchPayments({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final res = await _client
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

  Future<List<Payment>> getMonthlyPayments({int? year, int? month}) async {
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

    final response = await _client
        .from(_table)
        .select()
        .gte('datetime', start.toIso8601String())
        .lte('datetime', end.toIso8601String())
        .order('datetime', ascending: true);

    return (response as List)
        .map((item) => Payment.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addPayment(Payment payment) async {
    await _client.from(_table).insert(payment.toMap()).select().single();
    state = AsyncValue.data(await _fetchPayments(reset: true));
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final paymentServiceProvider =
    AsyncNotifierProvider<PaymentNotifier, List<Payment>>(
      () => PaymentNotifier(),
    );
