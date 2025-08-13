import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/screens/home/home_screen.dart';
import 'package:app_project/screens/tenants/tenants_list_screen.dart';
import 'package:app_project/screens/assets/assets_list_screen.dart';
import 'package:app_project/screens/rooms/room_list_screen.dart';
import 'package:app_project/screens/finance/finance_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/screens/tenants/login_screen.dart' show LoginScreen;

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
      TenantListScreen(),
      AssetsListScreen(),
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
    final lang = local.localeName == 'vi' ? 'en' : 'vi';
    final List<String> titles = [
      local.home,
      local.tenants,
      local.assets,
      local.rooms,
      local.finance,
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        leading: Icon(Icons.solar_power, size: 25),
        title: Text(titles[_selectedIndex]),
        elevation: 0,
        actionsPadding: EdgeInsets.zero,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => widget.onLocaleChange(Locale(lang)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(25, 25),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(10, 10),
                    ), // ⬅ removes rounding
                  ),
                ),
                child: Text(
                  _currentLocale?.languageCode != 'vi' ? 'VN' : 'EN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textScaler: TextScaler.linear(0.8),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                tooltip: 'User',
                icon: Icon(Icons.person, size: 18),
                // handle list notification from server, get moodel notifi
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Profile', textScaler: TextScaler.linear(0.8)),
                    onTap: () => {},
                  ),
                  PopupMenuItem(
                    child: Text('Settings', textScaler: TextScaler.linear(0.8)),
                    onTap: () => {},
                  ),
                  PopupMenuItem(
                    child: Text('Logout', textScaler: TextScaler.linear(0.8)),
                    onTap: () => {_signOut(context)},
                  ),
                ],
              ),
            ],
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
            label: local.tenants,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shelves),
            label: local.assets,
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
