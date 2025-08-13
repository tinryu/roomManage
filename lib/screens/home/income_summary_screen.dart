import 'package:app_project/providers/payment_provider.dart';
import 'package:app_project/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class IncomeSummaryScreen extends ConsumerStatefulWidget {
  const IncomeSummaryScreen({super.key});

  @override
  ConsumerState<IncomeSummaryScreen> createState() =>
      _IncomeSummaryScreenState();
}

class _IncomeSummaryScreenState extends ConsumerState<IncomeSummaryScreen> {
  List<Payment> monthlyPayments = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMonthlyPayments();
  }

  Future<void> _loadMonthlyPayments() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final paymentNotifier = ref.read(paymentServiceProvider.notifier);
      final payments = await paymentNotifier.getMonthlyPayments(
        year: 2025,
        month: 8,
      );
      setState(() {
        monthlyPayments = payments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Income Summary",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 12),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                  ? Center(child: Text('Lỗi: $error'))
                  : monthlyPayments.isEmpty
                  ? const Center(
                      child: Text('Không có dữ liệu thanh toán tháng này'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadMonthlyPayments,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 16,
                          children: monthlyPayments.map((pay) {
                            return Container(
                              width: 160,
                              height: 80,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    spacing: 8,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.payment,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Column(
                                        spacing: 6,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pay.type ?? 'N/A',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textScaler: TextScaler.linear(0.8),
                                          ),
                                          Text(
                                            '${NumberFormat('#,###', 'vi_VN').format(pay.amount)} VND',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textScaler: TextScaler.linear(0.8),
                                          ),
                                          Text(
                                            DateFormat(
                                              'dd/MM/yyyy - HH:mm',
                                            ).format(pay.datetime),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
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
                          }).toList(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
