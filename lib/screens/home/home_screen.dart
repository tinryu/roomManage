import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';

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
  final String userName = "Alex";
  Locale? _currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newLocale = Localizations.localeOf(context);
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      debugPrint('📢 Locale changed: ${_currentLocale?.languageCode}');

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
            // Greeting
            Text(
              local.welcome(userName),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),

            // Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("View All", style: TextStyle(color: Colors.blue)),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                "No recent activity",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 24),
            // Stats
            Row(
              children: [
                _buildStatCard(
                  local.activeUsers,
                  "0",
                  "+12.5%",
                  Icons.person,
                  Colors.green,
                ),
                SizedBox(width: 6),
                _buildStatCard(
                  local.totalRevenue,
                  "0",
                  "+8.2%",
                  Icons.attach_money,
                  Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 24),

            // Quick Actions
            Text(
              "Quick Actions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildQuickAction(
                  Icons.account_circle,
                  local.userManagement,
                  local.manageUserProfile,
                  color: Colors.red,
                ),
                _buildQuickAction(
                  Icons.shelves,
                  local.resources,
                  local.trackResources,
                  color: Colors.green,
                ),
                _buildQuickAction(
                  Icons.home,
                  local.rooms,
                  local.roomsManagement,
                  color: Colors.yellow,
                ),
                _buildQuickAction(
                  Icons.currency_exchange,
                  local.finance,
                  local.financeSumary,
                  color: Colors.blue,
                ),
              ],
            ),

            SizedBox(height: 24),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              alignment: Alignment.topCenter,
              icon: Icon(Icons.star, size: 32),
              title: Text("It's title dialog"),
              content: Text("You are clicked on the button"),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.05),
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                SizedBox(width: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              "$change from last week",
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String title,
    String subtitle, {
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color?.withOpacity(0.05) ?? Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          Icon(
            icon,
            color: color ?? Colors.blue,
            size: MediaQuery.of(context).size.width * 0.1,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
