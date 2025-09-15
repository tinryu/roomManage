import 'package:app_project/screens/tasks/task_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/screens/home/home_screen.dart';
import 'package:app_project/screens/tenants/tenants_list_screen.dart';
import 'package:app_project/screens/assets/assets_list_screen.dart';
import 'package:app_project/screens/rooms/rooms_list_screen.dart';
import 'package:app_project/screens/combie/room_full_list_screen.dart';
import 'package:app_project/screens/payment/payment_list_screen.dart';
import 'package:app_project/screens/settings/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/screens/tenants/login_screen.dart' show LoginScreen;

class MainScreen extends StatefulWidget {
  final void Function(Locale locale) onLocaleChange;
  final void Function(ThemeMode mode) onThemeChange;
  final ThemeMode currentThemeMode;
  final VoidCallback? onResetOnboarding;
  const MainScreen({
    super.key,
    required this.onLocaleChange,
    this.onThemeChange = _noopThemeChange,
    this.currentThemeMode = ThemeMode.light,
    this.onResetOnboarding,
  });

  static void _noopThemeChange(ThemeMode _) {}

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Locale? _currentLocale;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
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
      PaymentScreen(),
      RoomFullListScreen(),
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

    final List<String> titles = [local.home, local.payment, local.rooms];
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/room1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Text(
                'Room mangement',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            ListTile(
              title: const Text('Tasks', textScaler: TextScaler.linear(0.9)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskListScreen(),
                  ),
                );
                _drawerKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              title: const Text('Tenant', textScaler: TextScaler.linear(0.9)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TenantListScreen(),
                  ),
                );
                _drawerKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              title: const Text('Asset', textScaler: TextScaler.linear(0.9)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssetsListScreen(),
                  ),
                );
                _drawerKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              title: const Text('Room', textScaler: TextScaler.linear(0.9)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoomListScreen(),
                  ),
                );
                _drawerKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              title: const Text('Setting', textScaler: TextScaler.linear(0.9)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      onLocaleChange: widget.onLocaleChange,
                      onThemeChange: widget.onThemeChange,
                      currentThemeMode: widget.currentThemeMode,
                    ),
                  ),
                );
                _drawerKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              title: const Text('Logout', textScaler: TextScaler.linear(0.9)),
              onTap: () {
                _signOut(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        centerTitle: true,
        leading: (_selectedIndex > 0)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => {
                  setState(() {
                    _selectedIndex = 0;
                  }),
                },
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => {_drawerKey.currentState?.openDrawer()},
              ),
        title: Text(titles[_selectedIndex]),
        actions: [
          IconButton(
            tooltip: 'Reset onboarding',
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              widget.onResetOnboarding?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Onboarding reset.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          currentIndex: _selectedIndex,
          selectedFontSize: 0,
          unselectedFontSize: 0,
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
              icon: Icon(Icons.currency_exchange),
              label: local.payment,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room),
              label: local.rooms,
            ),
          ],
        ),
      ),
    );
  }
}
