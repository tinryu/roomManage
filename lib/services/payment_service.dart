import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment.dart';

class PaymentService {
  final supabase = Supabase.instance.client;
  final String _table = 'payments';

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

    final response = await supabase
        .from(_table)
        .select()
        .gte('datetime', start.toIso8601String())
        .lte('datetime', end.toIso8601String())
        .order('datetime', ascending: true);

    return List<Payment>.from(response);
  }

  // Get all payments
  Future<List<Payment>> getAllPayments() async {
    final response = await supabase.from(_table).select();
    return List<Payment>.from(response);
  }

  // Get unpaid payments
  Future<List<Payment>> getUnpaidPayments() async {
    final response = await supabase
        .from(_table)
        .select()
        .eq('isPaid', false)
        .order('datetime');
    return List<Payment>.from(response);
  }

  // Add a new payment
  Future<void> addPayment(Payment payment) async {
    await supabase.from(_table).insert(payment);
  }

  // Mark payment as paid
  Future<void> markAsPaid(String paymentId) async {
    await supabase.from(_table).update({'isPaid': true}).eq('id', paymentId);
  }

  // Get payments by room
  Future<List<Payment>> getPaymentsByRoom(String roomId) async {
    final response = await supabase.from(_table).select().eq('roomid', roomId);
    return List<Payment>.from(response);
  }

  // Delete a payment
  Future<void> deletePayment(String paymentId) async {
    await supabase.from(_table).delete().eq('id', paymentId);
  }
}
