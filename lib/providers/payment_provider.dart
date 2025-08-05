import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment.dart';

class PaymentNotifier extends AsyncNotifier<List<Payment>> {
  final _client = Supabase.instance.client;
  final String _table = 'payments';

  @override
  Future<List<Payment>> build() async {
    return await getMonthlyPayments();
  }

  Future<List<Payment>> fetchPayments() async {
    final response = await _client
        .from(_table)
        .select()
        .order('timestamp', ascending: false);
    return (response as List)
        .map((item) => Payment.fromMap(item as Map<String, dynamic>))
        .toList();
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
    // Refresh state
    state = AsyncValue.data([...state.value ?? [], payment]);
  }
}

final paymentServiceProvider =
    AsyncNotifierProvider<PaymentNotifier, List<Payment>>(PaymentNotifier.new);
