import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/screens/home/recent_activity_screen.dart';
import 'package:app_project/screens/home/income_summary_screen.dart';
import 'package:app_project/screens/home/upcoming_tasks.dart';
import 'package:app_project/screens/home/analytics_dashboard.dart';

class HomeScreen extends StatefulWidget {
  final void Function(Locale locale) onLocaleChange;

  const HomeScreen({
    super.key,
    required this.onLocaleChange,
  }); // you can replace with dynamic user

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Locale? _currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newLocale = Localizations.localeOf(context);
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      // Optionally trigger state update or analytics here
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analytics Dashboard
            AnalyticsDashboard(
              stats: [
                {
                  'icon': Icons.meeting_room,
                  'value': '5',
                  'label': 'Rooms Available',
                },
                {
                  'icon': Icons.attach_money,
                  'value': '2.5M VND',
                  'label': 'Today Revenue',
                },
                {'icon': Icons.login, 'value': '3', 'label': 'Check-ins Today'},
                {
                  'icon': Icons.bar_chart,
                  'value': '85%',
                  'label': 'Occupancy Rate',
                },
                {
                  'icon': Icons.person,
                  'value': '10',
                  'label': local.activeUsers,
                },
                {
                  'icon': Icons.luggage,
                  'value': '5',
                  'label': 'Waiting damaged',
                },
              ],
            ),
            SizedBox(height: 16),
            // Income Summary
            IncomeSummaryScreen(),
            SizedBox(height: 16),
            // Recent Activity
            RecentActivityScreen(),
            SizedBox(height: 16),
            // Upcoming Tasks
            UpcomingTasks(
              tasks: [
                {
                  'title': 'Room 203 - Checkout',
                  'date': '14/08/2025 - 10:00 AM',
                },
                {
                  'title': 'Room 105 - Maintenance',
                  'date': '14/08/2025 - 03:00 PM',
                },
                {
                  'title': 'Weekly Income Report',
                  'date': '15/08/2025 - 09:00 AM',
                },
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Widget _buildStatCard(
  //   String title,
  //   String value,
  //   String change,
  //   IconData icon,
  //   Color color,
  // ) {
  //   return Expanded(
  //     child: Container(
  //       padding: EdgeInsets.all(12),
  //       margin: EdgeInsets.only(bottom: 12),
  //       decoration: BoxDecoration(
  //         // ignore: deprecated_member_use
  //         color: Colors.white,
  //         border: Border.all(color: Colors.grey.shade300),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         spacing: 4,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //             textScaler: TextScaler.linear(0.8),
  //           ),
  //           Row(
  //             spacing: 4,
  //             children: [
  //               Icon(icon, size: 18),
  //               Text(
  //                 value,
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: color,
  //                 ),
  //                 textScaler: TextScaler.linear(0.8),
  //               ),
  //             ],
  //           ),
  //           Text(
  //             "$change from last week",
  //             style: TextStyle(fontSize: 12),
  //             textScaler: TextScaler.linear(0.8),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
