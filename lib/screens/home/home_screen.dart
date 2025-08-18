import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/screens/home/recent_activity_screen.dart';
import 'package:app_project/screens/home/income_summary_screen.dart';
import 'package:app_project/screens/home/upcoming_tasks.dart';
import 'package:app_project/screens/home/analytics_dashboard.dart';
import 'package:card_swiper/card_swiper.dart';

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
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _swiper(),
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
            UpcomingTasks(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _swiper() {
    return SizedBox(
      height: 100,
      child: Swiper(
        itemCount: 3,
        transformer: ScaleAndFadeTransformer(scale: 0.8, fade: 0.5),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueAccent,
          ),
          child: Center(
            child: Text(
              'Slide $index',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeSize: 8,
            size: 4,
            activeColor: Colors.white,
            color: Colors.white38,
          ),
        ),
        control: SwiperControl(
          color: Colors.white,
          disableColor: Colors.white38,
        ),
      ),
    );
  }
}
