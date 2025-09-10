import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import 'package:app_project/providers/dashboard_provider.dart';
import 'package:intl/intl.dart';
import 'package:app_project/utils/format.dart';
import 'package:app_project/utils/localization_manager.dart';

class IncomeSummaryScreen extends StatefulWidget {
  const IncomeSummaryScreen({super.key});

  @override
  State<IncomeSummaryScreen> createState() => _IncomeSummaryScreenState();
}

class _IncomeSummaryScreenState extends State<IncomeSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final dp = p.Provider.of<DashboardProvider>(context);
    final isLoading = dp.isLoading;
    final monthlyPayments = dp.recentPayments;
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
                    LocalizationManager.local.recentIncome,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 12),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : monthlyPayments.isEmpty
                  ? Center(
                      child: Text(LocalizationManager.local.noOverduePayments),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await dp.fetchDashboard(homeLimit: 5);
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 16,
                          children: monthlyPayments.map((pay) {
                            return Container(
                              width: 200,
                              height: 80,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[100]!),
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
                                            appFormatCurrencyCompact(
                                              context,
                                              pay.amount,
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textScaler: TextScaler.linear(0.8),
                                          ),
                                          Text(
                                            '${appFormatDate(context, pay.datetime)} - ${DateFormat('HH:mm').format(pay.datetime)}',
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
