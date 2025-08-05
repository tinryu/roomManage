import 'package:app_project/screens/rooms/room_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/screens/home/home_screen.dart';
import 'package:app_project/screens/user/user_list_screen.dart';
import 'package:app_project/screens/resources/resources_list_screen.dart';
// import 'package:app_project/screens/rooms/room_list_screen.dart';
import 'package:app_project/screens/finance/finance_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/screens/user/login_screen.dart' show LoginScreen;

class MainScreen extends StatefulWidget {
  final void Function(Locale locale) onLocaleChange;
  const MainScreen({super.key, required this.onLocaleChange});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Locale? _currentLocale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newLocale = Localizations.localeOf(context);
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
    }
  }

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(onLocaleChange: widget.onLocaleChange),
      UsersScreen(),
      ResourcesScreen(),
      RoomListScreen(),
      FinanceScreen(),
    ]);
  }

  Future<void> _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    // ignore: no_leading_underscores_for_local_identifiers
    final List<String> _titles = [
      local.home,
      local.users,
      local.resources,
      local.rooms,
      local.finance,
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        leading: Icon(Icons.solar_power, color: Colors.black, size: 25),
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: 0),
            child: ElevatedButton(
              onPressed: () => widget.onLocaleChange(Locale('vi')),
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentLocale?.languageCode != 'vi'
                    ? Colors.transparent
                    : Colors.black12,
                foregroundColor: Colors.black,
                shadowColor: Colors.transparent,
                overlayColor: Colors.blue,
                minimumSize: Size(30, 30),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(10, 10),
                  ), // ⬅ removes rounding
                ),
              ),
              child: Text(
                'VN',
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 0),
            child: ElevatedButton(
              onPressed: () => widget.onLocaleChange(Locale('en')),
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentLocale?.languageCode != 'en'
                    ? Colors.transparent
                    : Colors.black12,
                foregroundColor: Colors.black,
                overlayColor: Colors.blue,
                shadowColor: Colors.transparent,
                minimumSize: Size(30, 30),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(10, 10),
                  ), // ⬅ removes rounding
                ),
              ),
              child: Text(
                'EN',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ),
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
          ElevatedButton(
            onPressed: () => _signOut(context),
            child: const Text('Sign Out'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: local.rooms),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: local.finance,
          ),
        ],
      ),
    );
  }
}
