import 'package:app_project/providers/dashboard_provider.dart';
import 'package:app_project/widgets/shared/base_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_project/screens/home/income_summary_screen.dart';
import 'package:app_project/screens/home/upcoming_tasks.dart';
import 'package:app_project/screens/home/analytics_dashboard.dart';
import 'package:app_project/screens/assets/assets_list_screen.dart';
import 'package:app_project/screens/tenants/tenants_list_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:app_project/utils/format.dart';
import 'package:app_project/utils/faded_loader.dart';
import 'package:app_project/utils/localization_manager.dart';
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

    LocalizationManager.initialize(context);

    final newLocale = Localizations.localeOf(context);
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
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
                child: Icon(Icons.refresh, color: Colors.black),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.lightBlue, Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: SearchInput()),
                              PopupMenuButton(
                                padding: EdgeInsets.zero,
                                menuPadding: EdgeInsets.all(0),
                                position: PopupMenuPosition.under,
                                icon: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: '1',
                                    child: Text(
                                      'Notification 1',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: '2',
                                    child: Text(
                                      'Notification 2',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                padding: EdgeInsets.zero,
                                menuPadding: EdgeInsets.all(0),
                                position: PopupMenuPosition.under,
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text(
                                      'assets',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AssetsListScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      'tenants',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TenantListScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AnalyticsDashboard(
                          stats: [
                            {
                              'icon': Icons.meeting_room,
                              'value': dashboardProvider
                                  .dashboard!
                                  .availableRooms
                                  .toString(),
                              'label': LocalizationManager.local.availableRooms,
                            },
                            {
                              'icon': Icons.attach_money,
                              'value': appFormatCurrencyCompact(
                                context,
                                dashboardProvider.dashboard!.todayRevenue,
                              ),
                              'label': LocalizationManager.local.todayRevenue,
                            },
                            {
                              'icon': Icons.login,
                              'value': dashboardProvider
                                  .dashboard!
                                  .todayCheckins
                                  .toString(),
                              'label': LocalizationManager.local.checkInToday,
                            },
                            {
                              'icon': Icons.bar_chart,
                              'value':
                                  '${dashboardProvider.dashboard!.occupancyRate.toString()}%',
                              'label': LocalizationManager.local.occupancyRate,
                            },
                            {
                              'icon': Icons.person,
                              'value': dashboardProvider.dashboard!.activeUsers
                                  .toString(),
                              'label': LocalizationManager.local.activeUsers,
                            },
                            {
                              'icon': Icons.luggage,
                              'value': dashboardProvider
                                  .dashboard!
                                  .damagedAssets
                                  .toString(),
                              'label': LocalizationManager.local.waitingDamaged,
                            },
                          ],
                        ),
                        SizedBox(height: 16),
                        // Income Summary
                        IncomeSummaryScreen(),
                        SizedBox(height: 16),
                        // Recent Activity
                        // RecentActivityScreen(),
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
