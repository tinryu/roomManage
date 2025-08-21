import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_project/screens/home/recent_activity_screen.dart';
import 'package:app_project/screens/home/income_summary_screen.dart';
import 'package:app_project/screens/home/upcoming_tasks.dart';
import 'package:app_project/screens/home/analytics_dashboard.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:app_project/utils/format.dart';
import 'package:app_project/utils/faded_loader.dart';
import 'package:provider/provider.dart' as p;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dp = p.Provider.of<DashboardProvider>(context, listen: false);
      dp.fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Localization available via AppLocalizations if needed
    final local = AppLocalizations.of(context)!;

    final dashboardProvider = p.Provider.of<DashboardProvider>(context);

    return Scaffold(
      body: dashboardProvider.isLoading
          ? const Center(child: FadedLoader())
          : dashboardProvider.dashboard == null
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  dashboardProvider.fetchDashboard();
                },
                child: Icon(Icons.refresh),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/room1.png',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Analytics Dashboard
                        AnalyticsDashboard(
                          stats: [
                            {
                              'icon': Icons.meeting_room,
                              'value': dashboardProvider
                                  .dashboard!
                                  .availableRooms
                                  .toString(),
                              'label': 'Rooms Available',
                            },
                            {
                              'icon': Icons.attach_money,
                              'value': appFormatCurrencyCompact(
                                context,
                                dashboardProvider.dashboard!.todayRevenue,
                              ),
                              'label': 'Today Revenue',
                            },
                            {
                              'icon': Icons.login,
                              'value': dashboardProvider
                                  .dashboard!
                                  .todayCheckins
                                  .toString(),
                              'label': 'Check-ins Today',
                            },
                            {
                              'icon': Icons.bar_chart,
                              'value':
                                  '${dashboardProvider.dashboard!.occupancyRate.toString()}%',
                              'label': 'Occupancy Rate',
                            },
                            {
                              'icon': Icons.person,
                              'value': dashboardProvider.dashboard!.activeUsers
                                  .toString(),
                              'label': local.activeUsers,
                            },
                            {
                              'icon': Icons.luggage,
                              'value': dashboardProvider
                                  .dashboard!
                                  .damagedAssets
                                  .toString(),
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
                ],
              ),
            ),
    );
  }

  Widget _swiper() {
    return SizedBox(
      height: 200,
      child: Swiper(
        itemCount: 3,
        autoplay: true,
        transformer: ScaleAndFadeTransformer(scale: 0.8, fade: 0.5),
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeSize: 0,
            size: 0,
            activeColor: Colors.white,
            color: Colors.white38,
          ),
        ),
        control: SwiperControl(
          color: Colors.white,
          disableColor: Colors.white38,
          size: 0,
        ),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueAccent,
          ),
          child: Image.asset(
            'assets/images/room1.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
