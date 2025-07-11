import 'package:app_project/screens/finance/finance_list_screen.dart'
    show FinanceScreen;
import 'package:app_project/screens/resources/resources_list_screen.dart'
    show ResourcesScreen;
import 'package:app_project/screens/rooms/room_list_screen.dart'
    show RoomListScreen;
import 'package:app_project/screens/user/user_list_screen.dart'
    show UsersScreen;
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
  int _selectedIndex = 0;
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
      appBar: AppBar(
        leading: Icon(Icons.dashboard, color: Colors.blue),
        title: Text(local.home, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(padding: EdgeInsetsGeometry.only(right: 0), child: ElevatedButton(
            onPressed: () => widget.onLocaleChange(Locale('vi')),
            style: ElevatedButton.styleFrom(
              backgroundColor: _currentLocale?.languageCode != 'vi' ? Colors.transparent : Colors.black12,
              foregroundColor: Colors.black,
              shadowColor: Colors.transparent,
              overlayColor: Colors.blue,
              minimumSize: Size(30, 30),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10)), // ⬅ removes rounding
              ),
            ),
            child: Text('VN', style: TextStyle(fontSize: 10, color: Colors.black))
          ),),
          Padding(padding: EdgeInsetsGeometry.only(left: 0), child: ElevatedButton(
            onPressed: () => widget.onLocaleChange(Locale('en')),
            style: ElevatedButton.styleFrom(
              backgroundColor: _currentLocale?.languageCode != 'en' ? Colors.transparent : Colors.black12,
              foregroundColor: Colors.black,
              overlayColor: Colors.blue,
              shadowColor: Colors.transparent,
              minimumSize: Size(30, 30),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10)), // ⬅ removes rounding
              ),
            ),
            child: Text('EN', style: TextStyle(fontSize: 12, color: Colors.black))
          ),),
          PopupMenuButton<String>(
            tooltip: 'Notifications',
            icon: Icon(Icons.notifications),
            onSelected: (value) {
              // Handle tap
            },
            // handle list notification from server, get moodel notifi
            itemBuilder: (context) => [
              PopupMenuItem(value: '1', child: Text('New message from admin')),
              PopupMenuItem(value: '2', child: Text('Room 203 needs cleaning')),
              PopupMenuItem(value: '3', child: Text('Finance report ready')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              local.hello,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            Text(
              local.welcome(userName),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),

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
                SizedBox(width: 16),
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
                ),
                _buildQuickAction(
                  Icons.shelves,
                  local.resources,
                  local.trackResources,
                  color: Colors.green,
                ),
                _buildQuickAction(Icons.home, local.rooms, local.roomsManagement),
                _buildQuickAction(
                  Icons.currency_exchange,
                  local.finance,
                  local.financeSumary
                ),
              ],
            ),

            SizedBox(height: 24),

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
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          // Add navigation logic here
          switch (index) {
            case 0:
              // Already on HomeScreen, do nothing or maybe pop to root
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResourcesScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoomListScreen()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinanceScreen()),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: local.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: local.users,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shelves),
            label: local.resources,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: local.rooms,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: local.finance,
          ),
        ],
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
          color: Colors.white,
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
                SizedBox(width: 6),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? Colors.blue, size: 28),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
