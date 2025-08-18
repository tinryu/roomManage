import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/screens/tenants/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Locale locale) onLocaleChange;
  final void Function(ThemeMode mode)? onThemeChange;
  final ThemeMode? currentThemeMode;
  const SettingsScreen({
    super.key,
    required this.onLocaleChange,
    this.onThemeChange,
    this.currentThemeMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Locale _currentLocale;
  String _dateFormatPattern = 'yyyy-MM-dd';
  String _currencyCode = 'VND';
  late ThemeMode _themeMode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocale = Localizations.localeOf(context);
    _themeMode = widget.currentThemeMode ?? ThemeMode.light;
  }

  Future<void> _pickCurrency() async {
    // Common currency options with symbols
    final options = <Map<String, String>>[
      {'code': 'VND', 'symbol': '₫'},
      {'code': 'USD', 'symbol': r'$'},
      {'code': 'EUR', 'symbol': '€'},
      {'code': 'JPY', 'symbol': '¥'},
    ];

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: options.map((opt) {
              final code = opt['code']!;
              final symbol = opt['symbol']!;
              final selected = _currencyCode == code;
              // Example amount preview
              final nf = NumberFormat.currency(
                symbol: symbol,
                decimalDigits: code == 'JPY' || code == 'VND' ? 0 : 2,
              );
              final preview = nf.format(2500000);

              return ListTile(
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? Colors.lightBlue : null,
                ),
                title: Text('$code ($symbol) '),
                subtitle: Text(preview, style: TextStyle(color: Colors.grey)),
                onTap: () {
                  setState(() => _currencyCode = code);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _pickTheme() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _themeTile('Light', ThemeMode.light),
              _themeTile('Dark', ThemeMode.dark),
              _themeTile('System', ThemeMode.system),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _themeTile(String label, ThemeMode mode) {
    final selected = _themeMode == mode;
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? Colors.lightBlue : null,
      ),
      title: Text(label),
      onTap: () {
        setState(() => _themeMode = mode);
        widget.onThemeChange?.call(mode);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _pickLanguage() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English (EN)'),
                trailing: _currentLocale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.lightBlue)
                    : null,
                onTap: () {
                  widget.onLocaleChange(const Locale('en'));
                  setState(() => _currentLocale = const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Tiếng Việt (VI)'),
                trailing: _currentLocale.languageCode == 'vi'
                    ? const Icon(Icons.check, color: Colors.lightBlue)
                    : null,
                onTap: () {
                  widget.onLocaleChange(const Locale('vi'));
                  setState(() => _currentLocale = const Locale('vi'));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _pickDateFormat() async {
    final patterns = <String, String>{
      'yyyy-MM-dd': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'dd/MM/yyyy': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'MM-dd-yyyy': DateFormat('MM-dd-yyyy').format(DateTime.now()),
      'MMM d, y': DateFormat('MMM d, y').format(DateTime.now()),
      'yyyy-MM-dd HH:mm': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    };

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: patterns.entries.map((e) {
              final pattern = e.key;
              final preview = e.value;
              final selected = _dateFormatPattern == pattern;
              return ListTile(
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? Colors.lightBlue : null,
                ),
                title: Text(pattern),
                subtitle: Text(preview),
                onTap: () {
                  setState(() => _dateFormatPattern = pattern);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // General
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: Text(_currentLocale.languageCode.toUpperCase()),
                  onTap: _pickLanguage,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Theme'),
                  subtitle: Text(_themeMode.name),
                  onTap: _pickTheme,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Date format'),
                  subtitle: Text(
                    DateFormat(_dateFormatPattern).format(DateTime.now()),
                  ),
                  onTap: _pickDateFormat,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.monetization_on_outlined),
                  title: const Text('Currency'),
                  subtitle: Text(_currencyCode),
                  onTap: _pickCurrency,
                ),
              ],
            ),
          ),

          // Notifications
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: true,
                  onChanged: (val) {}, // placeholder
                  title: const Text('Payment reminders'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: true,
                  onChanged: (val) {}, // placeholder
                  title: const Text('Task reminders'),
                ),
              ],
            ),
          ),

          // Account
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: _signOut,
                ),
              ],
            ),
          ),

          // About
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              subtitle: const Text('Room Manager • v1.0.0'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
