import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/screens/home/home_screen.dart';
import 'package:app_project/screens/combie/room_full_list_screen.dart';
import 'package:app_project/screens/payment/payment_list_screen.dart';
import 'package:app_project/screens/assets/assets_list_screen.dart';
import 'package:app_project/screens/tenants/tenants_list_screen.dart';
import 'package:app_project/screens/settings/settings_screen.dart';

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newLocale = Localizations.localeOf(context);
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
    }
  }

  final List<Widget> _screens = [];

  void _showQuickActionsMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.inventory_2, color: Colors.lightBlue),
            title: Text('Asset'),
            contentPadding: EdgeInsets.zero,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssetsListScreen()),
            );
          },
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.person_add, color: Colors.lightBlue),
            title: Text('Tenant'),
            contentPadding: EdgeInsets.zero,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TenantListScreen()),
            );
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(onLocaleChange: widget.onLocaleChange),
      PaymentScreen(),
      RoomFullListScreen(),
      SettingsScreen(onLocaleChange: widget.onLocaleChange),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: ClipRRect(
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
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: local.profile,
            ),
          ],
        ),
      ),
    );
  }
}
